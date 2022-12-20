AStack  segment stack
    dw 512 dup(?)
AStack  ENDS

DATA    segment
    keep_cs dw 0    
    keep_ip dw 0
MESSAGE DB 'here is text!', 0dh, 0ah, '$'
	FLAG    DB 0
DATA    ends

CODE    segment
	ASSUME CS:CODE, DS:DATA, SS:AStack

WriteMsg  PROC  NEAR
          mov AH, 9
          int 21h 
          ret
WriteMsg  ENDP

print_time proc near
        out 70h,al               
        in al,71h               
        push ax
	mov cl, 4
        shr al,cl                
        add al,'0'              
        int 29h                  
        pop ax
        and al,0Fh              
        add al,30h              
        int 29h     
        ret
print_time endp

FUNC proc far
    cmp  FLAG, 0
		jne  func_end
		mov  FLAG, 1
		
		push ax
		push bx
		push cx
		push dx
		push ds
		
		mov dx, OFFSET MESSAGE
		mov cx, 6
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
		
		mov        al, 4                 ; 04h an hour
        	call       print_time
        	mov        al, ':'               
        	int        29h
        	mov        al,2                 ; 02h mins
        	call       print_time
        	mov        al, ':'               
        	int        29h
        	mov        al, 0h                ; 00h seconds
        	call       print_time
		
		pop ds
		pop dx
		pop cx
		pop bx
		pop ax

		func_end:
	   	mov al, 20h
	   	out 20h, al
		iret
FUNC endp

main proc far
    push ds
    sub  ax, ax
    push ax
    mov  ax, DATA
    mov  ds, ax
    
    mov  ah, 35h                    
    mov  al, 16h 
    int  21h 
    mov  keep_ip, bx 
    mov  keep_cs, es

    push ds                         
    mov  dx, offset FUNC 
    mov  ax, seg FUNC    
    mov  ds, ax                    
    mov  ah, 25h                    
    mov  al, 16h                    
    int  21h                        
    pop  ds
    
    check_key:                     
     in   al, 60h                   
     cmp  al, 1Eh                   
     jne  check_key
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

CODE ends
end main