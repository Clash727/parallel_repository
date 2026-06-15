//原始代码
#include "PCFG.h"
#include <algorithm>
#include <cstdlib>
#include <cuda_runtime.h>
#include <limits>
#include <numeric>
using namespace std;

namespace
{
constexpr int BASIC_GPU_ACCELERATION_THRESHOLD = 1000;
constexpr int ADAPTIVE_GPU_MIN_VALUES = 50000;
constexpr size_t ADAPTIVE_GPU_MIN_OUTPUT_BYTES = 128ULL * 1024ULL;
constexpr int DEFAULT_PT_BATCH_SIZE = 4;
constexpr size_t MAX_GPU_INPUT_BYTES = 128ULL * 1024ULL * 1024ULL;
constexpr size_t MAX_GPU_OUTPUT_BYTES = 512ULL * 1024ULL * 1024ULL;

struct GpuTaskProfile
{
    int count = 0;
    size_t total_input_bytes = 0;
    size_t max_value_len = 0;
    size_t output_stride_size = 0;
    size_t output_bytes = 0;
};

struct GpuGenerationStats
{
    long long gpu_calls = 0;
    long long cpu_calls = 0;
    long long gpu_generated = 0;
    long long cpu_generated = 0;
    long long skipped_small = 0;
    long long skipped_memory = 0;
    long long failed_gpu = 0;
    long long async_gpu_calls = 0;
    long long overlapped_prepared = 0;
    long long pt_batch_calls = 0;
    long long pt_batch_items = 0;
};

GpuGenerationStats g_gpu_stats;

int getAdaptiveMinValues();
size_t getAdaptiveMinOutputBytes();

struct GpuStatsPrinter
{
    ~GpuStatsPrinter()
    {
        cout << "GPU stats: calls=" << g_gpu_stats.gpu_calls
             << ", generated=" << g_gpu_stats.gpu_generated
             << ", cpu_calls=" << g_gpu_stats.cpu_calls
             << ", cpu_generated=" << g_gpu_stats.cpu_generated
             << ", skipped_small=" << g_gpu_stats.skipped_small
             << ", skipped_memory=" << g_gpu_stats.skipped_memory
             << ", failed_gpu=" << g_gpu_stats.failed_gpu
             << ", async_gpu_calls=" << g_gpu_stats.async_gpu_calls
             << ", overlapped_prepared=" << g_gpu_stats.overlapped_prepared
             << ", pt_batch_calls=" << g_gpu_stats.pt_batch_calls
             << ", pt_batch_items=" << g_gpu_stats.pt_batch_items
             << ", min_values=" << getAdaptiveMinValues()
             << ", min_output_bytes=" << getAdaptiveMinOutputBytes()
             << endl;
    }
};

GpuStatsPrinter g_gpu_stats_printer;

int getAdaptiveMinValues()
{
    const char *value = getenv("LAB5_GPU_MIN_VALUES");
    if (value == nullptr)
    {
        return ADAPTIVE_GPU_MIN_VALUES;
    }

    int parsed = atoi(value);
    return parsed > 0 ? parsed : ADAPTIVE_GPU_MIN_VALUES;
}

size_t getAdaptiveMinOutputBytes()
{
    const char *value = getenv("LAB5_GPU_MIN_OUTPUT_BYTES");
    if (value == nullptr)
    {
        return ADAPTIVE_GPU_MIN_OUTPUT_BYTES;
    }

    unsigned long long parsed = strtoull(value, nullptr, 10);
    return parsed > 0 ? static_cast<size_t>(parsed) : ADAPTIVE_GPU_MIN_OUTPUT_BYTES;
}

int getPTBatchSize()
{
    const char *value = getenv("LAB5_PT_BATCH_SIZE");
    if (value == nullptr)
    {
        return DEFAULT_PT_BATCH_SIZE;
    }

    int parsed = atoi(value);
    if (parsed < 1)
    {
        return DEFAULT_PT_BATCH_SIZE;
    }
    return min(parsed, 128);
}

GpuTaskProfile buildTaskProfile(const vector<string> &values, const string &prefix)
{
    GpuTaskProfile profile;
    profile.count = static_cast<int>(values.size());

    for (const string &value : values)
    {
        profile.total_input_bytes += value.size();
        profile.max_value_len = max(profile.max_value_len, value.size());
    }

    profile.output_stride_size = prefix.size() + profile.max_value_len + 1;
    profile.output_bytes = profile.output_stride_size * static_cast<size_t>(profile.count);
    return profile;
}

bool shouldUseGPU(const GpuTaskProfile &profile)
{
    if (profile.count < getAdaptiveMinValues() ||
        profile.output_bytes < getAdaptiveMinOutputBytes())
    {
        g_gpu_stats.skipped_small += 1;
        return false;
    }

    if (profile.total_input_bytes > MAX_GPU_INPUT_BYTES ||
        profile.output_bytes > MAX_GPU_OUTPUT_BYTES ||
        profile.output_stride_size > static_cast<size_t>(numeric_limits<int>::max()) ||
        profile.total_input_bytes > static_cast<size_t>(numeric_limits<int>::max()))
    {
        g_gpu_stats.skipped_memory += 1;
        return false;
    }

    return true;
}

__global__ void string_concatenation_kernel(
    const char *input_data,
    const int *offsets,
    const int *lengths,
    const char *prefix,
    int prefix_len,
    char *output_data,
    int output_stride,
    int count)
{
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    if (idx >= count)
    {
        return;
    }

    char *dst = output_data + static_cast<size_t>(idx) * output_stride;
    for (int i = 0; i < prefix_len; i += 1)
    {
        dst[i] = prefix[i];
    }

    int input_offset = offsets[idx];
    int input_len = lengths[idx];
    for (int i = 0; i < input_len; i += 1)
    {
        dst[prefix_len + i] = input_data[input_offset + i];
    }
    dst[prefix_len + input_len] = '\0';
}

bool processWithGPU(
    const vector<string> &values,
    const string &prefix,
    const GpuTaskProfile &profile,
    vector<string> &results)
{
    int count = profile.count;
    if (count <= 0)
    {
        results.clear();
        return true;
    }

    if (profile.total_input_bytes > MAX_GPU_INPUT_BYTES ||
        profile.output_bytes > MAX_GPU_OUTPUT_BYTES ||
        profile.output_stride_size > static_cast<size_t>(numeric_limits<int>::max()) ||
        profile.total_input_bytes > static_cast<size_t>(numeric_limits<int>::max()))
    {
        return false;
    }

    size_t host_input_bytes = profile.total_input_bytes == 0 ? 1 : profile.total_input_bytes;
    size_t host_prefix_bytes = prefix.empty() ? 1 : prefix.size();

    char *host_input = nullptr;
    int *host_offsets = nullptr;
    int *host_lengths = nullptr;
    char *host_prefix = nullptr;
    char *host_output = nullptr;

    char *device_input = nullptr;
    int *device_offsets = nullptr;
    int *device_lengths = nullptr;
    char *device_prefix = nullptr;
    char *device_output = nullptr;
    cudaStream_t stream = nullptr;

    auto cleanup = [&]() {
        if (stream != nullptr)
        {
            cudaStreamSynchronize(stream);
            cudaStreamDestroy(stream);
        }

        cudaFree(device_input);
        cudaFree(device_offsets);
        cudaFree(device_lengths);
        cudaFree(device_prefix);
        cudaFree(device_output);

        if (host_input != nullptr)
        {
            cudaFreeHost(host_input);
        }
        if (host_offsets != nullptr)
        {
            cudaFreeHost(host_offsets);
        }
        if (host_lengths != nullptr)
        {
            cudaFreeHost(host_lengths);
        }
        if (host_prefix != nullptr)
        {
            cudaFreeHost(host_prefix);
        }
        if (host_output != nullptr)
        {
            cudaFreeHost(host_output);
        }
    };

    cudaError_t status = cudaMallocHost(&host_input, host_input_bytes);
    if (status != cudaSuccess)
    {
        cleanup();
        return false;
    }
    status = cudaMallocHost(&host_offsets, sizeof(int) * static_cast<size_t>(count));
    if (status != cudaSuccess)
    {
        cleanup();
        return false;
    }
    status = cudaMallocHost(&host_lengths, sizeof(int) * static_cast<size_t>(count));
    if (status != cudaSuccess)
    {
        cleanup();
        return false;
    }
    status = cudaMallocHost(&host_prefix, host_prefix_bytes);
    if (status != cudaSuccess)
    {
        cleanup();
        return false;
    }
    status = cudaMallocHost(&host_output, profile.output_bytes);
    if (status != cudaSuccess)
    {
        cleanup();
        return false;
    }

    size_t offset = 0;
    for (int i = 0; i < count; i += 1)
    {
        host_offsets[i] = static_cast<int>(offset);
        host_lengths[i] = static_cast<int>(values[i].size());
        if (!values[i].empty())
        {
            memcpy(host_input + offset, values[i].data(), values[i].size());
        }
        offset += values[i].size();
    }

    if (prefix.empty())
    {
        host_prefix[0] = '\0';
    }
    else
    {
        memcpy(host_prefix, prefix.data(), prefix.size());
    }

    status = cudaMalloc(&device_input, host_input_bytes);
    if (status != cudaSuccess)
    {
        cleanup();
        return false;
    }
    status = cudaMalloc(&device_offsets, sizeof(int) * static_cast<size_t>(count));
    if (status != cudaSuccess)
    {
        cleanup();
        return false;
    }
    status = cudaMalloc(&device_lengths, sizeof(int) * static_cast<size_t>(count));
    if (status != cudaSuccess)
    {
        cleanup();
        return false;
    }
    status = cudaMalloc(&device_prefix, host_prefix_bytes);
    if (status != cudaSuccess)
    {
        cleanup();
        return false;
    }
    status = cudaMalloc(&device_output, profile.output_bytes);
    if (status != cudaSuccess)
    {
        cleanup();
        return false;
    }

    status = cudaStreamCreateWithFlags(&stream, cudaStreamNonBlocking);
    if (status != cudaSuccess)
    {
        cleanup();
        return false;
    }

    status = cudaMemcpyAsync(device_input, host_input, host_input_bytes, cudaMemcpyHostToDevice, stream);
    if (status != cudaSuccess)
    {
        cleanup();
        return false;
    }
    status = cudaMemcpyAsync(device_offsets, host_offsets, sizeof(int) * static_cast<size_t>(count), cudaMemcpyHostToDevice, stream);
    if (status != cudaSuccess)
    {
        cleanup();
        return false;
    }
    status = cudaMemcpyAsync(device_lengths, host_lengths, sizeof(int) * static_cast<size_t>(count), cudaMemcpyHostToDevice, stream);
    if (status != cudaSuccess)
    {
        cleanup();
        return false;
    }
    status = cudaMemcpyAsync(device_prefix, host_prefix, host_prefix_bytes, cudaMemcpyHostToDevice, stream);
    if (status != cudaSuccess)
    {
        cleanup();
        return false;
    }

    int threads_per_block = 256;
    int blocks = (count + threads_per_block - 1) / threads_per_block;
    string_concatenation_kernel<<<blocks, threads_per_block, 0, stream>>>(
        device_input,
        device_offsets,
        device_lengths,
        device_prefix,
        static_cast<int>(prefix.size()),
        device_output,
        static_cast<int>(profile.output_stride_size),
        count);

    status = cudaGetLastError();
    if (status != cudaSuccess)
    {
        cleanup();
        return false;
    }

    status = cudaMemcpyAsync(host_output, device_output, profile.output_bytes, cudaMemcpyDeviceToHost, stream);
    if (status != cudaSuccess)
    {
        cleanup();
        return false;
    }

    vector<int> result_lengths(count);
    results.clear();
    results.reserve(count);
    for (int i = 0; i < count; i += 1)
    {
        result_lengths[i] = static_cast<int>(prefix.size()) + host_lengths[i];
    }

    g_gpu_stats.overlapped_prepared += count;

    status = cudaStreamSynchronize(stream);
    if (status != cudaSuccess)
    {
        cleanup();
        return false;
    }
    cudaStreamDestroy(stream);
    stream = nullptr;

    for (int i = 0; i < count; i += 1)
    {
        results.emplace_back(
            host_output + static_cast<size_t>(i) * profile.output_stride_size,
            static_cast<size_t>(result_lengths[i]));
    }

    g_gpu_stats.async_gpu_calls += 1;

    cleanup();
    return true;
}

void insertPTByProbability(vector<PT> &priority, const PT &pt)
{
    if (priority.empty())
    {
        priority.emplace_back(pt);
        return;
    }

    for (auto iter = priority.begin(); iter != priority.end(); iter++)
    {
        if (iter != priority.end() - 1 && iter != priority.begin())
        {
            if (pt.prob <= iter->prob && pt.prob > (iter + 1)->prob)
            {
                priority.emplace(iter + 1, pt);
                break;
            }
        }
        if (iter == priority.end() - 1)
        {
            priority.emplace_back(pt);
            break;
        }
        if (iter == priority.begin() && iter->prob < pt.prob)
        {
            priority.emplace(iter, pt);
            break;
        }
    }
}
}

