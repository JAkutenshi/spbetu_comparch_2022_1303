;task option ¹20
;f1&f2:
;	/ -(6*i - 4) , ïðè a>b
;f4 = <
;	\ 3*(i+2) , ïðè a<=b

;	/ 2*(i+1) -4 , ïðè a>b
;f6 = <
 ;	\ 5 - 3*(i+1), ïðè a<=b

;f3:
;	/ |i1| - |i2|, ïðè k<0
;f8 = <
;	\ max(4,|i2|-3), ïðè k>=0

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

; f1&f2:
    mov ax, a
    mov cx, i
    cmp ax, b
    jg a_greater

;   a<=b

    sal cx, 1	; i << 1 = i*2
    add cx, i	; i*2 + i = i*3
    add cx, 6	;i*3+6 = 3*(i+2)
    mov i1, cx

    neg cx		; -i*3-6
    add cx, 8	; 2 - i*3 = 5 - 3(i + 1)	
    mov i2,cx

    jmp F3


a_greater:
    mov ax, -2
    sal cx, 1
    sub ax, cx	; -2 + 2*i = 2*(i + 1) - 4
    mov i1, ax

    mov ax, 4
    add cx, i	 ; i*2 + i = 3*i
    sal cx, 1 	 ; 3i*2
    neg cx 		 ; -6*i
    sub ax, cx	 ; 4 - 6*i = -(6i-4)
    mov i2, ax


F3:
    mov ax,i1
    mov bx,i2
    cmp ax, 0
    jge cmp_k

pos_i2: ; 		i2 = |i2|
    neg ax
    mov res, ax

cmp_k:
         mov cx, k
         cmp cx, 0
         jl neg_k ; k < 0

pos_k: ; k >= 0
        mov bx, -3
        sub ax,bx
        mov res, ax
        cmp ax, bx
        jg final
        mov res, 4
        jmp final

    neg_k: ; k < 0
         cmp bx, 0
         jge case3
         neg bx
	
    case3:
         sub res, bx

    final:
        ret
		  
Main    ENDP
CODE    ENDS
        END Main
