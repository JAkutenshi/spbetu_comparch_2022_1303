AStack SEGMENT STACK
	DW 512 DUP(?)
AStack ENDS

DATA SEGMENT
        temp_cs DW 0
        temp_ip DW 0
DATA ENDS

CODE SEGMENT
ASSUME CS:CODE, DS:DATA, SS:AStack

int_to_string PROC
   	push AX 
   	push DX
   	push BX
   	push CX
   	xor CX, CX 
   	mov BX, 10
divide:
    xor DX,DX	
    div BX	
    add DL, '0' 
    push DX	
    inc CX	
    test AX, AX 
    jnz divide
    mov ah, 02h
    
console_log:
    pop DX	
    int 21h
    loop console_log	
    pop CX
    pop BX
    pop DX
    pop AX
    ret
int_to_string endp

get_time PROC FAR
       jmp time
	temp_ss DW 0
	temp_sp DW 0
	Stack DB 50 dup(" ")
time:
	mov temp_ss, SS
	mov temp_sp, SP
	mov SP, SEG Stack
	mov SS, SP
	mov SP, offset time
	push AX
	push CX
	push DX
	mov AH, 00h	
	int 1Ah	
	mov AX, CX
	call int_to_string
	mov AX, DX
	call int_to_string
	pop DX
	pop CX
	pop AX   
	mov SS, temp_ss 
	mov SP, temp_sp
	mov AL, 20H
	out  20H,AL
	iret
get_time ENDP

Main	PROC  FAR
	push DS
	sub AX,AX
	push AX
	mov AX, DATA
	mov DS, AX
	mov AH,35h 
	mov AL,60h 
	int 21h    
	mov temp_ip, BX 
	mov temp_cs, ES 
	push DS
	mov DX, offset get_time	
	mov AX, seg get_time	
	mov DS, AX
	mov AH, 25h 	
	mov AL, 60h 	
	int 21h 	
	pop DS
	int 60h	
	CLI 	
	push DS
	mov DX, temp_ip
	mov AX, temp_cs
	mov DS, AX
	mov AH, 25h
	mov AL, 60h
	int 21h
	pop DS
	STI 
	ret
Main ENDP
CODE ENDS
	END Main