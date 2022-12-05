AStack  SEGMENT STACK
    DB 1024 DUP(?)
AStack  ENDS

DATA    SEGMENT
	DECIM DB 'Decimal number = ', '$'
	OCT DB 'Octal number = ', '$'
	NUM_STR DB ' ', 0ah, '$'
    DEC_STR DB ' ', '$'
    OCT_STR DB ' ', '$'
    SIGN DB '  ', '$'
	NUMBER DW 01Ah
DATA    ENDS

CODE    SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:AStack
    

WriteMsg  PROC  NEAR
          mov AH, 9
          int 21h 
          ret
WriteMsg  ENDP


DIGITS_PROC PROC NEAR
	push bx
	push dx
	push cx
	cmp cx,0
	je digits_end
	
	mov bx,0Ah
	digits_processing:
		xor dx,dx
		mul bx
		sub cx,1
		cmp cx,0
		jne digits_processing
	
	digits_end:
	pop cx
	pop dx
	pop bx
	ret
DIGITS_PROC ENDP


REVERSE PROC NEAR ; переворачиваем строку с числом
	pop cx
	
	pop di  ;в di строка
	pop bx
	
	push cx
	
	xor ax,ax
	reverse_processing:
   		push bx
   		mov bx,ax
   		mov cx,[di+bx]
   		pop bx
   		mov dx,[di+bx]
   		
   		push bx
   		mov bx,ax
   		mov [di+bx],dx
   		pop bx
   		mov [di+bx],cx
   		
   		add ax,2
   		sub bx,2
   		cmp ax,bx
   		jl reverse_processing
	ret
REVERSE ENDP


NUM_TO_STR_10 PROC NEAR
	pop cx
	
	pop di  ;строка в di
	pop ax
	
	push cx
	push bx
	
	mov cx,0Ah
	mov bx,0
	processing:
   		xor dx,dx
   		div cx
   		add dx,'0'
   		mov [di+bx],dx
		add bx,2
   		cmp ax,0
   		jne processing
   	mov dx,'$'
   	mov [di+bx],dx
	sub bx,2
	
	pop ax
	pop cx
	
	push bx ;длина строки
	
	push cx
	ret
NUM_TO_STR_10 ENDP


STR_10_TO_NUM PROC NEAR
	pop cx
	
	pop di  ; строка
	pop bx
	
	push cx
	push ax
	
	xor dx,dx
   	mov cx,0
   	str_processing:
   		mov ax,[di+bx]
   		sub ax,'0'
   		call digits_proc
   		add dx,ax
   		inc cx
   		sub bx,2
   		cmp bx,0
   		jnl str_processing
   		
   	pop ax
	pop cx
	
	push dx ;нужное число
	
	push cx
	ret
STR_10_TO_NUM ENDP


NUM_TO_STR_8 PROC NEAR
	pop cx
	
	pop di  
	pop dx
	
	push cx
	push ax

	sub bx,bx
   	mov ax,dx
   	mov cx, 08h
   	oct_processing:
   		sub dx,dx
   		div cx
   		add dx,'0'
   		mov [di+bx],dx
   		add bx,2
   		cmp ax,0
   		jne oct_processing
   	mov cx,'$'
   	mov [di+bx],cx
   	sub bx,2
   	
   	pop ax
	pop cx
	
	push bx ;длина строки
	
	push cx
   	
	ret
NUM_TO_STR_8 ENDP


MAIN PROC FAR
    push ds
    sub ax,ax
    push ax
    mov ax, DATA
    mov ds, ax
    
   	mov dx,offset decim
   	call writemsg
        
	mov ax, number
   	mov di,offset sign
   	mov bx,'+'
   	cmp ax,0
   	jnl set_sign
	mov bx,'-'
	neg ax
   	
   	set_sign:
		push bx
		mov [di],bx
   	
   	push ax
   	mov dx,offset sign
   	call writemsg
   	pop ax
   	
   	mov di,offset dec_str
   	push ax   
   	push di ; кладем аргументы для функции на стек
   	call num_to_str_10
   	pop bx
   	
   	push bx ; кладем длину строки на стек ----
   	
   	mov di,offset dec_str
   	push bx ; на стек длина строки, чтобы использовать в функции
   	push di 
   	call reverse
   	
   	
   	mov dx,offset dec_str
   	call writemsg
   	mov dx,offset num_str
   	call writemsg
   	
   	pop bx ; достаем длину строки со стека ----
   	
   	mov di,offset dec_str
   	push bx
   	push di
   	call str_10_to_num
   	pop dx ;получил регистр
   	
   	
   	pop bx
   	cmp bx,'-'
   	jne skip
   	neg dx
	
   	skip:
	
   	mov di,offset oct_str
   	push dx
   	push di
   	call num_to_str_8
   	pop bx
   	
   	push bx 
   	push di 
   	call reverse
   	
   	mov dx,offset oct
   	call writemsg
   	mov dx,offset oct_str
   	call writemsg
   	
	ret
MAIN ENDP
CODE ENDS
     END MAIN