void PriorityQueue::CalProb(PT &pt)
{
    // 计算PriorityQueue里面一个PT的流程如下：
    // 1. 首先需要计算一个PT本身的概率。例如，L6S1的概率为0.15
    // 2. 需要注意的是，Queue里面的PT不是“纯粹的”PT，而是除了最后一个segment以外，全部被value实例化的PT
    // 3. 所以，对于L6S1而言，其在Queue里面的实际PT可能是123456S1，其中“123456”为L6的一个具体value。
    // 4. 这个时候就需要计算123456在L6中出现的概率了。假设123456在所有L6 segment中的概率为0.1，那么123456S1的概率就是0.1*0.15

    // 计算一个PT本身的概率。后续所有具体segment value的概率，直接累乘在这个初始概率值上
    pt.prob = pt.preterm_prob;

    // index: 标注当前segment在PT中的位置
    int index = 0;


    for (int idx : pt.curr_indices)
    {
        // pt.content[index].PrintSeg();
        if (pt.content[index].type == 1)
        {
            // 下面这行代码的意义：
            // pt.content[index]：目前需要计算概率的segment
            // m.FindLetter(seg): 找到一个letter segment在模型中的对应下标
            // m.letters[m.FindLetter(seg)]：一个letter segment在模型中对应的所有统计数据
            // m.letters[m.FindLetter(seg)].ordered_values：一个letter segment在模型中，所有value的总数目
            pt.prob *= m.letters[m.FindLetter(pt.content[index])].ordered_freqs[idx];
            pt.prob /= m.letters[m.FindLetter(pt.content[index])].total_freq;
            // cout << m.letters[m.FindLetter(pt.content[index])].ordered_freqs[idx] << endl;
            // cout << m.letters[m.FindLetter(pt.content[index])].total_freq << endl;
        }
        if (pt.content[index].type == 2)
        {
            pt.prob *= m.digits[m.FindDigit(pt.content[index])].ordered_freqs[idx];
            pt.prob /= m.digits[m.FindDigit(pt.content[index])].total_freq;
            // cout << m.digits[m.FindDigit(pt.content[index])].ordered_freqs[idx] << endl;
            // cout << m.digits[m.FindDigit(pt.content[index])].total_freq << endl;
        }
        if (pt.content[index].type == 3)
        {
            pt.prob *= m.symbols[m.FindSymbol(pt.content[index])].ordered_freqs[idx];
            pt.prob /= m.symbols[m.FindSymbol(pt.content[index])].total_freq;
            // cout << m.symbols[m.FindSymbol(pt.content[index])].ordered_freqs[idx] << endl;
            // cout << m.symbols[m.FindSymbol(pt.content[index])].total_freq << endl;
        }
        index += 1;
    }
    // cout << pt.prob << endl;
}

