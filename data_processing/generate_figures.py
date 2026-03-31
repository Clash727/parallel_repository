from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd


ROOT = Path(__file__).resolve().parents[1]
DATA_DIR = ROOT / "data"
FIG_DIR = ROOT / "fig"
FIG_DIR.mkdir(parents=True, exist_ok=True)

plt.rcParams["font.sans-serif"] = [
    "Microsoft YaHei",
    "SimHei",
    "Noto Sans CJK SC",
    "Arial Unicode MS",
    "DejaVu Sans",
]
plt.rcParams["axes.unicode_minus"] = False
plt.rcParams["figure.dpi"] = 150
plt.rcParams["savefig.dpi"] = 300


COLORS = {
    "ordinary": "#4C78A8",
    "optimize": "#F58518",
    "unroll": "#54A24B",
    "recursive": "#E45756",
    "exact": "#72B7B2",
}


def save(fig, name: str):
    fig.tight_layout()
    fig.savefig(FIG_DIR / name, bbox_inches="tight")
    plt.close(fig)


def exp1_access_pattern():
    fig, axes = plt.subplots(1, 2, figsize=(11, 4.6))
    titles = ["ordinary：逐列访问", "optimize：逐行访问"]
    subtitles = ["跨行跳跃，空间局部性差", "连续访问，充分利用 cache line"]
    arrow_color = ["#C44E52", "#4C78A8"]

    for ax, title, subtitle, color, mode in zip(axes, titles, subtitles, arrow_color, ["col", "row"]):
        ax.set_xlim(0, 4)
        ax.set_ylim(0, 4)
        ax.set_xticks(range(4))
        ax.set_yticks(range(4))
        ax.set_aspect("equal")
        ax.invert_yaxis()
        for i in range(4):
            for j in range(4):
                rect = plt.Rectangle((j, i), 1, 1, fill=False, edgecolor="#BBBBBB", linewidth=1.5)
                ax.add_patch(rect)
                ax.text(j + 0.5, i + 0.5, f"b[{i},{j}]", ha="center", va="center", fontsize=9)

        if mode == "col":
            path = [(0.5, 0.5), (0.5, 1.5), (0.5, 2.5), (0.5, 3.5), (1.5, 0.5), (1.5, 1.5)]
        else:
            path = [(0.5, 0.5), (1.5, 0.5), (2.5, 0.5), (3.5, 0.5), (0.5, 1.5), (1.5, 1.5)]

        for (x1, y1), (x2, y2) in zip(path, path[1:]):
            ax.annotate(
                "",
                xy=(x2, y2),
                xytext=(x1, y1),
                arrowprops=dict(arrowstyle="->", lw=2.2, color=color),
            )

        ax.set_title(title, fontsize=13, pad=10)
        ax.text(0.5, 1.02, subtitle, transform=ax.transAxes, ha="center", fontsize=10, color="#444444")
        ax.set_xlabel("列索引")
        ax.set_ylabel("行索引")

    fig.suptitle("实验一访问模式示意图", fontsize=16, y=1.02)
    save(fig, "exp1_access_pattern.png")


def exp1_performance():
    df = pd.read_csv(DATA_DIR / "exp1_bench.csv")
    fig, axes = plt.subplots(1, 2, figsize=(12, 4.8))

    ax = axes[0]
    ax.plot(df["size"], df["ordinary_ms"], marker="o", linewidth=2.2, color=COLORS["ordinary"], label="ordinary")
    ax.plot(df["size"], df["optimize_ms"], marker="o", linewidth=2.2, color=COLORS["optimize"], label="optimize")
    ax.plot(df["size"], df["unroll_ms"], marker="o", linewidth=2.2, color=COLORS["unroll"], label="unroll")
    ax.set_xscale("log", base=2)
    ax.set_yscale("log")
    ax.set_xlabel("矩阵规模 n")
    ax.set_ylabel("平均时间 / ms")
    ax.set_title("运行时间对比")
    ax.grid(True, linestyle="--", alpha=0.35)
    ax.legend()

    ax = axes[1]
    ax.plot(df["size"], df["opt_speedup"], marker="o", linewidth=2.2, color=COLORS["optimize"], label="optimize vs ordinary")
    ax.plot(df["size"], df["unroll_speedup"], marker="o", linewidth=2.2, color=COLORS["unroll"], label="unroll vs ordinary")
    ax.set_xscale("log", base=2)
    ax.set_xlabel("矩阵规模 n")
    ax.set_ylabel("加速比")
    ax.set_title("加速比对比")
    ax.grid(True, linestyle="--", alpha=0.35)
    ax.legend()

    fig.suptitle("实验一性能与加速比", fontsize=16)
    save(fig, "exp1_performance.png")


