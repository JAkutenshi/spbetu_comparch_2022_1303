assume cs:code, ds:data, ss:stack

stack  segment stack
    db 1024 dup(0)
stack  ends

data    segment
    keep_cs dw 0    
    keep_ip dw 0
    string db ?,?,?,?,?,?,?,?,0Dh,'$'
    hellostr db "Enter e for time, esc for exit", 0AH, '$'
data    ends

code    segment
Timer PROC
    push dx
    push cx

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
    sub bx, bx

a2:
    pop dx
    add dl, '0'

    int 21h
    ;add bx, 1
    loop a2

    pop cx
    pop dx
    ret
Timer endp

SUBR_INT proc far
    push ax
    push dx
    push cx
    push bx

    mov ah,02h
    int 1Ah
    mov ah, 0 
    mov al, ch
    call Timer
    
    push dx
    mov dx, ':'
    mov ah, 2
    int 21h
    sub ax, ax
    
    mov al, cl
    call Timer
    mov dx, ':'
    mov ah, 2
    int 21h
    sub ax, ax
    
    pop dx
    mov al, dh
    call Timer
    mov ah, 2
    int 21h

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

    jmp enter_key
     
greeting: 

      mov ah, 9
      mov dx, offset hellostr
      int 21h
      sub ax, ax  
     
enter_key:
      mov ah, 7h
      int 21h
      
      cmp  al, 1bh
      je   endprog                  
      cmp  al, 'e'                   
      je  startint
      jmp greeting
     
startint:
      push ds                         
      mov  dx, offset SUBR_INT 
      mov  ax, seg SUBR_INT    
      mov  ds, ax                    
      mov  ah, 25h                    
      mov  al, 16h                    
      int  21h                        
      pop  ds
      int  16h


    endprog:
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