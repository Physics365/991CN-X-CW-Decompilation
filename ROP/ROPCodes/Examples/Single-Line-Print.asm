;
; 名称: 单行拼字
; 模式: 110an
;


; 汇编器编译产物：
; rop string(模拟器复现):
; 6c 6f 76 65 20 79 6f 75 20 20 20 20 20 20 20 20 20 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 fe 20 32 30
; 参考按键输入:
;sinh sinh-1 ∛ <65> i tan sinh-1 ln i i i i i i i i i 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 [SHIFT+8 下 2 6 符号] 2 0

hex 6c 6f 76 65 20 79 6f 75 ; `love you`
hex 20 20 20 20 20 20 20 20 20 ; ' '*9
space 17
; total 34 bytes above

line_print_col0 
;注意，这个符号可以用 SHIFT+8 下 2 6 打出