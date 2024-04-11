
;mode 124an
;total: 76bytes
;前提：持久化字符串到0xea30开始的地址
;注意！！！！完成rop后！！不能！！按[CALC]!!!

;参考按键:
;0 0 0 0 0 0 0 0 0 in>cm 0 0 <ea> 0 0 0 0 |C e 2 0 ! <91> 0 0 <1a> <9a> 0 0 sinh ) 0 0 <54> >a+bi 兀 Rep 0 0 0 0 0 0 <c4> e 2 0 k 0 1 0  兀 square x >a+bi 0 0 0 0 ∟ <03> 2 0 e^ <0d> 2 0 <24> square sin-1 : 2 0
;一共9个左右不可见字符，推荐使用:
;xxxxx->x
;x in>cm:
;x:
;x in>cm:
; @=xxx
;方法刷，详情参考知乎 https://zhuanlan.zhihu.com/p/620584634
data:
    space 9
    hex fe      ;注意！！！编译器会给出<fe>字符，但是真机打的时候，连着下面一个字节一起，打in>cm
loop:
    hex 01 30 ; 01:第0行
y:
    hex 30 ea ;起始地址
    hex 30 30 30 30 ;占位
    printline
    
    
    setlr ;setlr后才能使用以RT结尾的label
    ;自增
    mov er2,1
    pop er8
    adr y -730 ;这里-730是为了算出相对0xd248的偏移(不能直接d522)
    r0=0,[er8]+=er2,pop xr8 ;自增
    hex 30 30 30 30 ;for xr8
    waitkey
    ;34+14=48above
; 程序主入口:
start:
    pop qr0
    hex 22 d5 48 d2 30 30 30 30 
    smart_strcpy
    pop ER14
    adr loop -8
    jpop qr80   ;jump and pop qr8,pop qr0