void PriorityQueue::init()
{
    // cout << m.ordered_pts.size() << endl;
    // 用所有可能的PT，按概率降序填满整个优先队列
    for (PT pt : m.ordered_pts)
    {
        for (segment seg : pt.content)
        {
            if (seg.type == 1)
            {
                // 下面这行代码的意义：
                // max_indices用来表示PT中各个segment的可能数目。例如，L6S1中，假设模型统计到了100个L6，那么L6对应的最大下标就是99
                // （但由于后面采用了"<"的比较关系，所以其实max_indices[0]=100）
                // m.FindLetter(seg): 找到一个letter segment在模型中的对应下标
                // m.letters[m.FindLetter(seg)]：一个letter segment在模型中对应的所有统计数据
                // m.letters[m.FindLetter(seg)].ordered_values：一个letter segment在模型中，所有value的总数目
                pt.max_indices.emplace_back(static_cast<int>(m.letters[m.FindLetter(seg)].ordered_values.size()));
            }
            if (seg.type == 2)
            {
                pt.max_indices.emplace_back(static_cast<int>(m.digits[m.FindDigit(seg)].ordered_values.size()));
            }
            if (seg.type == 3)
            {
                pt.max_indices.emplace_back(static_cast<int>(m.symbols[m.FindSymbol(seg)].ordered_values.size()));
            }
        }
        pt.preterm_prob = float(m.preterm_freq[m.FindPT(pt)]) / m.total_preterm;
        // pt.PrintPT();
        // cout << " " << m.preterm_freq[m.FindPT(pt)] << " " << m.total_preterm << " " << pt.preterm_prob << endl;

        // 计算当前pt的概率
        CalProb(pt);
        // 将PT放入优先队列
        priority.emplace_back(pt);
    }
    // cout << "priority size:" << priority.size() << endl;
}

