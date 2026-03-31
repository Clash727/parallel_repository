#include <chrono>
#include <ctime>
#include <cstdlib>
#include <iomanip>
#include <iostream>
#include <string>
#ifdef _WIN32
#include <windows.h>
#endif

using namespace std;
const int N = 4096;
const int LOOP = 10;
const int TEST_COUNT = 6;
const int test_sizes[TEST_COUNT] = { 128, 256, 512, 1024, 2048, 4096 };
volatile double sink = 0;
double a[N];
double b[N][N];
double sum1[N];
double sum2[N];
double sum3[N];

void init(int n) {
    for (int i = 0; i < n; i++) {
        a[i] = rand() % 11 - 5;
    }
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            b[i][j] = rand() % 13 - 6;
        }
    }
}

void ordinary(int n) {
    for (int col = 0; col < n; col++) {
        sum1[col] = 0;
        for (int row = 0; row < n; row++) {
            sum1[col] += a[row] * b[row][col];
        }
    }
    sink = sum1[0];
}

void optimize(int n) {
    for (int col = 0; col < n; col++) {
        sum2[col] = 0;
    }
    for (int row = 0; row < n; row++) {
        for (int col = 0; col < n; col++) {
            sum2[col] += a[row] * b[row][col];
        }
    }
    sink = sum2[0];
}

void unroll(int n) {
    for (int col = 0; col < n; col++) {
        sum3[col] = 0;
    }
    for (int row = 0; row < n; row++) {
        int col = 0;
        for (; col <= n - 4; col += 4) {
            sum3[col] += a[row] * b[row][col];
            sum3[col + 1] += a[row] * b[row][col + 1];
            sum3[col + 2] += a[row] * b[row][col + 2];
            sum3[col + 3] += a[row] * b[row][col + 3];
        }
        for (; col < n; col++) {
            sum3[col] += a[row] * b[row][col];
        }
    }
    sink = sum3[0];
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

void run_bench() {
    cout << fixed << setprecision(3);

    for (int k = 0; k < TEST_COUNT; k++) {
        int n = test_sizes[k];
        double ordinary_time = 0;
        double optimize_time = 0;
        double unroll_time = 0;
        double matrix_size_mb = 1.0 * n * n * sizeof(double) / 1024 / 1024;

        init(n);

        for (int i = 0; i < LOOP; i++) {
            ordinary_time += measure_ms([&]() { ordinary(n); });
        }
        for (int i = 0; i < LOOP; i++) {
            optimize_time += measure_ms([&]() { optimize(n); });
        }
        for (int i = 0; i < LOOP; i++) {
            unroll_time += measure_ms([&]() { unroll(n); });
        }
        cout << "n=" << n
             << " matrix=" << matrix_size_mb << " MB"
             << " ordinary=" << ordinary_time / LOOP << " ms"
             << " optimize=" << optimize_time / LOOP << " ms"
             << " unroll=" << unroll_time / LOOP << " ms"
             << " opt_speedup=" << ordinary_time / optimize_time << "x"
             << " unroll_speedup=" << ordinary_time / unroll_time << "x"
             << " unroll_vs_opt=" << optimize_time / unroll_time << "x" << endl;
    }
}

void run_profile(string kernel, int n, int repeat, int warmup) {
    void (*kernel_func)(int) = ordinary;
    double* sum_head = &sum1[0];
    if (kernel == "optimize") {
        kernel_func = optimize;
        sum_head = &sum2[0];
    }
    else if (kernel == "unroll") {
        kernel_func = unroll;
        sum_head = &sum3[0];
    }
    init(n);
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
         << " total_ms=" << total_ms
         << " avg_ms=" << total_ms / repeat
         << " sum0=" << *sum_head << endl;
}

int main(int argc, char* argv[]) {
    srand((unsigned)time(NULL));

    if (argc > 1 && string(argv[1]) == "profile") {
        string kernel = "ordinary";
        int n = 4096;
        int repeat = 100;
        int warmup = 5;

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

        run_profile(kernel, n, repeat, warmup);
        return 0;
    }

    run_bench();
    return 0;
}
