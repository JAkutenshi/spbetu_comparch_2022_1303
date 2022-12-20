AStack  SEGMENT STACK
    DB 1024 DUP(?)
AStack  ENDS

DATA    SEGMENT
    KEEP_CS DW 0    ; для хранения сегмента вектора прерывания
    KEEP_IP DW 0    ; для смещения вектора прерывания
    COUNTER DB 0
    MESSAGE DB 'MESSAGE', 0dh, 0ah, '$'
    ENDING DB 'END', '$'
	TIME DB '00:00:00:00', 0dh, 0ah ,'$'
DATA    ENDS

CODE    SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:AStack

WriteMsg  PROC  NEAR
          mov ah, 9
          int 21h 
          ret
WriteMsg  ENDP


MAKE_TIME  PROC  NEAR
	sub ax,ax
	mov al,bh
	mov bl,0Ah
	div bl
	
	mov di, OFFSET TIME
	add al,'0'
	add di,dx
	mov [di],al
	add ah,'0'
	mov [di+1],ah
	add dx,3
	ret
MAKE_TIME ENDP


PRINT_TIME PROC NEAR
	mov ah, 02ch
	int 21h
	push dx
	
	sub bx,bx
	sub dx,dx
	
	mov bh,ch
	call MAKE_TIME
	mov bh,cl
	call MAKE_TIME
	pop cx
	mov bh,ch
	call MAKE_TIME
	mov bh,cl
	call MAKE_TIME
		
	mov dx, OFFSET TIME
	call WriteMsg
	ret
PRINT_TIME ENDP
	
	
FUNC PROC FAR
	push ax
	push bx
	push cx
	push dx
	push ds
	push di
	
	call PRINT_TIME
	
	mov cx, 00FEh 
	mov dx, 0000h
	mov ah, 86h
	int 15h
	
	call PRINT_TIME
	
	pop di
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
    mov ax, DATA
    mov ds, ax
    
    mov ah, 35h ; функция получения вектора
    mov al, 23h ; номер вектора
    int 21h
    mov KEEP_IP, bx ; запоминание смещения
    mov KEEP_CS, es ; и сегмента вектора прерывания
    
    push ds
    mov dx, OFFSET FUNC ; смещение для процедуры в DX
    mov ax, SEG FUNC ; сегмент процедуры
    mov ds, ax ; помещаем в DS
    mov ah, 25h ; функция установки вектора
    mov al, 23h ; номер вектора
    int 21h ; меняем прерывание
    pop ds
    
    mov ah, 01h
    int 21h
    ;int 23
    
	cli
	push ds
	mov dx, KEEP_IP
	mov ax, KEEP_CS
	mov ds, ax
	mov ah, 25h
	mov al, 23h
	int 21h ; восстанавливаем старый вектор прерывания
	pop ds
	sti
	mov ah, 4ch
	int 21h 
MAIN ENDP
CODE ENDS
     END MAIN
