# strcpy(0:D070)
## 汇编代码
```assembly
0D070   6E F8              PUSH    XR8
0D072   5E FC              PUSH    ER12
0D074   05 F8              MOV     ER8, ER0
0D076   25 FA              MOV     ER10, ER2
0D078   05 FC              MOV     ER12, ER0
0D07A   A0 90              L       R0, [ER10]
0D07C   C1 90              ST      R0, [ER12]
0D07E   81 EA              ADD     ER10, #1
0D080   81 EC              ADD     ER12, #1
0D082   00 80              MOV     R0, R0
0D084   FA C8              BC      NE, 0D07A
0D086   85 F0              MOV     ER0, ER8
0D088   1E FC              POP     ER12
0D08A   2E F8              POP     XR8
0D08C   1F FE              RT
```

## C语言反编译（仅供参考）
```c
char * // ER0
strcpy (
    char *destination, // ER0
    const char *source  // ER2
) {
  char c;
  char *ptr = destination;
  do {
    c = *source;
    *ptr = c;
    source ++;
    ptr ++;
  } while (c != '\0');
  return destination;
}
```

## 代码描述
这个函数的作用是将`source`指向的nul结尾字符串复制到`destination`指向的位置。复制完成后，函数返回`destination`，即复制的字符串的起始地址。

## ROP 示例
### 内存注入
ROP字符串：{n-76个数字}<sup>*</sup>  e2 30 31 30 __ __ {2位地址} <0x4c+n><sup>**</sup> d1 30 30 a2 d5 70 d0 30 30 38 1d 32 30 30 30 33 23

\*:  n为an前的字符数，为十进制偶数。例：当n=124时，n-76=48，即前面需要垫48个字符（推荐用1，2，3 ··· 0计数）；

\**: 须填十六进制数0x4C+十进制数n。例：当n=124时，0x4c+124=0xc8。
