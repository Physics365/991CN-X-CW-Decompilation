# strcpy
## _0 D0 70
### 汇编代码
```assembly
                      ************************************************
                      *                   FUNCTION                    *
                      ************************************************
                      char * default FUN_rom_00d070(char * param_1,
          char *16      ER0:2      <RETURN>
          char *16      ER0:2      param_1
          char *16      ER2:2      param_2
                      FUN_rom_00d070                        XREF[1]:  FUN_rom_0203c2:0203cc(c)  
   rom:00d070 6e f8       PUSH     XR8
   rom:00d072 5e fc       PUSH     ER12
   rom:00d074 05 f8       MOV      ER8,param_1
   rom:00d076 25 fa       MOV      ER10,param_2
   rom:00d078 05 fc       MOV      ER12,param_1
                      LAB_rom_00d07a                        XREF[1]:  rom:00d084(j)  
   rom:00d07a a0 90       L        param_1,[ER10]
   rom:00d07c c1 90       ST       param_1,[ER12]
   rom:00d07e 81 ea       ADD      ER10,0x1
   rom:00d080 81 ec       ADD      ER12,0x1
   rom:00d082 00 80       MOV      param_1,param_1
   rom:00d084 fa c8       BC       NE,LAB_rom_00d07a
   rom:00d086 85 f0       MOV      param_1,ER8
   rom:00d088 1e fc       POP      ER12
   rom:00d08a 2e f8       POP      XR8
   rom:00d08c 1f fe       RT                           
```

### 汇编解释
这段代码是用汇编语言编写的，它定义了一个名为`FUN_rom_00d070`的函数，该函数接收两个字符指针参数`param_1`和`param_2`。这个函数的主要目的是将`param_2`指向的字符串复制到`param_1`指向的位置。

首先，函数通过`PUSH`指令将`XR8`和`ER12`寄存器的值压入堆栈，以便在函数结束时恢复它们的值。然后，它将`param_1`的值复制到`ER8`和`ER12`寄存器，将`param_2`的值复制到`ER10`寄存器。

接下来，函数进入一个循环，该循环会持续到遇到字符串`param_2`的结束标志（即值为0的字符）。在每次循环中，它都会执行以下操作：

使用`L`指令从`param_2`指向的当前位置加载一个字符。
使用`ST`指令将该字符存储到`param_1`指向的当前位置。
使用`ADD`指令将`ER10`和`ER12`寄存器的值加1，以便在下一次循环中处理下一个字符。
当遇到`param_2`的结束标志时，循环结束。然后，函数将`ER8`寄存器的值（即`param_1`的原始值）复制回`param_1`，并使用`POP`指令恢复`ER12`和`XR8`寄存器的值。最后，函数通过`RT`指令返回。

总的来说，这个函数实现了字符串的复制操作，类似于C语言中的`strcpy`函数。
### C 语言代码
```c

char * FUN_rom_00d070(char *param_1,char *param_2)

{
  char cVar1;
  char *pcVar2;
  
  pcVar2 = param_1;
  do {
    cVar1 = *param_2;
    *pcVar2 = cVar1;
    param_2 = param_2 + 1;
    pcVar2 = pcVar2 + 1;
  } while (cVar1 != '\0');
  return param_1;
}

```

### C 语言解释
这段代码是用C语言编写的，它定义了一个名为`FUN_rom_00d070`的函数，该函数接受两个字符指针`param_1`和`param_2`作为参数。

函数的主体是一个`do-while`循环，该循环会持续执行，直到遇到`param_2`指向的字符串的结束字符（即空字符'\0'）。

在每次循环中，首先将`param_2`指向的当前字符赋值给变量`cVar1`，然后将`cVar1`的值复制到`param_1`指向的当前位置。然后，`param_2`和`param_1`（通过`pcVar2`）都向前移动一位，以便在下一次循环中处理下一个字符。

这个函数的作用是将`param_2`指向的字符串复制到`param_1`指向的位置。复制完成后，函数返回`param_1`，即复制的字符串的起始地址。

需要注意的是，这个函数没有检查`param_1`指向的空间是否足够大以容纳`param_2`指向的字符串。如果`param_1`指向的空间不够大，这个函数可能会导致缓冲区溢出，这是一种严重的安全问题。在实际编程中，我们应该尽量避免这种情况，例如，可以通过预先知道`param_1`的大小，或者使用安全的字符串复制函数，如`strncpy`。

### ROP 示例
#### 内存注入
ROP字符串：{n-76个数字}<sup>*</sup>  e2 30 31 30 __ __ {2位地址} <0x4c+n<sub>10</sub>><sup>**</sup> d1 30 30 a2 d5 70 d0 30 30 38 1d 32 30 30 30 33 23

\*:  n为an前的字符数，为十进制偶数。例：当n=124时，n-76=48，即前面需要垫48个字符（推荐用1，2，3···0计数）；

\**: 须填十六进制数0x4C+十进制数n。例：当n=124时，4c<sub>16</sub>+124<sub>10</sub>=c8<sub>16</sub>=0xc8.
