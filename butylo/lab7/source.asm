AStack  SEGMENT STACK
	DB 1024 DUP(?)
AStack  ENDS

START_REG EQU -17h

DATA    SEGMENT
	HEX_NAME DB 'HEX_STR: ', '$'
	DEC_NAME DB 'DEC_STR: ', '$'
	DEC_STR DB ' ','$'
	HEX_STR DB ' ', '$'
DATA    ENDS

CODE    SEGMENT
	ASSUME CS:CODE, DS:DATA, SS:AStack

WriteMsg  PROC  NEAR
	mov AH, 9
	int 21h 
	ret
WriteMsg  ENDP

CAST_TO_DEC   proc 
pop cx
pop di
pop ax

push    bx
push    cx
push    dx

mov     bx,     10      
xor     cx,     cx      
or      ax,     ax      
jns     div1
	neg     ax    
	push    ax     
	mov     dl,     '-'
	mov [di], dl
	inc di
	pop     ax
div1:                  
xor     dx,     dx
div     bx
push    dx      
inc     cx      
or      ax,     ax
jnz     div1           
sto:
pop     dx      
add     dl,     '0'     
		mov [di], dl
inc di
loop    sto
    
    	mov dl, '$'
    	mov [di], dl
    	inc di
    
    	pop     dx
    	pop     cx
    	pop     bx

    	push cx
    	ret
CAST_TO_DEC       endp

GO_TO_REG proc
	pop cx
	pop dx
    
	push cx
	push si
	push di

	mov si, OFFSET DEC_STR
	cmp byte ptr [si], "-" 
	jnz l1
	mov di, 1
	inc si
	l1:
        	xor ax, ax
        	mov bx, 10
	l2:
        	mov cl, [si]
        	cmp cl, '$'
        	jz endin

        	sub cl, '0'
        	mul bx
        	add ax, cx
        	inc si
        	jmp l2
	endin:
        	cmp di, 1
        	jnz l3
        	neg ax
l3:    

pop di
        	pop si
        	pop cx

        	push ax
        	push cx

ret
GO_TO_REG endp

CAST_TO_HEX proc 
pop cx
pop di
pop ax 

push    cx
push    dx
	
mov    cl,      ((16-1)/4)*4    
xchg   dx,      ax              
 
Repeat:
 
mov    ax,      dx              
shr    ax,      cl              
and    al,      0Fh             
add    al,      '0'            
cmp    al,      '9'             
jbe    Digit               
add    al,      'A'-('9'+1)     
 
Digit:
push dx
	mov dl , al
	mov [di], dl
	inc di
	pop dx
     	sub    cl, 4               
     	jnc    Repeat                 
        
     	mov dl, '$'
     	mov [di], dl
     	inc di
        
pop     dx

ret
CAST_TO_HEX endp

Main PROC FAR
	push ds
	sub ax,ax
	push ax
	mov ax, DATA
	mov ds, ax
	

	mov ax, START_REG
	push ax
	mov di, OFFSET DEC_STR
	push di
	call CAST_TO_DEC
	
	mov dx, OFFSET DEC_NAME
	call WriteMsg
	mov dx, OFFSET DEC_STR
	call WriteMsg	

	push dx
	push ax
	mov ah,2
	mov dl, 10
	int 21h
	pop ax
	pop dx

	mov dx, OFFSET DEC_STR
	push dx
	call GO_TO_REG

	mov di, OFFSET HEX_STR
	push di
	call CAST_TO_HEX
	
	mov dx, OFFSET HEX_NAME
	call WriteMsg
	mov dx, OFFSET HEX_STR
	call WriteMsg
	
	ret
Main ENDP
CODE ENDS
END Main
