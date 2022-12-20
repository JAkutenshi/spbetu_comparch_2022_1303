assume cs:code, ds:data, ss:stack

stack  segment stack
    db 1024 dup(0)
stack  ends

data    segment
    keep_cs dw 0    
    keep_ip dw 0
data    ends

code    segment

SUBR_INT proc far
    push ax
    push dx
    push cx
    push bx

    mov ah,02h
    int 1Ah
    mov ah, 0 
    mov ax, cx

    mov bx, 16 
    sub cx, cx 
a1:
    sub dx, dx
    div bx 
    push dx
    add cx, 1 
    test ax, ax 
    jnz a1

    mov ah, 2 

a2:
    pop dx
    add dl, '0'
    int 21h
    loop a2

    pop bx
    pop cx
    pop dx
    pop ax
    mov  al, 20h
    out  20h, al

	iret
SUBR_INT endp

main proc far
    push ds
    sub  ax, ax
    push ax
    mov  ax, data
    mov  ds, ax
    
    mov  ah, 35h                    
    mov  al, 16h 
    int  21h 
    mov  keep_ip, bx 
    mov  keep_cs, es

    push ds                         
    mov  dx, offset SUBR_INT 
    mov  ax, seg SUBR_INT    
    mov  ds, ax                    
    mov  ah, 25h                    
    mov  al, 16h                    
    int  21h                        
    pop  ds
    
    enter_key:                     
     in   al, 60h                   
     cmp  al, 12h                   
     jne  enter_key
     int  16h

	cli                             

	push ds
	mov  dx, keep_ip
	mov  ax, keep_cs
	mov  ds, ax
	mov  ah, 25h
	mov  al, 16h
	int  21h                        
	pop  ds

	sti                            

    ret

main endp

code ends
end main