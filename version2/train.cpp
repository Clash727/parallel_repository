#include "PCFG.h"
#include <fstream>
#include <cctype>
#include <algorithm>
#include <cstdlib>

// 这个文件里面的各函数你都不需要完全理解，甚至根本不需要看
// 从学术价值上讲，加速模型的训练过程是一个没什么价值的问题，因为我们一般假定统计学模型的训练成本较低
// 但是，假如你是一个投稿时顶着ddl做实验的倒霉研究生/实习生，提高训练速度就可以大幅节省你的时间了
// 所以如果你愿意，也可以尝试用多线程加速训练过程

/**
 * 怎么加速PCFG训练过程？据助教所知，没有公开文献提出过有效的加速方法（因为这么做基本无学术价值）
 * 
 * 但是统计学模型好就好在其数据是可加的。例如，假如我把数据集拆分成4个部分，并行训练4个不同的模型。
 * 然后我可以直接将四个模型的统计数据进行简单加和，就得到了和串行训练相同的模型了。
 * 
 * 说起来容易，做起来不一定容易，你可能会碰到一系列具体的工程问题。如果你决定加速训练过程，祝你好运！
 * 
 */

static int ReadTrainEnvInt(const char *name, int fallback, int min_value, int max_value)
{
    const char *value = getenv(name);
    if (value == nullptr)
    {
        return fallback;
    }

    int parsed = atoi(value);
    if (parsed < min_value)
    {
        return fallback;
    }
    if (parsed > max_value)
    {
        return max_value;
    }
    return parsed;
}

static int TrainThreads()
{
    return ReadTrainEnvInt("HYBRID_TRAIN_THREADS", 2, 1, 32);
}

static void MergeSegmentValues(segment &dst, const segment &src)
{
    for (const auto &kv : src.values)
    {
        const string &value = kv.first;
        int src_id = kv.second;
        int count = src.freqs.at(src_id);

        auto it = dst.values.find(value);
        if (it == dst.values.end())
        {
            int new_id = dst.values.size();
            dst.values[value] = new_id;
            dst.freqs[new_id] = count;
        }
        else
        {
            dst.freqs[it->second] += count;
        }
    }
}

static void MergeOneSegment(model &dst, const segment &src_seg, int count)
{
    int id = -1;
    vector<segment> *segments = nullptr;
    unordered_map<int, int> *freqs = nullptr;

    if (src_seg.type == 1)
    {
        id = dst.FindLetter(src_seg);
        segments = &dst.letters;
        freqs = &dst.letters_freq;
        if (id == -1)
        {
            id = dst.GetNextLettersID();
            segments->emplace_back(src_seg.type, src_seg.length);
            (*freqs)[id] = 0;
        }
    }
    else if (src_seg.type == 2)
    {
        id = dst.FindDigit(src_seg);
        segments = &dst.digits;
        freqs = &dst.digits_freq;
        if (id == -1)
        {
            id = dst.GetNextDigitsID();
            segments->emplace_back(src_seg.type, src_seg.length);
            (*freqs)[id] = 0;
        }
    }
    else
    {
        id = dst.FindSymbol(src_seg);
        segments = &dst.symbols;
        freqs = &dst.symbols_freq;
        if (id == -1)
        {
            id = dst.GetNextSymbolsID();
            segments->emplace_back(src_seg.type, src_seg.length);
            (*freqs)[id] = 0;
        }
    }

    (*freqs)[id] += count;
    MergeSegmentValues((*segments)[id], src_seg);
}

static void MergeSegments(model &dst, const model &src)
{
    for (int i = 0; i < (int)src.letters.size(); ++i)
    {
        auto it = src.letters_freq.find(i);
        if (it != src.letters_freq.end())
        {
            MergeOneSegment(dst, src.letters[i], it->second);
        }
    }

    for (int i = 0; i < (int)src.digits.size(); ++i)
    {
        auto it = src.digits_freq.find(i);
        if (it != src.digits_freq.end())
        {
            MergeOneSegment(dst, src.digits[i], it->second);
        }
    }

    for (int i = 0; i < (int)src.symbols.size(); ++i)
    {
        auto it = src.symbols_freq.find(i);
        if (it != src.symbols_freq.end())
        {
            MergeOneSegment(dst, src.symbols[i], it->second);
        }
    }
}

static void MergePreterminals(model &dst, const model &src)
{
    dst.total_preterm += src.total_preterm;

    for (int i = 0; i < (int)src.preterminals.size(); ++i)
    {
        auto it = src.preterm_freq.find(i);
        if (it == src.preterm_freq.end())
        {
            continue;
        }

        PT pt = src.preterminals[i];
        int id = dst.FindPT(pt);
        if (id == -1)
        {
            id = dst.GetNextPretermID();
            dst.preterminals.emplace_back(pt);
            dst.preterm_freq[id] = 0;
        }

        dst.preterm_freq[id] += it->second;
    }
}

