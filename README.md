# CS61C Assignments Learning Archive

UC Berkeley CS61C Fall 2020 labs and projects learning archive. This repository is used to track my practice around computer architecture, C programming, RISC-V assembly, memory layout, and performance-oriented systems programming.

*English | [中文](#中文说明)*

---

## English

### Overview

CS61C focuses on the machine structures behind software. This repo keeps the course labs and projects in one place so I can review the full path from C programs to assembly, circuits, CPU design, and performance optimization.

### What I Practice Here

| Area | Related Content |
| --- | --- |
| C programming | pointers, memory management, Makefile workflow |
| RISC-V assembly | calling convention, matrix operations, low-level debugging |
| Digital logic | Logisim circuits, ALU, register file, CPU datapath |
| Computer architecture | cache, pipeline basics, memory hierarchy |
| Performance | matrix operations, profiling, optimization mindset |

### Repository Layout

```text
.
├── Lab/        # CS61C labs
├── Project/    # course projects
└── tools/      # Venus / Logisim setup notes and helper scripts
```

### Highlights

- `Project/proj1`: C programming practice around image data and Game of Life.
- `Project/proj2`: RISC-V assembly project for matrix operations and classification.
- `Project/proj3`: Logisim CPU components and datapath practice.
- `Project/proj4`: C extension / numerical computing practice.
- `tools/tutorial.md`: environment notes for Venus and Logisim.

### Setup Notes

See [tools/tutorial.md](tools/tutorial.md) for Venus and Logisim setup notes.

General requirements may include:

- `gcc` / `clang`
- `make`
- Java runtime for course tools
- Python for test runners and helper scripts

### Disclaimer

This repository is for personal learning and review. It is not affiliated with UC Berkeley or the CS61C teaching team. Course materials belong to their respective authors; please respect academic integrity policies.

---

## 中文说明

### 项目简介

这是我的 CS61C Fall 2020 课程实验与项目学习归档，主要用于复习计算机组成、C 语言、RISC-V 汇编、数字逻辑、CPU 数据通路和性能优化相关内容。

### 学习内容

| 方向 | 内容 |
| --- | --- |
| C 语言基础 | 指针、内存管理、Makefile、调试 |
| RISC-V 汇编 | 调用约定、矩阵运算、底层程序结构 |
| 数字逻辑 | Logisim 电路、ALU、寄存器堆、CPU 组件 |
| 计算机组成 | 缓存、流水线基础、内存层次结构 |
| 性能优化 | 矩阵计算、测试、profiling 思路 |

### 目录结构

```text
.
├── Lab/        # 课程实验
├── Project/    # 课程项目
└── tools/      # Venus / Logisim 环境说明和辅助脚本
```

### 项目亮点

- `Project/proj1`：围绕图像数据和生命游戏的 C 语言练习。
- `Project/proj2`：使用 RISC-V 汇编完成矩阵运算与分类流程。
- `Project/proj3`：使用 Logisim 练习 CPU 组件和数据通路。
- `Project/proj4`：C 扩展和数值计算相关练习。
- `tools/tutorial.md`：Venus 与 Logisim 的环境配置说明。

### 环境说明

Venus 和 Logisim 环境可参考 [tools/tutorial.md](tools/tutorial.md)。

常用依赖：

- `gcc` / `clang`
- `make`
- Java runtime
- Python

### 免责声明

本仓库仅用于个人学习和复盘，与 UC Berkeley 或 CS61C 教学团队无关。课程材料版权归原作者所有，请遵守学术诚信要求。
