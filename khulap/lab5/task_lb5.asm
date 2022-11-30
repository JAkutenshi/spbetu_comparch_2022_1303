AStack SEGMENT STACK
    db 1024 DUP (?)
AStack ENDS

DATA SEGMENT
    KEEP_CS dw 0
    KEEP_IP dw 0
    
    message db 'e -- print time in format hh:mm:ss. Enter -- end dialog and exit. Otherwise -- display instructions to the user.', 0dh, 0ah, '$'
    
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:AStack

Instruction  proc
     mov dx, offset message
     mov ah, 9h
     int 21h 
     ret
Instruction  ENDP

getTime proc
	push dx
	push cx
	xor cx, cx 
	mov bx, 10
	next:
		xor dx,dx
		div bx
		add dl, '0'
		push dx
		inc cx
		cmp ax, 0
		jnz next
		mov ah, 02h
	print:
		pop dx
		int 21h
		loop print
		pop cx
		pop dx
		ret
 
getTime endp

separator proc
    mov dl, ':'
    mov ah, 2h
    int 21h
    ret
separator endp

writeTime proc  
    push dx
    aam 
    add ax, 3030h 
    mov dl, ah
    mov dh, al 
    mov ah, 2h
    int 21h 
    mov dl, dh 
    int 21h
    pop dx
    ret
writeTime endp


SUBR_INT proc far
    	jmp start
	keep_sp DW 0000h
	keep_ss DW 0000h
    	int_stack db 50 dup(0)

    	start:
    		mov keep_sp, sp
		mov keep_ss, ss
	   	mov sp, seg int_stack
		mov ss, sp
		mov sp, offset start
		push ax   
		push cx
		push dx

	    	mov ah, 00h
		int 1ah
		
		mov ax, cx
		call getTime
		mov ax, dx
		call getTime
	
		pop  dx
		pop  cx
		pop  ax 
	    	mov ss, keep_ss
		mov sp, keep_sp
		mov  al, 20h
		
		out 20h, al
		iret
Subr_int endp

Main proc far
    	push ds      
	sub ax, ax  
	push ax  
	mov ax, data 
	mov ds, ax   
	 
	mov ah, 35h 
	mov al, 16h
	int 21h
	mov KEEP_IP, bx
	mov KEEP_CS, es

	check:
        	mov ah, 0
		int 16h
		cmp ah, 12h
		je eKey
		cmp ah, 1ch
		je stop
		cmp ah, 1h
		je stop
		call Instruction
		jnz check

	eKey:
		mov ah, 2ch
		int 21h		

		mov al, ch 
		call writeTime
		call separator

		mov al, cl
		call writeTime
		call separator

		mov al, dh
		call writeTime
		
    	

		int 16h

	cli
	push ds
	mov dx, KEEP_IP
	mov ax, KEEP_CS
	mov ds, ax
	mov ah, 25h
	mov al, 16h
	int 21h
	pop ds
	sti
	jmp stop

	
	stop:
		mov ah, 4ch                          
	    	int 21h
Main endp
code ends
end Main
