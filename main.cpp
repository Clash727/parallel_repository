#include "PCFG.h"
#include <chrono>
#include <fstream>
#include <sstream>
#include "md5.h"
#include <iomanip>
#include <mpi.h>
#include <cstdlib>
#include <cstring>
#include <algorithm>
using namespace std;
using namespace chrono;

// 编译指令如下
// g++ main.cpp train.cpp guessing.cpp md5.cpp -o main
// g++ main.cpp train.cpp guessing.cpp md5.cpp -o main -O1
// g++ main.cpp train.cpp guessing.cpp md5.cpp -o main -O2
// mpic++ main.cpp train.cpp guessing.cpp md5.cpp -o main -O2
const int TAG_BATCH_SIZE = 100;
const int TAG_BATCH_DATA = 101;
const int TAG_STOP = 102;

static void AppendInt(string &buffer, int value)
{
    buffer.append(reinterpret_cast<const char *>(&value), sizeof(int));
}

static int ReadInt(const string &buffer, size_t &offset)
{
    int value = 0;
    memcpy(&value, buffer.data() + offset, sizeof(int));
    offset += sizeof(int);
    return value;
}

struct SerializedGuessView
{
    size_t offset;
    int length;
};

static int ReadEnvInt(const char *name, int fallback, int min_value, int max_value)
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

static int HashThreads()
{
    return ReadEnvInt("HYBRID_HASH_THREADS", 2, 1, 32);
}

static int HashParallelThreshold()
{
    return ReadEnvInt("HYBRID_HASH_THRESHOLD", 4096, 1, 1000000000);
}

static string SerializeGuesses(const vector<string> &guesses)
{
    string buffer;
    size_t total_bytes = sizeof(int);

    for (const string &guess : guesses)
    {
        total_bytes += sizeof(int) + guess.size();
    }

    buffer.reserve(total_bytes);

    AppendInt(buffer, static_cast<int>(guesses.size()));

    for (const string &guess : guesses)
    {
        AppendInt(buffer, static_cast<int>(guess.size()));
        buffer.append(guess.data(), guess.size());
    }

    return buffer;
}

static vector<string> DeserializeGuesses(const string &buffer)
{
    vector<string> guesses;
    size_t offset = 0;

    int count = ReadInt(buffer, offset);
    guesses.reserve(count);

    for (int i = 0; i < count; i += 1)
    {
        int length = ReadInt(buffer, offset);
        guesses.emplace_back(buffer.data() + offset, length);
        offset += length;
    }

    return guesses;
}

static void HashGuessBlock(const string &buffer, const vector<SerializedGuessView> &views, int block)
{
    int start = block * 4;
    int count = views.size();
    int n = count - start;
    if (n > 4)
    {
        n = 4;
    }

    string neon_inputs[4];
    bit32 state0[4];
    bit32 state1[4];
    bit32 state2[4];
    bit32 state3[4];
    bit32 *neon_states[4] = {state0, state1, state2, state3};
    bool full_short_batch = (n == 4);

    for (int i = 0; i < n; ++i)
    {
        if (views[start + i].length >= 56)
        {
            full_short_batch = false;
            break;
        }
    }

    if (full_short_batch)
    {
        for (int i = 0; i < 4; ++i)
        {
            const SerializedGuessView &view = views[start + i];
            neon_inputs[i].assign(buffer.data() + view.offset, view.length);
        }
        MD5Hash_NEON(neon_inputs, neon_states);
        return;
    }

    for (int i = 0; i < n; ++i)
    {
        const SerializedGuessView &view = views[start + i];
        string guess(buffer.data() + view.offset, view.length);
        MD5Hash(guess, neon_states[i]);
    }
}

static void HashSerializedGuesses(const string &buffer, double &time_hash, long long &local_hashed_total)
{
    auto start_hash = system_clock::now();
    size_t offset = 0;
    int count = ReadInt(buffer, offset);

    vector<SerializedGuessView> views;
    views.reserve(count);

    for (int i = 0; i < count; i += 1)
    {
        int length = ReadInt(buffer, offset);
        views.push_back({offset, length});
        offset += length;
    }

    int blocks = (count + 3) / 4;
    int threads = HashThreads();
    int threshold = HashParallelThreshold();

    if (threads <= 1 || count < threshold)
    {
        for (int block = 0; block < blocks; ++block)
        {
            HashGuessBlock(buffer, views, block);
        }
    }
    else
    {
#pragma omp parallel for num_threads(threads) schedule(static)
        for (int block = 0; block < blocks; ++block)
        {
            HashGuessBlock(buffer, views, block);
        }
    }

    auto end_hash = system_clock::now();
    auto duration_hash = duration_cast<microseconds>(end_hash - start_hash);
    time_hash += double(duration_hash.count()) * microseconds::period::num / microseconds::period::den;
    local_hashed_total += static_cast<long long>(count);
}

