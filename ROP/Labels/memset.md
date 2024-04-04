# memset(0:F1A8)
## 函数原型
```c
byte * // ER0
memset (
    byte *ptr, // ER0
    uword data, // ER2
    uword length // 栈传递
);
```
## 功能描述
这个函数的作用是将`ptr`指向的`length`个字节设为`data`的低位（即R2）。完成后，函数返回`ptr`，栈上的`length`变为0。
## 汇编代码
```assembly
0F1A8   5E FE              PUSH    ER14
0F1AA   1A AE              MOV     ER14, SP
0F1AC   6E F8              PUSH    XR8
0F1AE   6E F4              PUSH    XR4
0F1B0   5E FC              PUSH    ER12
0F1B2   25 FA              MOV     ER10, ER2
0F1B4   05 F8              MOV     ER8, ER0
0F1B6   A0 86              MOV     R6, R10
0F1B8   05 F4              MOV     ER4, ER0
0F1BA   07 CE              BC      AL, 0F1CAh
0F1BC   45 FC              MOV     ER12, ER4
0F1BE   41 96              ST      R6, [ER4]
0F1C0   81 EC              ADD     ER12, #1
0F1C2   C5 F4              MOV     ER4, ER12
0F1C4   42 BC              L       ER12, 02h[FP]
0F1C6   FF EC              ADD     ER12, #-1
0F1C8   C2 BC              ST      ER12, 02h[FP]
0F1CA   00 E0              MOV     ER0, #0
0F1CC   42 BC              L       ER12, 02h[FP]
0F1CE   C7 F0              CMP     ER0, ER12
0F1D0   F5 C1              BC      LT, 0F1BCh
0F1D2   85 F0              MOV     ER0, ER8
0F1D4   1E FC              POP     ER12
0F1D6   2E F4              POP     XR4
0F1D8   2E F8              POP     XR8
0F1DA   EA A1              MOV     SP, ER14
0F1DC   1E FE              POP     ER14
0F1DE   1F FE              RT
```
