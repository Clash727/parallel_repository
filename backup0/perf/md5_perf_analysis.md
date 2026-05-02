# MD5 perf analysis: backup0 serial vs backup1 initial NEON

## Scope

This perf analysis focuses on the MD5 stage. The measured executable is still the full PCFG+MD5 program, so the top-level perf profile also contains PCFG training and ordering cost. To isolate the MD5-related part, the analysis uses perf report and compares the symbols MD5Hash, StringProcess, and MD5Hash_NEON, while using the program's own Hash time as the direct MD5-stage timing.

## Commands used

`ash
cd ~/guess/backup0
g++ -g main.cpp train.cpp guessing.cpp md5.cpp -o main_scalar
perf record -g -o perf_scalar_O0.data ./main_scalar
perf report -i perf_scalar_O0.data --stdio > perf_report_scalar_O0.txt
perf report -i perf_scalar_O0.data --stdio --no-children --sort symbol > perf_flat_scalar_O0.txt

g++ -g main.cpp train.cpp guessing.cpp md5.cpp -o main_scalar_O2 -O2
perf record -g -o perf_scalar_O2.data ./main_scalar_O2
perf report -i perf_scalar_O2.data --stdio > perf_report_scalar_O2.txt
perf report -i perf_scalar_O2.data --stdio --no-children --sort symbol > perf_flat_scalar_O2.txt

cd ~/guess/backup1
g++ -g main.cpp train.cpp guessing.cpp md5.cpp -o main_neon_old
perf record -g -o perf_neon_old_O0.data ./main_neon_old
perf report -i perf_neon_old_O0.data --stdio > perf_report_neon_old_O0.txt
perf report -i perf_neon_old_O0.data --stdio --no-children --sort symbol > perf_flat_neon_old_O0.txt

g++ -g main.cpp train.cpp guessing.cpp md5.cpp -o main_neon_old_O2 -O2
perf record -g -o perf_neon_old_O2.data ./main_neon_old_O2
perf report -i perf_neon_old_O2.data --stdio > perf_report_neon_old_O2.txt
perf report -i perf_neon_old_O2.data --stdio --no-children --sort symbol > perf_flat_neon_old_O2.txt
`

## Results

| Version | Build | Hash time | MD5-related perf hotspot |
|---|---:|---:|---:|
| backup0 serial | O0 | 9.88629 s | MD5Hash 5.69%, StringProcess 0.36% |
| backup1 initial NEON | O0 | 12.8721 s | MD5Hash_NEON 9.18% |
| backup0 serial | O2 | 3.11175 s | MD5Hash 4.70%, StringProcess 0.25% |
| backup1 initial NEON | O2 | 1.34859 s | MD5Hash_NEON 3.38% |

## Serial MD5 analysis

In the serial version, MD5 is represented mainly by two symbols:

- MD5Hash: the core scalar MD5 computation.
- StringProcess: message padding and block preparation.

At O0, MD5Hash accounts for 5.69% of total sampled cycles, and StringProcess accounts for 0.36%. The direct hash-stage timing is 9.88629 s. At O2, MD5Hash drops to 4.70%, and StringProcess drops to 0.25%, while Hash time drops to 3.11175 s. This shows that compiler optimization substantially improves the scalar MD5 implementation, especially by reducing function-call overhead, redundant loads/stores, and temporary variables.

## Initial NEON MD5 analysis

The initial NEON implementation uses MD5Hash_NEON, which processes four passwords in parallel with NEON intrinsics. In O2, this version is effective: Hash time decreases from 3.11175 s to 1.34859 s, a speedup of about 2.31x over the scalar O2 version. The MD5Hash_NEON hotspot is 3.38%, lower than the scalar MD5Hash hotspot of 4.70%, which is consistent with the reduced MD5-stage runtime.

However, at O0, initial NEON is slower than serial. Hash time increases from 9.88629 s to 12.8721 s, giving only about 0.77x speedup. perf also shows MD5Hash_NEON taking 9.18% of total samples, higher than serial MD5Hash plus StringProcess at about 6.05%. This indicates that the initial SIMD code introduces significant overhead when compiler optimization is disabled.

The main sources of overhead in the initial NEON version are:

1. Per-batch construction of string inputs[4] in main.cpp, which adds string copy/destruction cost.
2. Construction of locks[4][64] before packing data into NEON vectors, which adds an extra memory-write/read layer.
3. Nested NEON intrinsic expressions such as addq_u32(vaddq_u32(...)), which at O0 tend to produce many temporary values and stack loads/stores instead of staying in registers.

## Full-program context

The top perf symbols are not MD5 functions but PCFG-related functions such as model::FindPT, model::parse, model::order, and STL hash/sort routines. This is expected because the full program includes PCFG training and ordering, and the training stage dominates the elapsed time. Therefore, the most meaningful MD5 performance metric is the program's own Hash time, while perf report is used to confirm where the MD5-related samples occur and how the hotspot changes between serial and NEON implementations.

## Conclusion

For the initial NEON implementation, SIMD parallelism is beneficial under O2, reducing MD5 Hash time from 3.11175 s to 1.34859 s. Under O0, the initial NEON implementation is slower than scalar because the compiler does not optimize away intrinsic-related temporary values and data-packing overhead. This explains why the later optimized version was developed after inspecting assembly and reducing the overhead around NEON operations.
