# 反编译相关

本目录下存储了使用 Ghidra 反编译计算器 ROM 所需的资源与工程文件，以及 nX-U8 CPU 的补充资料。

## 用 Ghidra 反编译

1. 前往 [Ghidra 的发布页](https://github.com/NationalSecurityAgency/ghidra/releases)下载打包好的 Ghidra ZIP 文件；
2. 解压到合适的位置，将这里的 `Ghidra 的 nX-U8 语言` 文件夹重命名为 `nxu8`，并放到 `<你的 Ghidra 目录>\Ghidra\processors` 下；
3. 阅读[《用 Ghidra 分析卡西欧源代码》](https://tieba.baidu.com/p/8938265174)来开始反编译之旅。

此外这里也附带了一个能用的 Ghidra 反编译项目与反编译所得结果。

## nX-U8 处理器附加资料

本仓库所关注的计算器均使用 nX-U8 CPU，如果你想了解其指令集等技术信息，请前往「nX-U8 处理器」文件夹。