static void SendGuessBatch(const vector<string> &guesses, int dest_rank)
{
    string buffer = SerializeGuesses(guesses);
    int bytes = static_cast<int>(buffer.size());

    MPI_Send(&bytes, 1, MPI_INT, dest_rank, TAG_BATCH_SIZE, MPI_COMM_WORLD);
    MPI_Send(buffer.data(), bytes, MPI_CHAR, dest_rank, TAG_BATCH_DATA, MPI_COMM_WORLD);
}

static void SendStopSignal(int dest_rank)
{
    MPI_Send(nullptr, 0, MPI_CHAR, dest_rank, TAG_STOP, MPI_COMM_WORLD);
}

int main(int argc, char *argv[])
{
    MPI_Init(&argc, &argv);

    int rank = 0;
    int size = 1;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    //下面代码用于测试MD5哈希的正确性
    if (rank == 0)
    {
    cout << "Testing MD5Hash correctness..." << endl;
    }

    int generator_count = size;

    if (argc >= 2 && size > 1)
    {
        generator_count = atoi(argv[1]);

        if (generator_count < 1)
        {
            generator_count = 1;
        }

        if (generator_count >= size)
        {
            generator_count = size - 1;
        }
    }

    long long batch_threshold = 500000LL;
    if (argc >= 3)
    {
        batch_threshold = atoll(argv[2]);

        if (batch_threshold < 10000)
        {
            batch_threshold = 10000;
        }
    }

    bool is_generator = (rank < generator_count);
    int hasher_count = size - generator_count;
    int hasher_rank = rank - generator_count;

    MPI_Comm gen_comm = MPI_COMM_NULL;
    MPI_Comm_split(
        MPI_COMM_WORLD,
        is_generator ? 0 : MPI_UNDEFINED,
        rank,
        &gen_comm
    );

    int gen_rank = 0;
    int gen_size = generator_count;

    if (is_generator)
    {
        MPI_Comm_rank(gen_comm, &gen_rank);
        MPI_Comm_size(gen_comm, &gen_size);
    }

    if (rank == 0)
    {
        cout << "Generator processes:" << generator_count
            << ", Hasher processes:" << hasher_count << endl;
    }
    string test_pws[8] = {"123456", "password", "12345678", "qwerty", "123456789", "12345", "1234", "111111"};
    string test_hashes[8] = {
        "e10adc3949ba59abbe56e057f20f883e",
        "5f4dcc3b5aa765d61d8327deb882cf99",
        "25d55ad283aa400af464c76d713c07ad",
        "d8578edf8458ce06fbc5bb76a58c5ca4",
        "25f9e794323b453885f5181f1b624d0b",
        "827ccb0eea8a706c4c34a16891f84e7b",
        "81dc9bdb52d04dc20036dbd8313ed055",
        "96e79218965eb72c92a549dd5a330112"
    };
    for (int i = 0; i < 8; i++) {
        bit32 state[4];
        MD5Hash(test_pws[i], state);
        stringstream ss;
        for (int i1 = 0; i1 < 4; i1 += 1) {
            ss << std::setw(8) << std::setfill('0') << hex << state[i1];
        }
        if (ss.str() != test_hashes[i]) {
            cout << "MD5Hash test failed for " << test_pws[i] << "!" << endl;
            cout << "Expected: " << test_hashes[i] << "\nGot:      " << ss.str() << endl;
            MPI_Finalize();
            return 1;
        }
    }
    if (rank == 0)
    {
    cout << "MD5Hash test passed!" << endl;
    } //请不要修改这一行

    double time_hash = 0;  // 用于MD5哈希的时间
    double time_guess = 0; // 哈希和猜测的总时长
    double time_train = 0; // 模型训练的总时长
    long long local_hashed_total = 0;
    long long final_global_guesses = 0;
    double pipeline_start = 0;
    double pipeline_time = 0;
    PriorityQueue q;

    if (is_generator)
    {
    q.m.verbose = (rank == 0);
    q.mpi_rank = gen_rank;
    q.mpi_size = gen_size;
    auto start_train = system_clock::now();
    q.m.train("/guessdata/Rockyou-singleLined-full.txt");
    q.m.order();
    auto end_train = system_clock::now();
    auto duration_train = duration_cast<microseconds>(end_train - start_train);
    time_train = double(duration_train.count()) * microseconds::period::num / microseconds::period::den;

    q.init();
    if (rank == 0)
    {
    cout << "here" << endl;
    }
    }

    MPI_Barrier(MPI_COMM_WORLD);
    pipeline_start = MPI_Wtime();

    if (is_generator)
    {
    long long curr_num = 0;
    auto start = system_clock::now();
    // 由于需要定期清空内存，我们在这里记录已生成的猜测总数
    long long history = 0;
    const long long generate_n = 10000000LL;
    long long pop_count = 0;
    const long long sync_interval = 64;
    int next_hasher = 0;
    // std::ofstream a("./files/results.txt");
    while (!q.priority.empty())
    {
        q.PopNext();
        pop_count++;

        bool need_sync = (pop_count % sync_interval == 0) || q.priority.empty();
        if (!need_sync)
        {
            continue;
        }

        long long local_guesses = static_cast<long long>(q.guesses.size());
        long long global_guesses = 0;

        MPI_Allreduce(
            &local_guesses,
            &global_guesses,
            1,
            MPI_LONG_LONG,
            MPI_SUM,
            gen_comm
        );

        q.total_guesses = static_cast<int>(local_guesses);
        final_global_guesses = history + global_guesses;

        if (global_guesses - curr_num >= 100000)
        {
            if (rank == 0)
            {
                cout << "Guesses generated: " << history + global_guesses << endl;
            }
            curr_num = global_guesses;

            if (history + global_guesses > generate_n)
            {
                auto end = system_clock::now();
                auto duration = duration_cast<microseconds>(end - start);
                time_guess = double(duration.count()) * microseconds::period::num / microseconds::period::den;
                break;
            }
        }
        // 为了避免内存超限，我们在q.guesses中口令达到一定数目时，将其中的所有口令取出并且进行哈希
        // 然后，q.guesses将会被清空。为了有效记录已经生成的口令总数，维护一个history变量来进行记录
        if (global_guesses > batch_threshold)
        {
            if (hasher_count > 0 && !q.guesses.empty())
            {
                int dest = generator_count + next_hasher;
                SendGuessBatch(q.guesses, dest);
                next_hasher = (next_hasher + 1) % hasher_count;
            }

            history += global_guesses;
            curr_num = 0;
            q.guesses.clear();
        }
    }
    if (hasher_count > 0 && !q.guesses.empty())
    {
        int dest = generator_count + next_hasher;
        SendGuessBatch(q.guesses, dest);
        next_hasher = (next_hasher + 1) % hasher_count;
        q.guesses.clear();
    }
    if (hasher_count > 0)
    {
        for (int h = 0; h < hasher_count; h += 1)
        {
            SendStopSignal(generator_count + h);
        }
    }
    }
    else
    {
        int stop_count = 0;

        while (stop_count < generator_count)
        {
            MPI_Status status;
            MPI_Probe(MPI_ANY_SOURCE, MPI_ANY_TAG, MPI_COMM_WORLD, &status);

            if (status.MPI_TAG == TAG_STOP)
            {
                MPI_Recv(
                    nullptr,
                    0,
                    MPI_CHAR,
                    status.MPI_SOURCE,
                    TAG_STOP,
                    MPI_COMM_WORLD,
                    MPI_STATUS_IGNORE
                );
                stop_count += 1;
            }
            else if (status.MPI_TAG == TAG_BATCH_SIZE)
            {
                int bytes = 0;
                MPI_Recv(
                    &bytes,
                    1,
                    MPI_INT,
                    status.MPI_SOURCE,
                    TAG_BATCH_SIZE,
                    MPI_COMM_WORLD,
                    MPI_STATUS_IGNORE
                );

                string buffer(bytes, '\0');
                MPI_Recv(
                    &buffer[0],
                    bytes,
                    MPI_CHAR,
                    status.MPI_SOURCE,
                    TAG_BATCH_DATA,
                    MPI_COMM_WORLD,
                    MPI_STATUS_IGNORE
                );
                HashSerializedGuesses(buffer, time_hash, local_hashed_total);
            }
        }
    }
    pipeline_time = MPI_Wtime() - pipeline_start;
    double local_guess_time = is_generator ? time_guess : 0;
    double max_guess_time = 0;
    double max_hash_time = 0;
    double max_train_time = 0;
    double max_pipeline_time = 0;
    
    MPI_Reduce(&local_guess_time, &max_guess_time, 1, MPI_DOUBLE, MPI_MAX, 0, MPI_COMM_WORLD);
    MPI_Reduce(&time_hash, &max_hash_time, 1, MPI_DOUBLE, MPI_MAX, 0, MPI_COMM_WORLD);
    MPI_Reduce(&time_train, &max_train_time, 1, MPI_DOUBLE, MPI_MAX, 0, MPI_COMM_WORLD);
    MPI_Reduce(&pipeline_time, &max_pipeline_time, 1, MPI_DOUBLE, MPI_MAX, 0, MPI_COMM_WORLD);

    if (rank == 0)
    {
        cout << "Guess time:" << max_guess_time << "seconds" << endl;
        cout << "Hash time:" << max_hash_time << "seconds" << endl;
        cout << "Train time:" << max_train_time << "seconds" << endl;
        cout << "Pipeline time:" << max_pipeline_time << "seconds" << endl;
    }
    if (gen_comm != MPI_COMM_NULL)
    {
        MPI_Comm_free(&gen_comm);
    }
    MPI_Finalize();
    return 0;
}
