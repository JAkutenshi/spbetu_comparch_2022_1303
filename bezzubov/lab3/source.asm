ASSUME CS:CODE, SS: AStack, DS: DATA

AStack  SEGMENT STACK
        DW 12 DUP('!')
AStack  ENDS


DATA    SEGMENT

a   DW  0
b   DW  0
i   DW  0
k   DW  0

i1  DW  0
i2  DW  0
res DW  0

DATA    ENDS


CODE    SEGMENT

Main    PROC    FAR
    
    push DS
    sub AX,AX
    push AX

    mov AX, DATA
    mov DS, AX

    ;Вычисление f1 и f2

    mov AX, a
    mov CX, i
    cmp AX, b
    jg A_Greater

    sal CX, 1 ; i<<1 = i*2
    add CX, i ; i*2+i = i*3
    add CX, 4 ; i*3 + 4
    mov i1, CX

    ; mov CX, i
    ; add CX, 2 ;i+2
    ; mov AX, CX ;помещаем i+2 в ax
    ; sal CX, 1 ; (i+2)*2
    ; add CX, AX ; (i+2)*2 + (i+2)
    add CX, 2
    mov i2, CX

    jmp FUNCTION_3


A_Greater:

    mov AX, 15
    sal CX, 1
    sub AX, CX
    mov i1, AX

    ; mov CX, i
    mov AX, 4
    ; sal CX, 1 ;i*2
    add CX, i ;i*2 + i = 3i
    sal CX, 1 ; 3i*2
    sub AX, CX
    mov i2, AX


FUNCTION_3:

    mov AX, k
    cmp AX, 0
    JNe K_NOT_EQUAL_ZERO

    mov AX, i1
    add AX, i2
    cmp AX, 0
    jl SUM_LESS_ZERO
    mov res, AX
    jmp QUIT

SUM_LESS_ZERO:

    neg AX
    mov res, AX
    jmp QUIT

K_NOT_EQUAL_ZERO:

    mov AX, i1
    mov CX, i2
    cmp AX, i2
    jl  i1_LESS_i2
    mov res, CX
    jmp QUIT

i1_LESS_i2:

    mov res, AX

QUIT:

    int 20h
		  
Main    ENDP
CODE    ENDS
        END Main
