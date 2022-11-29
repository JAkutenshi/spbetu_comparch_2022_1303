DATA SEGMENT
    KEEP_CS dw 0
    KEEP_IP dw 0
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
	
	; getting time 
	mov ah, 02h
	int 1Ah
	
	sub bx, bx
	
	; printing time 
	mov bx, cx
	shr bx, 1
	shr bx, 1
	shr bx, 1
	shr bx, 1
	and bx, 0F0Fh
	and cx, 0F0Fh
	add bx, 3030h
	add cx, 3030h
	
	mov dl, bh
	int 21h
	mov dl, ch
	int 21h
	mov dl, ':'
	int 21h
	mov dl, bl
	int 21h
	mov dl, cl 
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
	sub AX,AX
	push AX
	mov AX,DATA 
	mov DS,AX 


	MOV AH, 35H 
	MOV AL, 16H 
	INT 21H
	MOV KEEP_IP, BX 
	MOV KEEP_CS, ES 
	
	try:
        	mov ah, 0
		int 16h
		cmp ah, 12h
		jnz try


	PUSH DS
	MOV DX, OFFSET SUBR_INT 
	MOV AX, SEG SUBR_INT 
	MOV DS, AX 
	MOV AH, 25H 
	MOV AL, 16H 
	INT 21H 
	POP DS

	int 16H 


	CLI
	PUSH DS
	MOV DX, KEEP_IP 
	MOV AX, KEEP_CS 
	MOV DS, AX 
	MOV AH, 25H 
	MOV AL, 16H 
	INT 21H
	POP DS
	STI
	
	MOV AH, 4Ch                          
	INT 21h
Main      ENDP
CODE ENDS
	END Main 
