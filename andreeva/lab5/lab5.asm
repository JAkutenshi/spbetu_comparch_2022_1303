AStack  SEGMENT STACK
    DB 1024 DUP(?)
AStack  ENDS

DATA    SEGMENT
    KEEP_CS DW 0    
    KEEP_IP DW 0
	MESSAGE DB 'Hello!', 0dh, 0ah, '$'
	END_MES DB 'end', 0dh, 0ah, '$'
	FLAG    DB 0
DATA    ENDS

CODE    SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:AStack

WriteMsg  PROC  NEAR
          mov AH, 9
          int 21h 
          ret
WriteMsg  ENDP

FUNC PROC FAR
		cmp  FLAG, 0
		jne  func_end
		mov  FLAG, 1
		
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
			
		xor  cx, cx
		mov  cx, 20
		update_dx:
		mov  dx, 0ffffh
		wait_loop:
		nop
		dec  dx
		cmp  dx, 0
		jne  wait_loop
		loop update_dx
		
		mov dx, OFFSET END_MES
		call WriteMsg 
		
		pop ds
		pop dx
		pop cx
		pop bx
		pop ax
		func_end:
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
    
	mov al, 0
	mov cx, 002Eh 
	mov dx, 0000h
	mov ah, 86h
	int 15h

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
