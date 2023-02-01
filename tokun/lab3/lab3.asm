AStack SEGMENT STACK
		DW 12 DUP(?)
AStack ENDS

DATA SEGMENT
	a DW 1
	b DW 2
	i DW 3
	k DW 4
	i1 DW 0
	i2 DW 0
	result DW 0
DATA ENDS

CODE SEGMENT
	ASSUME CS:CODE, DS:DATA, SS:AStack
	
Main    PROC FAR
    	push ds
    	push ax
	mov ax, DATA
	mov ds, ax
function2:
    	mov ax, a
	mov bx, i
	shl bx, 1
	mov cx, i
	add cx, bx
	cmp ax, b
	jg greater1
greater2:
    	mov bx,cx
	add cx, 6
	shl bx, 1
	sub bx, 10
	jmp function2_end
greater1:
    	shl bx, 1
    	neg bx
    	sub bx, 3
	shl cx, 1
	neg cx
	add cx, 4
function2_end:
	mov i1, bx
	mov i2, cx
	mov ax, i1
	cmp ax, 0
    	jge function3
	neg ax
function3:
	cmp k, 0
	jge positive_k
negative_k:
	mov bx, i2
	cmp bx, 0
    	jge positive_i
	neg bx
positive_i:
	add ax, bx
	jmp function3_end
positive_k:
	cmp ax, 6
	jge function3_end
	mov ax, 6
function3_end:
	mov result, ax
	ret
Main    ENDP
CODE    ENDS
	END Main
