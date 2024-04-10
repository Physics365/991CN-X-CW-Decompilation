
;110an
;打印0xea30开始的17*3个字符

space 34

entry:
    pop qr0
    hex 20 20 30 ea 30 30 30 30 ;0xea30根据需要修改
    printline
    printline
    line_print_col0 ;总共print3行 17*3=51bytes