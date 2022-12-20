;	 / 2*(i+1) -4 , при a>b
;f6 = <
;	 \ 5 - 3*(i+1), при a<=b

;	 / - (6*i+8) , при a>b
;f8 = <
;	 \ 9 -3*(i-1), при a<=b

;	 / min(i1,i2), при k=0
;f1 = <
;	 \ max(i1,i2), при k/=0

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

    mov ax, a
    mov cx, i
    cmp ax, b
    jg a_greater

;   a<=b

    sal cx, 1	; i << 1 = i*2
    add cx, i	; i*2 + i = i*3
    neg cx		; -i*3
    add cx, 2	; 2 - i*3 = 5 - 3(i + 1)
    mov i1, cx

    add cx, 8
    mov i2, cx	; 10 - i*3 = 9 - 3*(i - 1)

    jmp F3


a_greater:

    mov ax, 2
    neg ax
    sal cx, 1
    sub ax, cx	; -2 + 2*i = 2*(i + 1) - 4
    mov i1, ax

    mov ax, 8
    neg ax
    add cx, i	 ; i*2 + i = 3*i
    sal cx, 1 	 ; 3i*2
    neg cx 		 ; -6*i
    sub ax, cx	 ; -8 - 6*i = -(6*i + 8)
    mov i2, ax


F3:
    mov ax, k
    cmp ax, 0	;сравниваем k и 0
    JNe K_NOT_ZERO	 ;если k не равно 0, то на K_NOT_ZERO
 
;   если k = 0

    mov ax, i1	;ax = i1
    cmp ax, i2
    JGe MIN	;если i1 >= i2 то на MIN
    mov res, ax	;res = ax = i1
    jmp EXIT

MIN:
    mov res, bx
    jmp EXIT

K_NOT_ZERO:
    mov ax, i1	; ax = i1
    cmp ax, i2
    JGe MAX 	; если i1 >= i2 то на MAX
    mov res, bx		; res = bx = i2
    jmp EXIT

MAX:
	mov res, ax

EXIT:
    int 20h
		  
Main    ENDP
CODE    ENDS
        END Main