def exp1_profile_platform():
    profile = pd.read_csv(DATA_DIR / "exp1_profile.csv")
    platform = pd.read_csv(DATA_DIR / "exp1_platform.csv")
    rep = platform[platform["size"] == 4096]

    fig, axes = plt.subplots(1, 2, figsize=(12, 4.8))

    ax = axes[0]
    x = np.arange(len(profile["kernel"]))
    w = 0.35
    ax.bar(x - w / 2, profile["ipc"], width=w, color=COLORS["optimize"], label="IPC")
    ax.bar(x + w / 2, profile["cpi"], width=w, color=COLORS["ordinary"], label="CPI")
    ax.set_xticks(x)
    ax.set_xticklabels(profile["kernel"])
    ax.set_ylabel("指标值")
    ax.set_title("Windows AMDuProf 指标")
    ax.legend()
    ax.grid(axis="y", linestyle="--", alpha=0.35)

    ax = axes[1]
    labels = [f"{row.platform}\nordinary" if i % 2 == 0 else f"{row.platform}\noptimize" for i, row in enumerate(rep.loc[rep.index.repeat(2)].itertuples())]
    values = []
    colors = []
    for row in rep.itertuples():
        values.extend([row.ordinary_ms, row.optimize_ms])
        colors.extend([COLORS["ordinary"], COLORS["optimize"]])
    ax.bar(range(len(values)), values, color=colors)
    ax.set_xticks(range(len(values)))
    ax.set_xticklabels(labels)
    ax.set_ylabel("平均时间 / ms")
    ax.set_title("代表规模平台对比（n=4096）")
    ax.grid(axis="y", linestyle="--", alpha=0.35)

    fig.suptitle("实验一 profiling 与跨平台对比", fontsize=16)
    save(fig, "exp1_profile_platform.png")


def exp2_performance():
    df = pd.read_csv(DATA_DIR / "exp2_bench.csv")
    fig, axes = plt.subplots(1, 2, figsize=(12, 4.8))

    ax = axes[0]
    ax.plot(df["size"], df["ordinary_ms"], marker="o", linewidth=2.2, color=COLORS["ordinary"], label="ordinary")
    ax.plot(df["size"], df["optimize_ms"], marker="o", linewidth=2.2, color=COLORS["optimize"], label="optimize")
    ax.plot(df["size"], df["recursive_ms"], marker="o", linewidth=2.2, color=COLORS["recursive"], label="recursive")
    ax.set_xscale("log", base=2)
    ax.set_yscale("log")
    ax.set_xlabel("数组规模 n")
    ax.set_ylabel("平均时间 / ms")
    ax.set_title("运行时间对比")
    ax.grid(True, linestyle="--", alpha=0.35)
    ax.legend()

    ax = axes[1]
    ax.plot(df["size"], df["opt_speedup"], marker="o", linewidth=2.2, color=COLORS["optimize"], label="optimize vs ordinary")
    ax.plot(df["size"], df["recursive_speedup"], marker="o", linewidth=2.2, color=COLORS["recursive"], label="recursive vs ordinary")
    ax.set_xscale("log", base=2)
    ax.set_xlabel("数组规模 n")
    ax.set_ylabel("加速比")
    ax.set_title("加速比对比")
    ax.grid(True, linestyle="--", alpha=0.35)
    ax.legend()

    fig.suptitle("实验二性能与加速比", fontsize=16)
    save(fig, "exp2_performance.png")


