ASSUME CS:CODE, SS:AStack, DS:DATA

AStack	SEGMENT STACK
	DW 32 DUP(0)
AStack	ENDS


DATA	SEGMENT

a DW ?
b DW ?
k DW ?      ;f2
i DW ?      ;f3
i1 DW ?     ;f8
i2 DW ?
res DW ?

DATA	ENDS

CODE SEGMENT

Main PROC FAR
	push ds
	sub ax, ax
	push ax

	mov ax, DATA
	mov ds, ax

	mov ax, a
	mov bx, i
	cmp ax, b
	jle A1         ; a <= b, go to A1

	mov cl, 2     ; a > b
	shl bx, cl    ; 4 * i
	neg bx        ; -4 * i
	sub bx, 3     ; -4 * i - 3 = -(4i + 3)
	mov i1, bx    ; result of f2

	add bx, 10    ; 7 - 4 * i
	mov i2, bx    ; result of f3
	jmp C2

A1:                   ; a <= b
	shl bx, 1     ; 2i
	add bx, i     ; 3i
	shl bx, 1     ; 6i
	sub bx, 10    ; 6i - 10
	mov i1, bx    ; result of f2

	add bx, 2     ; 6i - 8
	neg bx        ; 8 - 6i
	mov i2, bx    ; result of f3

C2:
	cmp i2, 0
	jge B1        ; i2 >= 0, go to B1

	neg bx        ; i2
B1:
	mov ax, k
	cmp ax, 0
	jge B2        ; k >= 0, go to B2

	mov cx, i1
	cmp cx, 0
	jge C1	      ; i1 >= 0, go to C1

	neg cx        ; i1

C1:
	sub cx, bx    ; i1 - i2
	mov res, cx   ; res = cx
	jmp Exit

B2:
	sub bx, 3     ; |i2| - 3
	cmp bx, 4
	jg B3         ; |i2| - 3 > 4

	mov res, 4    ; res = 4
	jmp Exit

B3:
	mov res, bx   ; res = |i2| - 3

Exit:
	int 20h

Main	ENDP
CODE	ENDS
	END Main	