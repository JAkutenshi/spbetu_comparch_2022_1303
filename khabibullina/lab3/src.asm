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
		
	; f1: if a > b: i1 =  20 - 4 * i  else: i1 = 6 - 6 * i
	; f2: if a > b: i2 = -6 * i - 8  else: i2 = 12 - 3 * i

	mov ax, i
	shl ax, 1 
	add ax, i ; ax = 3 * i

	mov bx, ax
	shl bx, 1 ; bx = 6 * i
		
	mov cx, a 
	cmp cx, b

	jg Go1

	Go2: ; a <= b
		; f1
		mov i1,6
		sub i1, bx ;i1 = 6 - 6 * i

		; f2 
		mov i2,12
		sub i2,ax ;i2 = 12 - 3 * i

		jmp f3

	Go1: ; a > b
		; f1
		mov i1,20
		add ax, i
		sub i1, ax ;i1 =  20 - 4 * i

		; f2
		mov i2, -8
		sub i2,bx ;i2 = -6 * i - 8
		

	f3:
		mov ax,i1
		mov bx,i2
		cmp bx,0
		jge cmp_k
	pos:
		neg bx
	mov res, ax
	cmp_k:
		mov cx, k
		cmp cx, 0
		jl k2 ; k < 0

	k1: ; k >= 0 : res = max(7, |i2|)
		cmp bx, 7
		jg final
		mov res, 7
		jmp final

	k2: ; k < 0 : res = |i1 - i2|
		sub res, bx
		cmp res, 0
		jge final
		neg res

	final:
		ret
	Main ENDP
CODE ENDS
END Main