void PriorityQueue::PopNext()
{
    if (priority.empty())
    {
        return;
    }

    int batch_size = getPTBatchSize();
    if (batch_size <= 1)
    {
        g_gpu_stats.pt_batch_calls += 1;
        g_gpu_stats.pt_batch_items += 1;

        Generate(priority.front());

        vector<PT> new_pts = priority.front().NewPTs();
        for (PT new_pt : new_pts)
        {
            CalProb(new_pt);
            insertPTByProbability(priority, new_pt);
        }
        priority.erase(priority.begin());
        return;
    }

    vector<PT> batch_pts;
    batch_pts.reserve(batch_size);
    for (int i = 0; i < batch_size && !priority.empty(); i += 1)
    {
        PT current = priority.front();
        batch_pts.emplace_back(current);

        vector<PT> new_pts = priority.front().NewPTs();
        for (PT new_pt : new_pts)
        {
            CalProb(new_pt);
            insertPTByProbability(priority, new_pt);
        }
        priority.erase(priority.begin());
    }

    g_gpu_stats.pt_batch_calls += 1;
    g_gpu_stats.pt_batch_items += static_cast<long long>(batch_pts.size());

    for (PT pt : batch_pts)
    {
        // 按照收集时的优先队列顺序批量生成 guesses。
        Generate(pt);
    }
}

