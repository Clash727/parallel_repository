# Lab6 Hybrid MPI + OpenMP + SIMD Run Results

Environment: remote ARM/Linux guess workspace.

Compile:

```bash
mpic++ main.cpp train.cpp guessing.cpp md5.cpp -O2 -fopenmp -o main
g++ correctness.cpp train.cpp guessing.cpp md5.cpp -O2 -fopenmp -o correctness_hybrid
```

Baseline before hybrid changes:

```bash
/usr/local/bin/mpiexec -np 4 ./main 1 500000
```

Result:

| Version | Settings | Guess time | Hash time | Train time | Pipeline time |
| --- | --- | ---: | ---: | ---: | ---: |
| Old lab4 pipeline | GEN=1, BATCH=500000 | 0.916396s | 0.617612s | 26.4282s | 1.27826s |
| Hybrid default | heap=1, train=2, generate=2, hash=2 | 0.521121s | 0.271866s | 14.6417s | 0.574321s |
| Hybrid heap on | heap=1, train=2, generate=2, hash=1 | 0.619051s | 0.488265s | 14.8002s | 0.705594s |
| Hybrid strict queue | heap=0, train=2, generate=2, hash=1 | 0.993696s | 0.71186s | 15.9792s | 1.449s |

Correctness checks:

| Settings | Cracked |
| --- | ---: |
| heap=0, train=1, generate=1 | 358217 |
| heap=0, train=2, generate=2 | 358220 |
| heap=1, train=2, generate=2 | 382853 |

Notes:

- `heap=0, train=1, generate=1` preserves the original queue and training order, matching the old correctness result.
- OpenMP local-model training changes a few equal-frequency ties, so the 10M-candidate truncation may differ by a few cracked passwords.
- Heap priority queue preserves probability priority but changes tie/truncation order more significantly; use it for performance experiments and discuss the ordering effect in the report.
