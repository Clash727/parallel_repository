# 进阶要求 5 数据摘要

## 实验一

- MSVC `/O2` 与 GCC `-O2 -S -masm=intel` 都保留了 ordinary 的跨步长访存特征。
- optimize 在两种编译器下都变成连续地址访问，MSVC 还出现了自动展开。
- unroll 只是在连续访存基础上增加指令密度，没有改变 optimize 的核心优势。

## 实验二

- ordinary 依然是单累加链，核心瓶颈是数据相关。
- optimize 在两种编译器下都拆成两条独立累加链，对应更高的 ILP。
- recursive 需要额外复制和多轮写回，说明其性能劣势主要来自额外内存流量。