static void MergeModel(model &dst, const model &src)
{
    MergePreterminals(dst, src);
    MergeSegments(dst, src);
}

// 训练的wrapper，实际上就是读取训练集
void model::train(string path)
{
    string pw;
    ifstream train_set(path);
    vector<string> passwords;
    int lines = 0;
   if (verbose)
    {
        cout << "Training..." << endl;
        cout << "Training phase 1: reading and parsing passwords..." << endl;
    }
    while (train_set >> pw)
    {
        lines += 1;
        if (lines % 10000 == 0)
        {
            if (verbose)
            {
                cout << "Lines processed: " << lines << endl;
            }
            // 在这里更改读取的训练集口令上限
            if (lines > 3000000)
            {
                break;
            }
        }
        // 读取单个口令之后，就可以将其扔进parse函数进行PT/segment的分割、识别、统计了
        passwords.emplace_back(pw);
    }

    int threads = TrainThreads();
    vector<model> local_models(threads);
    int password_count = passwords.size();

    for (int i = 0; i < threads; ++i)
    {
        local_models[i].verbose = false;
    }

    if (threads <= 1)
    {
        for (int i = 0; i < password_count; ++i)
        {
            parse(passwords[i]);
        }
    }
    else
    {
#pragma omp parallel for num_threads(threads) schedule(static)
        for (int i = 0; i < password_count; ++i)
        {
            int tid = omp_get_thread_num();
            local_models[tid].parse(passwords[i]);
        }

        if (verbose)
        {
            cout << "Merging local models..." << endl;
        }
        for (int i = 0; i < threads; ++i)
        {
            MergeModel(*this, local_models[i]);
        }
    }
}

/// @brief 在模型中找到一个PT的统计数据
/// @param pt 需要查找的PT
/// @return 目标PT在模型中的对应下标
int model::FindPT(PT pt)
{
    for (int id = 0; id < preterminals.size(); id += 1)
    {
        if (preterminals[id].content.size() != pt.content.size())
        {
            continue;
        }
        else
        {
            bool equal_flag = true;
            for (int idx = 0; idx < preterminals[id].content.size(); idx += 1)
            {
                if (preterminals[id].content[idx].type != pt.content[idx].type || preterminals[id].content[idx].length != pt.content[idx].length)
                {
                    equal_flag = false;
                    break;
                }
            }
            if (equal_flag == true)
            {
                return id;
            }
        }
    }
    return -1;
}

/// @brief 在模型中找到一个letter segment的统计数据
/// @param seg 要找的letter segment
/// @return 目标letter segment的对应下标
int model::FindLetter(segment seg)
{
    for (int id = 0; id < letters.size(); id += 1)
    {
        if (letters[id].length == seg.length)
        {
            return id;
        }
    }
    return -1;
}

/// @brief 在模型中找到一个digit segment的统计数据
/// @param seg 要找的digit segment
/// @return 目标digit segment的对应下标
int model::FindDigit(segment seg)
{
    for (int id = 0; id < digits.size(); id += 1)
    {
        if (digits[id].length == seg.length)
        {
            return id;
        }
    }
    return -1;
}

int model::FindSymbol(segment seg)
{
    for (int id = 0; id < symbols.size(); id += 1)
    {
        if (symbols[id].length == seg.length)
        {
            return id;
        }
    }
    return -1;
}

void PT::insert(segment seg)
{
    content.emplace_back(seg);
}

void segment::insert(string value)
{
    if (values.find(value) == values.end())
    {
        values[value] = values.size();
        freqs[values[value]] = 1;
    }
    else
    {
        freqs[values[value]] += 1;
    }
}


void segment::order()
{
    for (pair<string, int> value : values)
    {
        ordered_values.emplace_back(value.first);
    }
    // cout << "value size:" << ordered_values.size() << endl;
    std::sort(ordered_values.begin(), ordered_values.end(),
              [this](const std::string &a, const std::string &b)
              {
                  return freqs.at(values[a]) > freqs.at(values[b]);
              });

    // 将排序后的频率存入 ordered_freqs 并计算 total_freq
    for (const std::string &val : ordered_values)
    {
        ordered_freqs.emplace_back(freqs.at(values[val]));
        total_freq += freqs.at(values[val]);
    }
    for (string val : ordered_values)
    {
        ordered_freqs.emplace_back(freqs.at(values[val]));
        total_freq += freqs.at(values[val]);
    }
}

