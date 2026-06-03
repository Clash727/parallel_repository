#include "PCFG.h"
#include <chrono>
#include <fstream>
#include <sstream>
#include "md5.h"
#include <iomanip>
#include <mpi.h>
using namespace std;
using namespace chrono;

// 编译指令如下
// g++ main.cpp train.cpp guessing.cpp md5.cpp -o main
// g++ main.cpp train.cpp guessing.cpp md5.cpp -o main -O1
// g++ main.cpp train.cpp guessing.cpp md5.cpp -o main -O2
// mpic++ main.cpp train.cpp guessing.cpp md5.cpp -o main -O2

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
    PriorityQueue q;
    q.m.verbose = (rank == 0);
    q.mpi_rank = rank;
    q.mpi_size = size;
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
    long long curr_num = 0;
    auto start = system_clock::now();
    // 由于需要定期清空内存，我们在这里记录已生成的猜测总数
    long long history = 0;
    const long long generate_n = 10000000LL;
    long long local_hashed_total = 0;
    long long final_global_guesses = 0;
    long long pop_count = 0;
    const long long sync_interval = 64;
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
            MPI_COMM_WORLD
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
        if (global_guesses > 1000000)
        {
             auto start_hash = system_clock::now();
            // bit32 state[4];
            // for (string pw : q.guesses)
            // {
            //     // TODO：对于SIMD实验，将这里替换成你的SIMD MD5函数
            //     MD5Hash(pw, state);

            //     // 以下注释部分用于输出猜测和哈希，但是由于自动测试系统不太能写文件，所以这里你可以改成cout
            //     // a<<pw<<"\t";
            //     // for (int i1 = 0; i1 < 4; i1 += 1)
            
            //     // {
            //     //     a << std::setw(8) << std::setfill('0') << hex << state[i1];
            //     // }
            //     // a << endl;
            // }
            bit32 state_storage[4][4];
            bit32 *state_ptrs[4];

            for (int i = 0; i < 4; i++)
            {
                state_ptrs[i] = state_storage[i];
            }

            size_t i = 0;
            size_t guess_count = q.guesses.size();
            
            for (; i + 3 < guess_count; i += 4)
            {
                MD5Hash_NEON(&q.guesses[i], state_ptrs);
            }

            bit32 state[4];
            for (; i < guess_count; i++)
            {
                MD5Hash(q.guesses[i], state);
            }



            // 在这里对哈希所需的总时长进行计算
            auto end_hash = system_clock::now();
            auto duration = duration_cast<microseconds>(end_hash - start_hash);
            time_hash += double(duration.count()) * microseconds::period::num / microseconds::period::den;
            local_hashed_total += static_cast<long long>(guess_count);
            // 记录已经生成的口令总数
            history += global_guesses;
            curr_num = 0;
            q.guesses.clear();
        }
    }
    double local_guess_time = time_guess - time_hash;
    double max_guess_time = 0;
    double max_hash_time = 0;
    double max_train_time = 0;
    long long global_hashed_total = 0;

    MPI_Reduce(&local_guess_time, &max_guess_time, 1, MPI_DOUBLE, MPI_MAX, 0, MPI_COMM_WORLD);
    MPI_Reduce(&time_hash, &max_hash_time, 1, MPI_DOUBLE, MPI_MAX, 0, MPI_COMM_WORLD);
    MPI_Reduce(&time_train, &max_train_time, 1, MPI_DOUBLE, MPI_MAX, 0, MPI_COMM_WORLD);
    MPI_Reduce(&local_hashed_total, &global_hashed_total, 1, MPI_LONG_LONG, MPI_SUM, 0, MPI_COMM_WORLD);

    if (rank == 0)
    {
        cout << "Guess time:" << max_guess_time << "seconds" << endl;
        cout << "Hash time:" << max_hash_time << "seconds" << endl;
        cout << "Train time:" << max_train_time << "seconds" << endl;
    }
    MPI_Finalize();
    return 0;
}
