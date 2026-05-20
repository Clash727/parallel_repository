// #include "PCFG.h"
// #include <chrono>
// #include <fstream>
// #include "md5.h"
// #include <iomanip>

// using namespace std;
// using namespace chrono;

// // 编译指令如下：
// // g++ correctness.cpp train.cpp guessing.cpp md5.cpp -o test.exe


// // 通过这个函数，你可以验证你实现的SIMD哈希函数的正确性
// int main()
// {
//     bit32 state[4];
//     MD5Hash("bvaisdbjasdkafkasdfnavkjnakdjfejfanjsdnfkajdfkajdfjkwanfdjaknsvjkanbjbjadfajwefajksdfakdnsvjadfasjdvabvaisdbjasdkafkasdfnavkjnakdjfejfanjsdnfkajdfkajdfjkwanfdjaknsvjkanbjbjadfajwefajksdfakdnsvjadfasjdvabvaisdbjasdkafkasdfnavkjnakdjfejfanjsdnfkajdfkajdfjkwanfdjaknsvjkanbjbjadfajwefajksdfakdnsvjadfasjdvabvaisdbjasdkafkasdfnavkjnakdjfejfanjsdnfkajdfkajdfjkwanfdjaknsvjkanbjbjadfajwefajksdfakdnsvjadfasjdva", state);
//     for (int i1 = 0; i1 < 4; i1 += 1)
//     {
//         cout << std::setw(8) << std::setfill('0') << hex << state[i1];
//     }
//     cout << endl;
// }

#include "md5.h"
#include <iomanip>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

using namespace std;

string state_to_hex(const bit32 state[4])
{
    stringstream ss;
    for (int i = 0; i < 4; i++)
    {
        ss << setw(8) << setfill('0') << hex << state[i];
    }
    return ss.str();
}

int main()
{
    vector<string> tests = {
        "123456",
        "password",
        "12345678",
        "qwerty",
        "123456789",
        "12345",
        "1234",
        "111111"
    };

    bool ok = true;

    for (size_t base = 0; base < tests.size(); base += 4)
    {
        string inputs[4];
        bit32 scalar_states[4][4];
        bit32 simd_states[4][4];
        bit32 *simd_state_ptrs[4];

        for (int lane = 0; lane < 4; lane++)
        {
            inputs[lane] = tests[base + lane];
            MD5Hash(inputs[lane], scalar_states[lane]);
            simd_state_ptrs[lane] = simd_states[lane];
        }

        MD5Hash_NEON(inputs, simd_state_ptrs);


        for (int lane = 0; lane < 4; lane++)
        {
            string scalar_hex = state_to_hex(scalar_states[lane]);
            string simd_hex = state_to_hex(simd_states[lane]);

            if (scalar_hex != simd_hex)
            {
                ok = false;
                cout << "Error in: " << inputs[lane] << endl;
                cout << "Scalar: " << scalar_hex << endl;
                cout << "SIMD:   " << simd_hex << endl;
            }
        }
    }

    if (ok)
    {
        cout << "SIMD MD5 correctness passed" << endl;
        return 0;
    }

    cout << "SIMD MD5 correctness failed" << endl;
    return 1;
}
