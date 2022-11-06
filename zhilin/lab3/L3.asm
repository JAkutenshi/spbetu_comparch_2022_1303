AStack SEGMENT STACK
DW 32 DUP(0)
AStack ENDS


DATA SEGMENT
a DW 0
b DW 0
i DW 0
k DW 0
i1 DW 0
i2 DW 0
res DW 0
DATA ENDS


CODE SEGMENT
ASSUME CS:CODE, DS:DATA, SS:AStack

Main PROC FAR
	mov ax, DATA
	mov ds, ax
	mov ax, a
	mov dx, i
	cmp ax, b
	jg FIRST ; Переход к FIRST при a > b
	
	sal dx, 1 ; i * 2
	add dx, i ; i * 3
	sal dx, 1 ; i * 6
	mov ax, 8
	sub ax, dx ; 8 - i * 6
	mov i2, ax
	sub dx, 10 ; i * 6 - 10
	mov i1, dx
	jmp SECOND
	
FIRST:
	mov cl, 2
	sal dx, cl ; i * 4
	mov ax, 7
	sub ax, dx ; 7 - i * 4
	mov i2, ax
	add dx, 3 ; i * 4 + 3
	neg dx ; -(i * 4 + 3)
	mov i1, dx
	
SECOND:
	mov ax, k
	cmp ax, 0
	jl THIRD ; Переход к THIRD при k < 0
	mov ax, i2
	ABS1:
		neg ax
		js ABS1
	sub ax, 3
	cmp ax, 4
	jl FOURTH
	mov res, ax
	jmp QUIT
	
THIRD:
	mov ax, i1
	ABS2:
		neg ax
		js ABS2
	mov dx, i2
	ABS3:
		neg dx
		js ABS3
	sub ax, dx
	mov res, ax
	jmp QUIT
	
FOURTH:
	mov res, 4

QUIT:
	int 20h
	
Main ENDP
CODE ENDS
END Main
