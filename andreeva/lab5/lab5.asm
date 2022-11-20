AStack  SEGMENT STACK
    DB 1024 DUP(?)
AStack  ENDS

DATA    SEGMENT
    KEEP_CS DW 0    
    KEEP_IP DW 0
	MESSAGE DB 'Hello!', 0dh, 0ah, '$'
	END_MES DB 'end', 0dh, 0ah, '$'
DATA    ENDS

CODE    SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:AStack

WriteMsg  PROC  NEAR
          mov AH, 9
          int 21h 
          ret
WriteMsg  ENDP

FUNC PROC FAR
		push ax
		push bx
		push cx
		push dx
		push ds
		
		mov dx, OFFSET MESSAGE
		mov cx, 4
		lp:
			call WriteMsg
			loop lp
			
		mov al, 0
		mov	ah,86h
		xor	cx,cx
		mov	dx,10000
		int	15h
		
		mov dx, OFFSET END_MES
		call WriteMsg 
		
		pop ds
		pop dx
		pop cx
		pop bx
		pop ax
	   	mov al, 20h
	   	out 20h, al
		iret
FUNC ENDP

MAIN PROC FAR
    push ds
	sub ax, ax
	push ax
    mov ax, DATA
    mov ds, ax
    
    mov ah, 35h 
    mov al, 08h 
    int 21h
    mov KEEP_IP, bx 
    mov KEEP_CS, es 
    
    push ds
    mov dx, OFFSET FUNC 
    mov ax, SEG FUNC 
    mov ds, ax 
    mov ah, 25h 
    mov al, 08h 
    int 21h
    pop ds
    
	int 08h

	cli
	push ds
	mov dx, KEEP_IP
	mov ax, KEEP_CS
	mov ds, ax
	mov ah, 25h
	mov al, 08h
	int 21h
	pop ds
	sti
	mov ah, 4ch
	int 21h    
MAIN ENDP
CODE ENDS
     END MAIN
