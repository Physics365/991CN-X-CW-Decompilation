;
; 名称: 双行拼字
; 模式: 110an
; 执行操作:([CALC], [=]) (直接[=]也行，但是视觉效果不好)
;

; 汇编器编译产物：
; rop string(模拟器复现):
; 6c 6f 76 65 20 79 6f 75 20 20 20 20 20 20 20 20 20 46 6f 72 20 65 76 65 72 20 20 20 20 20 20 20 20 20 a8 21 21 fe 11 30 ae 21 32 30 fe 20 32 30
; 参考按键输入:
;sinh sinh-1 ∛ <65> i tan sinh-1 ln i i i i i i i i i E sinh-1 e^ i <65> ∛ <65> e^ i i i i i i i i i * e e pc>km 0 |C(排列组合里的C) e 2 0 [SHIFT8 下 2 6 符号] 2 0
hex 6c 6f 76 65 20 79 6f 75 20 20 20 20 20 20 20 20 20; `love you`
hex 46 6f 72 20 65 76 65 72 20 20 20 20 20 20 20 20 20; `Forever `

; total 34 bytes above

hex a8 21 21  ; pop er0 前3字节

hex FE 11   ; (这里FE 与上面三字节补全pop er0 的 gadget)
; ^^^^^pc>km (单位换算里面有)
; 11字符表示距顶部17个像素(约等于1行)
hex 30  ;占位(er0)

printline
line_print_col0 
;注意，这个符号可以用 SHIFT+8 下 2 6 打出


