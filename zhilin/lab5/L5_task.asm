DATA SEGMENT
    KEEP_CS dw 0
    KEEP_IP dw 0
	MyString db 10, 13, 'TLOU$'
	OutNum dw 0
	EndMessage db 10, 13, 'End int$'
DATA ENDS


AStack SEGMENT STACK
    db 1024 DUP (?)
AStack ENDS


CODE SEGMENT

ASSUME CS:CODE, DS:DATA, SS:AStack

SUBR_INT PROC FAR 
	push ax 
	push cx
	push bx
	push dx
	
	mov cx, OutNum
	str_out:
		cmp cx, 0
		je stop_output
		mov ah, 9
		mov dx, offset MyString
		int 21h
		dec cx
		jmp str_out
	
	stop_output:
	
	mov cx, 0fh
	mov dx, 4240h
	mov ah, 86h
	int 15h
	
	mov ah, 9
	mov dx, offset EndMessage
	int 21h
	
	pop dx
	pop bx 
	pop cx
	pop ax
	mov al, 20h
	out 20h, al
	iret
SUBR_INT ENDP


Main	PROC  FAR
	push DS
	sub AX, AX
	push AX
	mov AX, DATA 
	mov DS, AX
	
	;Task part
	mov ah, 1
	int 21h
	sub al, '0'
	mov OutNum, al
	;

	MOV AH, 35H 
	MOV AL, 60H 
	INT 21H
	MOV KEEP_IP, BX 
	MOV KEEP_CS, ES 
	PUSH DS
	MOV DX, OFFSET SUBR_INT 
	MOV AX, SEG SUBR_INT 
	MOV DS, AX 
	MOV AH, 25H 
	MOV AL, 60H 
	INT 21H
	POP DS

	int 60H

	CLI
	PUSH DS
	MOV DX, KEEP_IP 
	MOV AX, KEEP_CS 
	MOV DS, AX 
	MOV AH, 25H
	MOV AL, 60H 
	INT 21H
	POP DS
	STI
	
	mov ah, 4ch
	int 21h
Main      ENDP
CODE ENDS
	END Main