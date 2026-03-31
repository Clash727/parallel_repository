#include <chrono>
#include <iomanip>
#include <iostream>
#include <string>
#include <vector>

#ifdef _WIN32
#include <windows.h>
#endif

using namespace std;
const int LOOP = 10;
const int TEST_COUNT = 8;
const int test_sizes[TEST_COUNT] = { 4096, 8192, 32768, 131072, 262144, 1048576, 2097152, 4194304 };
const int PRECISION_TEST_COUNT = 8;
const int precision_sizes[PRECISION_TEST_COUNT] = { 4, 8, 16, 64, 256, 1024, 4096, 16384 };
vector<double> a;
vector<double> work;
double sum1 = 0;
double sum2 = 0;
double sum3 = 0;
volatile double sink = 0;

void init(int n) {
    a.assign(n, 1.0);
    work.resize(n);
}

void init_precision_case(int n) {
    a.resize(n);
    work.resize(n);
    for (int i = 0; i < n; i += 4) {
        a[i] = 1e16;
        a[i + 1] = 1.0;
        a[i + 2] = -1e16;
        a[i + 3] = 1.0;
    }
}

void ordinary(int n) {
    sum1 = 0;
    for (int i = 0; i < n; i++) {
        sum1 += a[i];
    }
    sink = sum1;
}

void optimize(int n) {
    double tmp1 = 0;
    double tmp2 = 0;
    int i = 0;
    for (; i <= n - 2; i += 2) {
        tmp1 += a[i];
        tmp2 += a[i + 1];
    }
    for (; i < n; i++) {
        tmp1 += a[i];
    }
    sum2 = tmp1 + tmp2;
    sink = sum2;
}

void recursive_reduce(int n) {
    if (n <= 1) {
        return;
    }
    int next_n = (n + 1) / 2;
    int i = 0;
    for (; i + 1 < n; i += 2) {
        work[i / 2] = work[i] + work[i + 1];
    }
    if (i < n) {
        work[i / 2] = work[i];
    }
    recursive_reduce(next_n);
}

void recursive(int n) {
    for (int i = 0; i < n; i++) {
        work[i] = a[i];
    }
    recursive_reduce(n);
    sum3 = work[0];
    sink = sum3;
}

template <typename Func>
double measure_ms(Func func) {
#ifdef _WIN32
    static LARGE_INTEGER freq = []() {
        LARGE_INTEGER value;
        QueryPerformanceFrequency(&value);
        return value;
    }();
    LARGE_INTEGER begin;
    LARGE_INTEGER end;
    QueryPerformanceCounter(&begin);
    func();
    QueryPerformanceCounter(&end);
    return (end.QuadPart - begin.QuadPart) * 1000.0 / freq.QuadPart;
#else
    auto begin = chrono::steady_clock::now();
    func();
    auto end = chrono::steady_clock::now();
    return chrono::duration<double, milli>(end - begin).count();
#endif
}

void run_precision_experiment() {
    cout << endl;
    cout << "precision experiment" << endl;
    cout << scientific << setprecision(6);

    for (int k = 0; k < PRECISION_TEST_COUNT; k++) {
        int n = precision_sizes[k];
        double exact = n / 2.0;

        init_precision_case(n);
        ordinary(n);
        optimize(n);
        recursive(n);

        cout << "precision n=" << n
             << " exact=" << exact
             << " ordinary=" << sum1
             << " optimize=" << sum2
             << " recursive=" << sum3 << endl;
    }

    cout << fixed << setprecision(3);
}

void run_bench() {
    cout << fixed << setprecision(3);

    for (int k = 0; k < TEST_COUNT; k++) {
        int n = test_sizes[k];
        double ordinary_time = 0;
        double optimize_time = 0;
        double recursive_time = 0;
        double array_size_mb = 1.0 * n * sizeof(double) / 1024 / 1024;

        init(n);

        for (int i = 0; i < LOOP; i++) {
            ordinary_time += measure_ms([&]() { ordinary(n); });
        }

        for (int i = 0; i < LOOP; i++) {
            optimize_time += measure_ms([&]() { optimize(n); });
        }

        for (int i = 0; i < LOOP; i++) {
            recursive_time += measure_ms([&]() { recursive(n); });
        }

        cout << "n=" << n
             << " array=" << array_size_mb << " MB"
             << " ordinary=" << ordinary_time / LOOP << " ms"
             << " optimize=" << optimize_time / LOOP << " ms"
             << " recursive=" << recursive_time / LOOP << " ms"
             << " opt_speedup=" << ordinary_time / optimize_time << "x"
             << " recursive_speedup=" << ordinary_time / recursive_time << "x"
             << " recursive_vs_opt=" << optimize_time / recursive_time << "x" << endl;
    }
}

void run_profile(string kernel, int n, int repeat, int warmup, bool precision_case) {
    void (*kernel_func)(int) = ordinary;
    double* sum_value = &sum1;

    if (kernel == "optimize") {
        kernel_func = optimize;
        sum_value = &sum2;
    }
    else if (kernel == "recursive") {
        kernel_func = recursive;
        sum_value = &sum3;
    }
    if (precision_case) {
        init_precision_case(n);
    }
    else {
        init(n);
    }
    for (int i = 0; i < warmup; i++) {
        kernel_func(n);
    }
    double total_ms = measure_ms([&]() {
        for (int i = 0; i < repeat; i++) {
            kernel_func(n);
        }
    });
    cout << fixed << setprecision(6);
    cout << "profile kernel=" << kernel
         << " n=" << n
         << " repeat=" << repeat
         << " warmup=" << warmup
         << " init=" << (precision_case ? "precision" : "ones")
         << " total_ms=" << total_ms
         << " avg_ms=" << total_ms / repeat
         << " sum=" << *sum_value << endl;
}

int main(int argc, char* argv[]) {
    if (argc > 1 && string(argv[1]) == "precision") {
        run_precision_experiment();
        return 0;
    }
    if (argc > 1 && string(argv[1]) == "profile") {
        string kernel = "ordinary";
        int n = 1048576;
        int repeat = 20000;
        int warmup = 200;
        bool precision_case = false;

        if (argc > 2) {
            kernel = argv[2];
        }
        if (argc > 3) {
            n = atoi(argv[3]);
        }
        if (argc > 4) {
            repeat = atoi(argv[4]);
        }
        if (argc > 5) {
            warmup = atoi(argv[5]);
        }
        if (argc > 6 && string(argv[6]) == "precision") {
            precision_case = true;
        }

        run_profile(kernel, n, repeat, warmup, precision_case);
        return 0;
    }
    run_bench();
    run_precision_experiment();
    return 0;
}