// 这个函数你就算看不懂，对并行算法的实现影响也不大
// 当然如果你想做一个基于多优先队列的并行算法，可能得稍微看一看了
vector<PT> PT::NewPTs()
{
    // 存储生成的新PT
    vector<PT> res;

    // 假如这个PT只有一个segment
    // 那么这个segment的所有value在出队前就已经被遍历完毕，并作为猜测输出
    // 因此，所有这个PT可能对应的口令猜测已经遍历完成，无需生成新的PT
    if (content.size() == 1)
    {
        return res;
    }
    else
    {
        // 最初的pivot值。我们将更改位置下标大于等于这个pivot值的segment的值（最后一个segment除外），并且一次只更改一个segment
        // 上面这句话里是不是有没看懂的地方？接着往下看你应该会更明白
        int init_pivot = pivot;

        // 开始遍历所有位置值大于等于init_pivot值的segment
        // 注意i < curr_indices.size() - 1，也就是除去了最后一个segment（这个segment的赋值预留给并行环节）
        for (int i = pivot; i < curr_indices.size() - 1; i += 1)
        {
            // curr_indices: 标记各segment目前的value在模型里对应的下标
            curr_indices[i] += 1;

            // max_indices：标记各segment在模型中一共有多少个value
            if (curr_indices[i] < max_indices[i])
            {
                // 更新pivot值
                pivot = i;
                res.emplace_back(*this);
            }

            // 这个步骤对于你理解pivot的作用、新PT生成的过程而言，至关重要
            curr_indices[i] -= 1;
        }
        pivot = init_pivot;
        return res;
    }

    return res;
}


