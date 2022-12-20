AStack  segment stack
    dw 512 dup(?)
AStack  ENDS

DATA    segment
    keep_cs dw 0    
    keep_ip dw 0
MESSAGE DB 'here is text!', 0dh, 0ah, '$'
	END_MES DB 'this is the end', 0dh, 0ah, '$'
	FLAG    DB 0
DATA    ends

CODE    segment
	ASSUME CS:CODE, DS:DATA, SS:AStack

WriteMsg  PROC  NEAR
          mov AH, 9
          int 21h 
          ret
WriteMsg  ENDP

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

	mov al, 0
	mov cx, 002Eh 
	mov dx, 0000h
	mov ah, 86h
	int 15h

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