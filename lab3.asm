AStack SEGMENT STACK
	DW 2 DUP(?)
AStack ENDS

DATA SEGMENT
	a	DW 5
	b	DW 4
	i	DW 1
	k	DW 0
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
		
		; f1: if a>b i1 = 7 - 4*i else i1 = 8 - 6*i
		; f2: if a>b i2 = 20 - 4*i i2 = else 6 - 6*i
		mov ax,i
		shl ax,1
		shl ax,1 ; ax = 4i
		mov bx,ax
		add bx,i
		add bx,i ; bx = 6i
		
		mov cx, a 
		
		cmp cx, b
		jg f_case2 ; a > b
		f_case1:
			; f1
			mov i1,8
			sub i1,bx
			; f2
			mov i2,6
			sub i2,bx
			jmp f_final
		f_case2:
			; f1
			mov i1,7 
			sub i1,ax
			; f2
			mov i2,20
			sub i2,ax
		f_final:
		
			; f3: if k = 0 res = |i1 + i2| else res = min(i1, i2)
			mov ax,i1
			mov bx,i2
			mov res,ax
			
			mov cx,k
			cmp k, 0
			je case2 ; k = 0
			case1: 
				cmp res,bx 
				jbe final
				mov res,bx
				jmp final
			case2:
				add res, bx
				cmp res, 0
				jge final ; res >= 0
				neg res
		final:
			ret
	Main ENDP
CODE ENDS
END Main
