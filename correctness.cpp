// // #include "PCFG.h"
// // #include <chrono>
// // #include <fstream>
// // #include "md5.h"
// // #include <iomanip>

// // using namespace std;
// // using namespace chrono;

// // // 编译指令如下：
// // // g++ correctness.cpp train.cpp guessing.cpp md5.cpp -o test.exe


// // // 通过这个函数，你可以验证你实现的SIMD哈希函数的正确性
// // int main()
// // {
// //     bit32 state[4];
// //     MD5Hash("bvaisdbjasdkafkasdfnavkjnakdjfejfanjsdnfkajdfkajdfjkwanfdjaknsvjkanbjbjadfajwefajksdfakdnsvjadfasjdvabvaisdbjasdkafkasdfnavkjnakdjfejfanjsdnfkajdfkajdfjkwanfdjaknsvjkanbjbjadfajwefajksdfakdnsvjadfasjdvabvaisdbjasdkafkasdfnavkjnakdjfejfanjsdnfkajdfkajdfjkwanfdjaknsvjkanbjbjadfajwefajksdfakdnsvjadfasjdvabvaisdbjasdkafkasdfnavkjnakdjfejfanjsdnfkajdfkajdfjkwanfdjaknsvjkanbjbjadfajwefajksdfakdnsvjadfasjdva", state);
// //     for (int i1 = 0; i1 < 4; i1 += 1)
// //     {
// //         cout << std::setw(8) << std::setfill('0') << hex << state[i1];
// //     }
// //     cout << endl;
// // }

// #include "md5.h"
// #include <iomanip>
// #include <iostream>
// #include <sstream>
// #include <string>
// #include <vector>

// using namespace std;

// string state_to_hex(const bit32 state[4])
// {
//     stringstream ss;
//     for (int i = 0; i < 4; i++)
//     {
//         ss << setw(8) << setfill('0') << hex << state[i];
//     }
//     return ss.str();
// }

// int main()
// {
//     vector<string> tests = {
//         "123456",
//         "password",
//         "12345678",
//         "qwerty",
//         "123456789",
//         "12345",
//         "1234",
//         "111111"
//     };

//     bool ok = true;

//     for (size_t base = 0; base < tests.size(); base += 4)
//     {
//         string inputs[4];
//         bit32 scalar_states[4][4];
//         bit32 simd_states[4][4];
//         bit32 *simd_state_ptrs[4];

//         for (int lane = 0; lane < 4; lane++)
//         {
//             inputs[lane] = tests[base + lane];
//             MD5Hash(inputs[lane], scalar_states[lane]);
//             simd_state_ptrs[lane] = simd_states[lane];
//         }

//         MD5Hash_NEON(inputs, simd_state_ptrs);


//         for (int lane = 0; lane < 4; lane++)
//         {
//             string scalar_hex = state_to_hex(scalar_states[lane]);
//             string simd_hex = state_to_hex(simd_states[lane]);

//             if (scalar_hex != simd_hex)
//             {
//                 ok = false;
//                 cout << "Error in: " << inputs[lane] << endl;
//                 cout << "Scalar: " << scalar_hex << endl;
//                 cout << "SIMD:   " << simd_hex << endl;
//             }
//         }
//     }

//     if (ok)
//     {
//         cout << "SIMD MD5 correctness passed" << endl;
//         return 0;
//     }

//     cout << "SIMD MD5 correctness failed" << endl;
//     return 1;
// }
#include "PCFG.h"
#include <chrono>
#include <fstream>
#include "md5.h"
#include <iomanip>
#include <unordered_set>
using namespace std;
using namespace chrono;

// 编译指令如下
// g++ main.cpp train.cpp guessing.cpp md5.cpp -o main
// g++ main.cpp train.cpp guessing.cpp md5.cpp -o main -O1
// g++ main.cpp train.cpp guessing.cpp md5.cpp -o main -O2

int main()
{
    double time_hash = 0;  // 用于MD5哈希的时间
    double time_guess = 0; // 哈希和猜测的总时长
    double time_train = 0; // 模型训练的总时长
    PriorityQueue q;
    auto start_train = system_clock::now();
    q.m.train("/guessdata/Rockyou-singleLined-full.txt");
    q.m.order();
    auto end_train = system_clock::now();
    auto duration_train = duration_cast<microseconds>(end_train - start_train);
    time_train = double(duration_train.count()) * microseconds::period::num / microseconds::period::den;


    
    // 加载一些测试数据
    unordered_set<std::string> test_set;
    ifstream test_data("/guessdata/Rockyou-singleLined-full.txt");
    int test_count=0;
    string pw;
    while(test_data>>pw)
    {   
        test_count+=1;
        test_set.insert(pw);
        if (test_count>=1000000)
        {
            break;
        }
    }
    int cracked=0;

    q.init();
    cout << "here" << endl;
    int curr_num = 0;
    auto start = system_clock::now();
    // 由于需要定期清空内存，我们在这里记录已生成的猜测总数
    int history = 0;
    // std::ofstream a("./files/results.txt");
    while (!q.priority.empty())
    {
        q.PopNext();
        q.total_guesses = q.guesses.size();
        if (q.total_guesses - curr_num >= 100000)
        {
            cout << "Guesses generated: " <<history + q.total_guesses << endl;
            curr_num = q.total_guesses;

            // 在此处更改实验生成的猜测上限
            int generate_n=10000000;
            if (history + q.total_guesses > 10000000)
            {
                auto end = system_clock::now();
                auto duration = duration_cast<microseconds>(end - start);
                time_guess = double(duration.count()) * microseconds::period::num / microseconds::period::den;
                cout << "Guess time:" << time_guess - time_hash << "seconds"<< endl;
                cout << "Hash time:" << time_hash << "seconds"<<endl;
                cout << "Train time:" << time_train <<"seconds"<<endl;
                cout<<"Cracked:"<< cracked<<endl;
                break;
            }
        }
        // 为了避免内存超限，我们在q.guesses中口令达到一定数目时，将其中的所有口令取出并且进行哈希
        // 然后，q.guesses将会被清空。为了有效记录已经生成的口令总数，维护一个history变量来进行记录
        if (curr_num > 1000000)
        {
            auto start_hash = system_clock::now();
            bit32 state[4];
            for (string pw : q.guesses)
            {
                if (test_set.find(pw) != test_set.end()) {
                    cracked+=1;
                }
                // TODO：对于SIMD实验，将这里替换成你的SIMD MD5函数
                MD5Hash(pw, state);

                // 以下注释部分用于输出猜测和哈希，但是由于自动测试系统不太能写文件，所以这里你可以改成cout
                // a<<pw<<"\t";
                // for (int i1 = 0; i1 < 4; i1 += 1)
                // {
                //     a << std::setw(8) << std::setfill('0') << hex << state[i1];
                // }
                // a << endl;
            }

            // 在这里对哈希所需的总时长进行计算
            auto end_hash = system_clock::now();
            auto duration = duration_cast<microseconds>(end_hash - start_hash);
            time_hash += double(duration.count()) * microseconds::period::num / microseconds::period::den;

            // 记录已经生成的口令总数
            history += curr_num;
            curr_num = 0;
            q.guesses.clear();
        }
    }
}
