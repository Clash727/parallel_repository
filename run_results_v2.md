# Lab6 Version 2: Nonblocking MPI Send Results

Version 2 is based on version 1 and replaces blocking batch sends with a bounded nonblocking send queue.

Compile:

```bash
mpic++ main.cpp train.cpp guessing.cpp md5.cpp -O2 -fopenmp -o main
g++ correctness.cpp train.cpp guessing.cpp md5.cpp -O2 -fopenmp -o correctness_hybrid
```

Key setting:

```bash
HYBRID_MAX_PENDING_SENDS=4
```

Performance:

| Version | Settings | Guess time | Hash time | Train time | Pipeline time |
| --- | --- | ---: | ---: | ---: | ---: |
| Old lab4 pipeline | GEN=1, BATCH=500000 | 0.916396s | 0.617612s | 26.4282s | 1.27826s |
| Lab6 version 1 | heap=1, train=2, generate=2, hash=2 | 0.521121s | 0.271866s | 14.6417s | 0.574321s |
| Lab6 version 2 | heap=1, train=2, generate=2, hash=2, pending=4 | 0.486616s | 0.273187s | 15.4953s | 0.539598s |
| Version 2 pending=1 | heap=1, train=2, generate=2, hash=2, pending=1 | 0.710239s | 0.458952s | 19.8658s | 0.795194s |
| Version 2 pending=8 | heap=1, train=2, generate=2, hash=2, pending=8 | 0.576482s | 0.329282s | 20.5508s | 0.631554s |

Correctness by cracked count:

| Settings | Cracked |
| --- | ---: |
| Strict order: heap=0, train=1, generate=1 | 358217 |
| Performance mode: heap=1, train=2, generate=2 | 382853 |

Notes:

- Nonblocking send uses `MPI_Isend` for both the batch size and batch data.
- Serialized buffers are kept in a pending-send list until `MPI_Testall` or `MPI_Waitall` confirms completion.
- Before sending stop signals, all pending batch sends are waited on so data messages cannot be skipped by a stop message.
- `pending=4` was best in the tested runs; `pending=1` behaves closer to waiting after each send, and `pending=8` adds more memory pressure and scheduling noise.