// 这个函数是PCFG并行化算法的主要载体
// 尽量看懂，然后进行并行实现
void PriorityQueue::Generate(PT pt)
{
    // 计算PT的概率，这里主要是给PT的概率进行初始化
    CalProb(pt);

    // 对于只有一个segment的PT，直接遍历生成其中的所有value即可
    if (pt.content.size() == 1)
    {
        // 指向最后一个segment的指针，这个指针实际指向模型中的统计数据
        segment *a;
        // 在模型中定位到这个segment
        if (pt.content[0].type == 1)
        {
            a = &m.letters[m.FindLetter(pt.content[0])];
        }
        if (pt.content[0].type == 2)
        {
            a = &m.digits[m.FindDigit(pt.content[0])];
        }
        if (pt.content[0].type == 3)
        {
            a = &m.symbols[m.FindSymbol(pt.content[0])];
        }
        
        // Multi-thread TODO：
        // 这个for循环就是你需要进行并行化的主要部分了，特别是在多线程&GPU编程任务中
        // 可以看到，这个循环本质上就是把模型中一个segment的所有value，赋值到PT中，形成一系列新的猜测
        // 这个过程是可以高度并行化的
        int num_values = pt.max_indices[0];
        GpuTaskProfile profile = buildTaskProfile(a->ordered_values, "");
        if (num_values >= BASIC_GPU_ACCELERATION_THRESHOLD && shouldUseGPU(profile))
        {
            vector<string> gpu_results;
            if (processWithGPU(a->ordered_values, "", profile, gpu_results))
            {
                guesses.insert(guesses.end(), gpu_results.begin(), gpu_results.end());
                total_guesses += static_cast<int>(gpu_results.size());
                g_gpu_stats.gpu_calls += 1;
                g_gpu_stats.gpu_generated += static_cast<long long>(gpu_results.size());
                return;
            }
            g_gpu_stats.failed_gpu += 1;
        }

        g_gpu_stats.cpu_calls += 1;
        g_gpu_stats.cpu_generated += num_values;
        for (int i = 0; i < num_values; i += 1)
        {
            string guess = a->ordered_values[i];
            // cout << guess << endl;
            guesses.emplace_back(guess);
            total_guesses += 1;
        }
    }
    else
    {
        string guess;
        int seg_idx = 0;
        // 这个for循环的作用：给当前PT的所有segment赋予实际的值（最后一个segment除外）
        // segment值根据curr_indices中对应的值加以确定
        // 这个for循环你看不懂也没太大问题，并行算法不涉及这里的加速
        for (int idx : pt.curr_indices)
        {
            if (pt.content[seg_idx].type == 1)
            {
                guess += m.letters[m.FindLetter(pt.content[seg_idx])].ordered_values[idx];
            }
            if (pt.content[seg_idx].type == 2)
            {
                guess += m.digits[m.FindDigit(pt.content[seg_idx])].ordered_values[idx];
            }
            if (pt.content[seg_idx].type == 3)
            {
                guess += m.symbols[m.FindSymbol(pt.content[seg_idx])].ordered_values[idx];
            }
            seg_idx += 1;
            if (seg_idx == pt.content.size() - 1)
            {
                break;
            }
        }

        // 指向最后一个segment的指针，这个指针实际指向模型中的统计数据
        segment *a;
        if (pt.content[pt.content.size() - 1].type == 1)
        {
            a = &m.letters[m.FindLetter(pt.content[pt.content.size() - 1])];
        }
        if (pt.content[pt.content.size() - 1].type == 2)
        {
            a = &m.digits[m.FindDigit(pt.content[pt.content.size() - 1])];
        }
        if (pt.content[pt.content.size() - 1].type == 3)
        {
            a = &m.symbols[m.FindSymbol(pt.content[pt.content.size() - 1])];
        }
        
        // Multi-thread TODO：
        // 这个for循环就是你需要进行并行化的主要部分了，特别是在多线程&GPU编程任务中
        // 可以看到，这个循环本质上就是把模型中一个segment的所有value，赋值到PT中，形成一系列新的猜测
        // 这个过程是可以高度并行化的
        int last = pt.content.size() - 1;
        int num_values = pt.max_indices[last];
        GpuTaskProfile profile = buildTaskProfile(a->ordered_values, guess);
        if (num_values >= BASIC_GPU_ACCELERATION_THRESHOLD && shouldUseGPU(profile))
        {
            vector<string> gpu_results;
            if (processWithGPU(a->ordered_values, guess, profile, gpu_results))
            {
                guesses.insert(guesses.end(), gpu_results.begin(), gpu_results.end());
                total_guesses += static_cast<int>(gpu_results.size());
                g_gpu_stats.gpu_calls += 1;
                g_gpu_stats.gpu_generated += static_cast<long long>(gpu_results.size());
                return;
            }
            g_gpu_stats.failed_gpu += 1;
        }

        g_gpu_stats.cpu_calls += 1;
        g_gpu_stats.cpu_generated += num_values;
        for (int i = 0; i < num_values; i += 1)
        {
            string temp = guess + a->ordered_values[i];
            // cout << temp << endl;
            guesses.emplace_back(temp);
            total_guesses += 1;
        }
    }
}
