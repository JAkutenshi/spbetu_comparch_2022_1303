ASSUME CS:CODE, DS:DATA, SS:STACK

STACK    SEGMENT  STACK
          DW 1024 DUP(?)
STACK    ENDS

DATA SEGMENT
        KEEP_CS DW 0 
        KEEP_IP DW 0 
DATA ENDS

CODE SEGMENT

Timer PROC
	push dx
    push cx

    xor cx, cx 
    mov bx, 10 

proc1:
    xor dx, dx
    div bx 
    push dx
    inc cx 

    test ax, ax 
    jnz proc1

    mov ah, 2 

proc2:
    pop dx
    add dl, '0'
    int 21h
    loop proc2 

    pop cx
    pop dx
    ret
Timer endp


SUBR_INT PROC FAR

	JMP start

	save_sp DW 0000h
	save_ss DW 0000h
	INT_STACK DB 40 DUP(0)

start:
    mov save_sp, sp
	mov save_ss, ss
	mov sp, SEG INT_STACK
	mov ss, sp
	mov sp, offset start
	push ax
	push cx
	push dx 
	mov ah, 00h 
	int 1AH
	
	mov ax, cx
	call Timer
	mov ax, dx
	call Timer
	
	pop dx
	pop cx
	pop ax 
	mov ss, save_ss
	mov sp, save_sp

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
		cmp ah, 39h
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