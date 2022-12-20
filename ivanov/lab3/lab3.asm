AStack SEGMENT STACK
	DW 2 DUP(?)
AStack ENDS

; f1: if a > b: i1 =  -4*i - 3  else: i1 = 6*i - 10
; f2: if a > b: i2 = 20 - 4 * i  else: i2 = 6 - 6 * i

DATA SEGMENT
	a	DW 3
	b	DW 4
	k	DW 2
	i	DW 2
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

mov ax,i
shl ax,1
shl ax,1 ; ax = 4i
mov bx,ax
add bx,i
add bx,i ; bx = 6i
		
mov cx, a 
cmp cx, b
jg AgB ; a > b

; a <= b
AleB: 
	; f1 : i1 = 6*i - 10
	mov i1, bx ; i1 = 6*i
	sub i1, 10 ; i1 = 6*i - 10

	; f2 : i2 = 6 - 6*i
	mov i2, 6 ; i2 = 6
	sub i2, bx ; i2 = 6 - 6*i

	jmp f3

; a > b
AgB: 
	; f1 : -4*i - 3
	mov i1, 0 ; i1 = 0
	sub i1, 3 ; il = 0 - 3
	sub i1, ax ; i1 = 0 -3 -4*i = - 4*i - 3

	; f2 : 20 - 4*i
	mov i2, 20 ; i2 = 20 
	sub i2, ax ;i2 = 20 - 4*i

f3:
	mov ax,i1
	mov bx,i2

	cmp bx, 0
	jge cmpK

; i2 = |i2|
i2b0: 
	neg bx 

cmpK:
	mov res, bx
	mov cx, k
	cmp cx, 0
	jl Kl0 ; k < 0

; k >= 0 : res = max(7, |i2|)
Kb0: 
	cmp bx, 7
	jg final
	mov res, 7
	jmp final

; k < 0 : res = |i1| + |i2|
Kl0: 
	cmp ax, 0
	jge i1b0
	neg ax
	
i1b0:
	add res, ax

final:
	ret
Main ENDP
CODE ENDS
END Main