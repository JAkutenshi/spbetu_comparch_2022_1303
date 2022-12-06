DATA SEGMENT
    KEEP_CS dw 0
    KEEP_IP dw 0
	MyString db 10, 13, 'TLOU$'
	OutNum dw 3
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
	
	mov        al,0Bh
    out        70h,al
    in         al,71h
    and        al,11111011b
    out        71h,al
    mov        al,32h
    call       PRINT_FUNC
    mov        al,9
    call       PRINT_FUNC
    mov        al,'-'
    int        29h
    mov        al,8
    call       PRINT_FUNC
    mov        al,'-'
    int        29h
    mov        al,7
    call       PRINT_FUNC
    mov        al,' '
    int        29h
    mov        al,4
    call       PRINT_FUNC
    mov        al,':'
    int        29h
    mov        al,2
    call       PRINT_FUNC
    mov        al,':' 
    int        29h
    mov        al,0h
    call       PRINT_FUNC
	mov		   al, 0dh
	int 	   29h
	mov 	   al, 0ah
	int 	   29h
	
	pop dx
	pop bx 
	pop cx
	pop ax
	mov al, 20h
	out 20h, al
	iret
SUBR_INT ENDP

PRINT_FUNC proc near
        out        70h,al
        in         al,71h
        push       ax
		mov        cl, 4
        shr        al,cl
        add        al,'0'
        int        29h
        pop        ax
        and        al,0Fh
        add        al,30h
        int        29h                  
        ret
PRINT_FUNC endp

Main	PROC  FAR
	push DS
	sub AX, AX
	push AX
	mov AX, DATA 
	mov DS, AX 

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