void model::parse(string pw)
{
    PT pt;
    string curr_part = "";
    int curr_type = 0; // 0: 未设置, 1: 字母, 2: 数字, 3: 特殊字符
    // 请学会使用这种方式写for循环：for (auto it : iterable)
    // 相信我，以后你会用上的。You're welcome :)
    for (char ch : pw)
    {
        if (isalpha(ch))
        {
            if (curr_type != 1)
            {
                if (curr_type == 2)
                {
                    segment seg(curr_type, curr_part.length());
                    if (FindDigit(seg) == -1)
                    {
                        int id = GetNextDigitsID();
                        digits.emplace_back(seg);
                        digits[id].insert(curr_part);
                        digits_freq[id] = 1;
                    }
                    else
                    {
                        int id = FindDigit(seg);
                        digits_freq[id] += 1;
                        digits[id].insert(curr_part);
                    }
                    curr_part.clear();
                    pt.insert(seg);
                }
                else if (curr_type == 3)
                {
                    segment seg(curr_type, curr_part.length());
                    if (FindSymbol(seg) == -1)
                    {
                        int id = GetNextSymbolsID();
                        symbols.emplace_back(seg);
                        symbols_freq[id] = 1;
                        symbols[id].insert(curr_part);
                    }
                    else
                    {
                        int id = FindSymbol(seg);
                        symbols_freq[id] += 1;
                        symbols[id].insert(curr_part);
                    }
                    curr_part.clear();
                    pt.insert(seg);
                }
            }
            curr_type = 1;
            curr_part += ch;
        }
        else if (isdigit(ch))
        {
            if (curr_type != 2)
            {
                if (curr_type == 1)
                {
                    segment seg(curr_type, curr_part.length());
                    if (FindLetter(seg) == -1)
                    {
                        int id = GetNextLettersID();
                        letters.emplace_back(seg);
                        letters_freq[id] = 1;
                        letters[id].insert(curr_part);
                    }
                    else
                    {
                        int id = FindLetter(seg);
                        letters_freq[id] += 1;
                        letters[id].insert(curr_part);
                    }
                    curr_part.clear();
                    pt.insert(seg);
                }
                else if (curr_type == 3)
                {
                    segment seg(curr_type, curr_part.length());
                    if (FindSymbol(seg) == -1)
                    {
                        int id = GetNextSymbolsID();
                        symbols.emplace_back(seg);
                        symbols_freq[id] = 1;
                        symbols[id].insert(curr_part);
                    }
                    else
                    {
                        int id = FindSymbol(seg);
                        symbols_freq[id] += 1;
                        symbols[id].insert(curr_part);
                    }
                    curr_part.clear();
                    pt.insert(seg);
                }
            }
            curr_type = 2;
            curr_part += ch;
        }
        else
        {
            if (curr_type != 3)
            {
                if (curr_type == 1)
                {
                    segment seg(curr_type, curr_part.length());
                    if (FindLetter(seg) == -1)
                    {
                        int id = GetNextLettersID();
                        letters.emplace_back(seg);
                        letters_freq[id] = 1;
                        letters[id].insert(curr_part);
                    }
                    else
                    {
                        int id = FindLetter(seg);
                        letters_freq[id] += 1;
                        letters[id].insert(curr_part);
                    }
                    curr_part.clear();
                    pt.insert(seg);
                }
                else if (curr_type == 2)
                {
                    segment seg(curr_type, curr_part.length());
                    if (FindDigit(seg) == -1)
                    {
                        int id = GetNextDigitsID();
                        digits.emplace_back(seg);
                        digits_freq[id] = 1;
                        digits[id].insert(curr_part);
                    }
                    else
                    {
                        int id = FindDigit(seg);
                        digits_freq[id] += 1;
                        digits[id].insert(curr_part);
                    }
                    curr_part.clear();
                    pt.insert(seg);
                }
            }
            curr_type = 3;
            curr_part += ch;
        }
    }
    if (!curr_part.empty())
    {
        if (curr_type == 1)
        {
            segment seg(curr_type, curr_part.length());
            if (FindLetter(seg) == -1)
            {
                int id = GetNextLettersID();
                letters.emplace_back(seg);
                letters_freq[id] = 1;
                letters[id].insert(curr_part);
            }
            else
            {
                int id = FindLetter(seg);
                letters_freq[id] += 1;
                letters[id].insert(curr_part);
            }
            curr_part.clear();
            pt.insert(seg);
        }
        else if (curr_type == 2)
        {
            segment seg(curr_type, curr_part.length());
            if (FindDigit(seg) == -1)
            {
                int id = GetNextDigitsID();
                digits.emplace_back(seg);
                digits_freq[id] = 1;
                digits[id].insert(curr_part);
            }
            else
            {
                int id = FindDigit(seg);
                digits_freq[id] += 1;
                digits[id].insert(curr_part);
            }
            curr_part.clear();
            pt.insert(seg);
        }
        else
        {
            segment seg(curr_type, curr_part.length());
            if (FindSymbol(seg) == -1)
            {
                int id = GetNextSymbolsID();
                symbols.emplace_back(seg);
                symbols_freq[id] = 1;
                symbols[id].insert(curr_part);
            }
            else
            {
                int id = FindSymbol(seg);
                symbols_freq[id] += 1;
                symbols[id].insert(curr_part);
            }
            curr_part.clear();
            pt.insert(seg);
        }
    }
    // pt.PrintPT();
    // cout<<endl;
    // cout << FindPT(pt) << endl;
    total_preterm += 1;
    if (FindPT(pt) == -1)
    {
        for (int i = 0; i < pt.content.size(); i += 1)
        {
            pt.curr_indices.emplace_back(0);
        }
        int id = GetNextPretermID();
        // cout << id << endl;
        preterminals.emplace_back(pt);
        preterm_freq[id] = 1;
    }
    else
    {
        int id = FindPT(pt);
        // cout << id << endl;
        preterm_freq[id] += 1;
    }
}

