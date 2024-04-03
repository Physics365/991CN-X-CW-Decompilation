; loop test
;


;效果:
; 1. 显示 love you
; 2. 等待按键按下(SHIFT 键)
; 3. 显示 forever
; 4. 等待按键按下(SHIFT)
; 回到1,循环

;mode 124an
;编译产物:
;rpostring: 6c 6f 76 65 20 79 6f 75 30 30 30 30 30 30 30 30 e2 30 31 30 20 20 80 d1 30 30 30 30 ae 21 32 30 c4 21 32 30 e2 30 31 30 20 20 74 d5 30 30 30 30 ae 21 32 30 c4 21 32 30 e2 30 31 30 22 d5 80 d1 30 30 30 30 c8 03 32 30 72 0d 32 30 22 d5 7a 23 32 30 46 6f 72 20 65 76 65 72
;实机运行效果见知乎视频

hex 6c 6f 76 65 20 79 6f 75 ; `love you`
space 8
;space 16
home:
    pop qr0
    hex 20 20 80 d1 30 30 30 30 
    ;remember, we do not use label here to represent `love you`
    ;since, stacks will be filled and broke by other functions
    ;we use 0xd180 (input area rather than stack area)
    printline
    waitkey
    pop qr0
    ; 74 d5
    hex 20 20 
    adr label2
    hex 30 30 30 30
    printline
    waitkey
    pop qr0
    hex 22 d5 80 d1 30 30 30 30 
    smart_strcpy
    pop ER14
    adr home -16
    jpop qr80   ;jump and pop qr8,pop qr0
label2:
    hex 46 6f 72 20 65 76 65 72  ; `Forever`
    ; here, since it locates at the end of stack
    ; we do not care 