def exp2_precision():
    df = pd.read_csv(DATA_DIR / "exp2_precision.csv")
    fig, axes = plt.subplots(1, 2, figsize=(12, 4.8))

    ax = axes[0]
    ax.plot(df["size"], df["exact"], marker="o", linewidth=2.2, color=COLORS["exact"], label="exact")
    ax.plot(df["size"], df["optimize"], marker="o", linewidth=2.2, color=COLORS["optimize"], label="optimize")
    ax.plot(df["size"], df["ordinary"], marker="o", linewidth=2.2, color=COLORS["ordinary"], label="ordinary")
    ax.plot(df["size"], df["recursive"], marker="o", linewidth=2.2, color=COLORS["recursive"], label="recursive")
    ax.set_xscale("log", base=2)
    ax.set_xlabel("数组规模 n")
    ax.set_ylabel("求和值")
    ax.set_title("不同求和顺序的结果")
    ax.grid(True, linestyle="--", alpha=0.35)
    ax.legend()

    ax = axes[1]
    for col, color in [("ordinary", COLORS["ordinary"]), ("optimize", COLORS["optimize"]), ("recursive", COLORS["recursive"])]:
        ax.plot(df["size"], np.abs(df[col] - df["exact"]), marker="o", linewidth=2.2, label=f"|{col} - exact|", color=color)
    ax.set_xscale("log", base=2)
    ax.set_yscale("log")
    ax.set_xlabel("数组规模 n")
    ax.set_ylabel("绝对误差")
    ax.set_title("相对 exact 的误差")
    ax.grid(True, linestyle="--", alpha=0.35)
    ax.legend()

    fig.suptitle("实验二浮点精度对比", fontsize=16)
    save(fig, "exp2_precision.png")


def exp2_profile_platform():
    profile = pd.read_csv(DATA_DIR / "exp2_profile.csv")
    platform = pd.read_csv(DATA_DIR / "exp2_platform.csv")

    fig, axes = plt.subplots(1, 2, figsize=(12, 4.8))

    ax = axes[0]
    x = np.arange(len(profile["kernel"]))
    w = 0.35
    ax.bar(x - w / 2, profile["ipc"], width=w, color=COLORS["optimize"], label="IPC")
    ax.bar(x + w / 2, profile["cpi"], width=w, color=COLORS["ordinary"], label="CPI")
    ax.set_xticks(x)
    ax.set_xticklabels(profile["kernel"])
    ax.set_ylabel("指标值")
    ax.set_title("Windows AMDuProf 指标")
    ax.legend()
    ax.grid(axis="y", linestyle="--", alpha=0.35)

    ax = axes[1]
    labels = []
    values = []
    colors = []
    for row in platform.itertuples():
        labels.extend([f"{row.platform}\nordinary", f"{row.platform}\noptimize"])
        values.extend([row.ordinary_ms, row.optimize_ms])
        colors.extend([COLORS["ordinary"], COLORS["optimize"]])
    ax.bar(range(len(values)), values, color=colors)
    ax.set_xticks(range(len(values)))
    ax.set_xticklabels(labels)
    ax.set_ylabel("平均时间 / ms")
    ax.set_title("代表规模平台对比（n=1048576）")
    ax.grid(axis="y", linestyle="--", alpha=0.35)

    fig.suptitle("实验二 profiling 与跨平台对比", fontsize=16)
    save(fig, "exp2_profile_platform.png")


def main():
    exp1_access_pattern()
    exp1_performance()
    exp1_profile_platform()
    exp2_performance()
    exp2_precision()
    exp2_profile_platform()
    print("Generated 6 figures in", FIG_DIR)


if __name__ == "__main__":
    main()
