;124an

;Compiled output:
;Key Dump Series:
;C sinh-1 i tanh sinh-1 √ i Arg sinh-1 i Arg <65> tanh √ sinh <65> i Rnd( tanh √ sinh-1 i √ Abs <61> √ i Arg sinh-1 sinh-1 <64> i tanh Rnd( Arg Abs √ i i i i i i i i i i . k 0 1 0 0 <ea> x >a+bi 0 0 0 0 ∟ <03> 2 0
;Hex Dump:
;44 6f 20 6e 6f 74 20 67 6f 20 67 65 6e 74 6c 65 20 69 6e 74 6f 20 74 68 61 74 20 67 6f 6f 64 20 6e 69 67 68 74 20 20 20 20 20 20 20 20 20 20 2e e2 30 31 30 30 ea 48 d2 30 30 30 30 c8 03 32 30
;实际使用时:
; [48bytes数据] k 0 1 0 [2bytes的地址,反向写,如0xea30 => 30 ea, 也就是 0 <ea> ] x >a+bi 0 0 0 0 ∟ <03> 2 0
str:

;这里放入你要拷贝的48bytes数据
    hex 44 6f 20 6e 6f 74 20 67 6f 20 67 65 6e 74 6c 65 20
    hex 69 6e 74 6f 20 74 68 61 74 20 67 6f 6f 64 20 6e 69 
    hex 67 68 74 20 20 20 20 20 20 20 20 20 20 2e
;上面的字符为： Do not go gentle into that good night.

;    hex 4f 6c 64 20 61 67 65 20 73 68 6f 75 6c 64 20 62 75
;    hex 72 6e 20 61 6e 64 20 72 61 76 65 20 61 74 20 63 6c
;    hex 6f 73 65 20 6f 66 20 64 61 79 20 20 20 20
entry:
    pop qr0
    hex 30 ea 48 d2 30 30 30 30  ;0xea30为目标写入的地址，根据需要更改
;    hex ec ea 48 d2 30 30 30 30
    smart_strcpy
