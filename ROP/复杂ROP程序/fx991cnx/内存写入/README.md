
# 内存写入

为fx-991cnx(**ver C**)设计的快速内存写入程序

## 效果

注：该程序不具有用户界面，只作为注入其他程序的辅助程序

使用该程序可直接使用十六进制数码向内存中注入数据，且在完成一次注入后地址自动增加，因此只需使用lbf转换器即可完成任意内容（包括0x00）的注入。
单次操作可注入0x18字节。

使用方法：输入本次要注入的24个字节所对应的十六进制数码（共48个字符），并在结尾加上
`k 0 1 0 0 0 0 0 0 0 - ! 8 @ 2 0`   (即：`E2 30 31 30 30 30 30 30 30 30 C0 D8 38 1D 32 30`)
随后按等号即可。

**正常情况下按等号后无明显现象，但此时已完成注入及地址自增，请勿重复按等号。**

## 注入

目录中所提供的文件为需要存储在0xD820处的程序。

**注：程序的存储位置及单次注入长度均可修改，但需同时修改程序内的相关参数。若需要注入的主程序与内存写入程序的地址冲突，则需调整写入程序及其所使用的内存区域的位置.**

程序设计为在124an下运行。限于该状态的特性，内存写入程序最少需要通过执行**4**次依赖`strcpy`(0:D070h)的ROP链完成注入。该ROP链形式如下：

`[48字节] E2 30 31 30 [目标地址] 8C D2 30 30 A2 D5 70 D0 30 30 38 1D 32 30 [注入内容]`

完成程序注入后，须通过`memcpy`(0:86F0h)创建程序副本，从而使程序能重复运行。该ROP链如下：

`[48字节] E2 30 31 30 C2 D8 20 D8 30 30 A2 D5 F0 86 30 30 30 01 38 1D 32 30`

随后须设置初始注入目标地址。由于程序每次运行时先执行地址自增，再进行写入，因此初始化值应为目标地址-0x18。该ROP链如下：

`[48字节] E2 30 31 30 30 30 [目标地址-0x18] 30 30 A2 D5 6C C0 30 30 C0 D9 28 8F 30 30 30 30 30 30 38 1D 32 30`

完成地址设置后即可开始注入主程序。若须修改注入地址则可重新执行用以设置地址的ROP链。

进入124an模式（复数，线性）后注入内存写入程序并初始化地址为0xE9E0(实际值0xE9C8)所需的全部按键操作在`quickcpy_key_script.bin`中提供。该文件可用于在[CasioEmuX](https://github.com/Xyzstk/CasioEmuX)的最新commit中执行自动输入。（执行方式：在控制台中输入并执行`keyinj([文件名],[单次按下时长(毫秒)],[按键间隔时长(毫秒)])`）
