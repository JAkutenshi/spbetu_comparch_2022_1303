AStack SEGMENT STACK
	DW 2 DUP(?)
AStack ENDS

DATA SEGMENT
	a	DW 5
	b	DW 4
	i	DW 1
	k	DW 2
	i1	DW ?
	i2	DW ?
	res	DW ?
DATA ENDS

CODE SEGMENT
	ASSUME CS:CODE, DS:DATA, SS:AStack
	Main PROC FAR

	push DS
	sub ax,ax
	push ax
	mov ax,DATA
	mov DS,ax
		
	; f1: if a > b: i1 =  4 - 6 * i  else: i1 = 2 + 3 * i
	; f2: if a > b: i2 = 20 - 4 * i  else: i2 = 6 - 6 * i

	mov ax, i
	shl ax, 1 
	add ax, i ; ax = 3 * i

	mov bx, ax
	shl bx, 1 ; bx = 6 * i
		
	mov cx, a 
	cmp cx, b

	jg a_greater_b

	a_less_equal_b: ; a <= b
		; f1 : i1 = 2 + 3 * i
		mov i1, 2
		add i1, ax

		; f2 : i2 = 6 - 6 * i
		mov i2, 6
		sub i2, bx

		jmp f3

	a_greater_b: ; a > b
		; f1 : 4 - 6 * i
		mov i1, 4 
		sub i1, bx

		; f2 : 20 - 4 * i
		mov i2, 20
		add ax, i
		sub i2, ax

	f3:
		mov ax,i1
		mov bx,i2

		cmp ax, 0
		jge cmp_k

	pos_i1: ; i1 = |i1|
		neg ax

	mov res, ax

	cmp_k:
		mov cx, k
		cmp cx, 0
		jl neg_k ; k < 0

	pos_k: ; k >= 0 : res = max(6, |i1|)
		cmp ax, 6
		jg final
		mov res, 6
		jmp final

	neg_k: ; k < 0 : res = |i1| + |i2|
		cmp bx, 0
		jge pos_i2
		neg bx
	
	pos_i2:
		add res, bx

	final:
		ret
	Main ENDP
CODE ENDS
END Main