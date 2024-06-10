
; Instructions:
; pre-compiled hex (for cnx ver c):
; 34 61 31 30 30 ea 2e 2e be 8f 30 30 01 01 d8
; 91 30 30 c2 8f 30 30 1c ec dc 3a 31 30 c2 8f 
; 30 30 40 30 d2 03 32 30 e2 30 31 30 08 01 30 
; ea 30 30 30 30 b2 21 32 30 a8 21 31 30 08 09
; b2 21 32 30 a8 21 31 30 08 11 b2 21 32 30 a8
; 21 31 30 08 19 b2 21 32 30 a8 21 31 30 08 21
; b2 21 32 30 a8 21 31 30 08 29 b2 21 32 30 a8
; 21 31 30 08 31 b2 21 32 30 a8 21 31 30 08 39
; b2 21 32 30 06 87 30 30 a8 21 31 30 0e d9 48
; f7 30 30 34 61 31 30 0e d9 e2 62 d8 91 30 30
; dc 52 32 30 6c d0 30 30 1c 30 4c 9d 30 30 30
; 30 18 63 32 30 c2 8f 30 30 20 ec d8 3a 31 30
; 14 4b 31 30 6c d0 30 30 1c ec 22 8f 30 30 30
; 30 30 30 34 61 31 30 30 d8 40 eb c8 03 32 30
; 72 0d 32 30 20 d8 7a 23 32 30 35 ea 30 30 e0
; ff 20 00 01 00 ff ff
;;;;;;;
; Inject code above (234 bytes) to  0xeb40
; ATTENTION: code contains 00 bytes
;            carefully inject when in real-calculator
;            (cannot simply use strcpy to copy)
;;;;;;;
; Launcher
; 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30
; 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30
; 30 30 30 30 e2 30 31 30 30 d8 40 eb 30 30 30
; 30 c8 03 32 30 72 0d 32 30 20 d8 7a 23 32 30
;;;;;;;
; use 110an
; input launcher
; [calc][=]
;;;;;;;
;
; below is asm
; use python.exe .\asm.py .\xxx.asm 
; to compile if u want

org d830
init_map:
    pop xr0
    hex 30 ea 2e 2e
    memset
    hex 01 01 ;0x0101 ~ 0x0100 ~ 256
    setlr

render:
    ; include process below
    ; 
_render_character:
    pop er2
    adr data 4880
    l er0,[er2]
    pop er2
    hex 40 30 ; 0x40 represent '@'
    st r2,[er0]
_render_map:
    pop qr0
    hex 08 01 30 ea 30 30 30 30 
    smallprint
    pop er0
    hex 08 09
    smallprint
    pop er0
    hex 08 11
    smallprint
    pop er0
    hex 08 19
    smallprint

    pop er0
    hex 08 21
    smallprint
    pop er0
    hex 08 29
    smallprint
    pop er0
    hex 08 31
    smallprint
    pop er0
    hex 08 39
    smallprint

    flush_screen
    pop er0
    adr key
    read_key
    pop xr0
    adr key
    hex e2 62
    setlr
    key_cvt    ; to er0
    pop er8
    hex 1c 30
    sub r0,r8,pop er8
    hex 30 30
    mov r1,0
    ; er0 : [0,3]
    pop er2
    adr const 4880
    load_table
    ; er0 : [1,-1,16,-16]
    mov er2,er0
    pop er8
    adr data 4880
    r0=0,[er8]+=er2,pop xr8 ;自增
    hex 30 30 30 30 
    pop xr0
    hex 30 d8 40 eb
    smart_strcpy
    pop ER14
    hex 20 d8
    jpop qr80
data:
    hex 35 ea  ;character position (me)

key:
    hex 30 30

const:
    hex e0 ff; 0: -16
    hex 20 00; 1: +16
    hex 01 00; 2: +1
    hex ff ff; 3: -1