void segment::PrintSeg()
{
    if (type == 1)
    {
        cout << "L" << length;
    }
    if (type == 2)
    {
        cout << "D" << length;
    }
    if (type == 3)
    {
        cout << "S" << length;
    }
}

void segment::PrintValues()
{
    // order();
    for (string iter : ordered_values)
    {
        cout << iter << " freq:" << freqs[values[iter]] << endl;
    }
}

void PT::PrintPT()
{
    for (auto iter : content)
    {
        iter.PrintSeg();
    }
}

void model::print()
{
    cout << "preterminals:" << endl;
    for (int i = 0; i < preterminals.size(); i += 1)
    {
        preterminals[i].PrintPT();
        // cout << preterminals[i].curr_indices.size() << endl;
        cout << " freq:" << preterm_freq[i];
        cout << endl;
    }
    // order();
    for (auto iter : ordered_pts)
    {
        iter.PrintPT();
        cout << " freq:" << preterm_freq[FindPT(iter)];
        cout << endl;
    }
    cout << "segments:" << endl;
    for (int i = 0; i < letters.size(); i += 1)
    {
        letters[i].PrintSeg();
        // letters[i].PrintValues();
        cout << " freq:" << letters_freq[i];
        cout << endl;
    }
    for (int i = 0; i < digits.size(); i += 1)
    {
        digits[i].PrintSeg();
        // digits[i].PrintValues();
        cout << " freq:" << digits_freq[i];
        cout << endl;
    }
    for (int i = 0; i < symbols.size(); i += 1)
    {
        symbols[i].PrintSeg();
        // symbols[i].PrintValues();
        cout << " freq:" << symbols_freq[i];
        cout << endl;
    }
}

bool compareByPretermProb(const PT& a, const PT& b) {
    return a.preterm_prob > b.preterm_prob;  // 降序排序
}

void model::order()
{
    int threads = TrainThreads();
    if (verbose)
    {
        cout << "Training phase 2: Ordering segment values and PTs..." << endl;
    }
    ordered_pts.reserve(preterminals.size());
    for (PT pt : preterminals)
    {
        pt.preterm_prob = float(preterm_freq[FindPT(pt)]) / total_preterm;
        ordered_pts.emplace_back(pt);
    }
    bool swapped;
    if (verbose)
    {
        cout << "total pts" << ordered_pts.size() << endl;
    }
    std::sort(ordered_pts.begin(), ordered_pts.end(), compareByPretermProb);
    if (verbose)
    {
        cout << "Ordering letters" << endl;
    }
    // cout << "total letters" << endl;
    int letter_count = letters.size();
#pragma omp parallel for num_threads(threads) schedule(dynamic) if(threads > 1)
    for (int i = 0; i < letter_count; i += 1)
    {
        // cout << i << endl;
        letters[i].order();
    }
    if (verbose)
    {
        cout << "Ordering digits" << endl;
    }
    // cout << "total letters" << endl;
    int digit_count = digits.size();
#pragma omp parallel for num_threads(threads) schedule(dynamic) if(threads > 1)
    for (int i = 0; i < digit_count; i += 1)
    {
        digits[i].order();
    }
    if (verbose)
    {
        cout << "ordering symbols" << endl;
    }
    // cout << "total letters" << endl;
    int symbol_count = symbols.size();
#pragma omp parallel for num_threads(threads) schedule(dynamic) if(threads > 1)
    for (int i = 0; i < symbol_count; i += 1)
    {
        symbols[i].order();
    }
}
