; d31b (src var M)

; ea[30] [38] [40] [48] [50] [58]

;110an模式
;编译产物：
;ropstring 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 e2 30 31 30 30 ea 1b d3 30 30 30 30 c8 03 32 30
;按键输入 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 k 0 1 0 0 <ea> <1b> >r∠0 0 0 0 0 ∟ <03> 2 0
space 34
home:
    pop qr0
    hex 30 ea 1b d3 30 30 30 30  ;0xea30为目标写入的地址
    smart_strcpy

;最多一次写入6bytes数据
;
; 4c 4f 56 45 20 59
;(33) 34 3c 34 3f 35 36 32 30 35 39
; [3][4][C][4][F][5][6][2][0][5][9] -> B
; |
; v
; 占位