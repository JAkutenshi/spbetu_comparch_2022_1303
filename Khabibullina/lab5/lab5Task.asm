ASSUME CS:CODE, DS:DATA, SS:STACK

STACK    SEGMENT  STACK
          DW 1024 DUP(?)
STACK    ENDS

DATA SEGMENT
        KEEP_CS DW 0 
        KEEP_IP DW 0 
DATA ENDS

CODE SEGMENT

Timer proc
	push AX
	push DX

	mov DL,':'
	mov AH, 02h
	int 21h

	pop DX
	pop AX	
	ret
Timer endp


TimeOut proc
	push AX
	push DX
	push BX

        aam 
        mov BX, AX
        mov ah, 02h        
        
        mov DL, BH
        add DL, '0'
        int 21h
        
        mov DL, BL
        add DL, '0'
        int 21h
	
	pop BX
	pop DX
	pop AX
	ret
TimeOut endp

SUBR_INT PROC FAR
       	push AX   
	push CX
	push DX
	
	mov ah, 2ch
	int 21h
	
	mov al, ch
	call TimeOut
	call Timer
	mov al, cl
	call TimeOut
	call Timer
	mov al, dh
	call TimeOut
	
	pop DX
	pop CX
	pop AX   


	mov AL, 20H
	out  20H,AL
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
		cmp ah, 20h
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