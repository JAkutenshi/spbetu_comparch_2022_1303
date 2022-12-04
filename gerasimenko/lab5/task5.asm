AStack SEGMENT STACK
	DW 512 DUP(?)
AStack ENDS

DATA SEGMENT
        KEEP_CS DW 0
        KEEP_IP DW 0
        FLAG    DB 0
DATA ENDS
	

CODE SEGMENT
ASSUME CS:CODE, DS:DATA, SS:AStack


  Text PROC
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
    loop a2

    pop cx
    pop dx
    ret
Text endp

GetTime PROC FAR

	cmp  FLAG, 0
	jne  func_end
	mov  FLAG, 1
	

    push ax
    push dx
    push cx
    push bx

    mov ah,02h
    int 1Ah
    mov ah, 0 
    mov al, ch
    call Text
    
    push dx
    mov dx, ':'
    mov ah, 2
    int 21h
    sub ax, ax
    
    mov al, cl
    call Text
    mov dx, ':'
    mov ah, 2
    int 21h
    sub ax, ax
    
    pop dx
    mov al, dh
    call Text
    mov ah, 2
    int 21h

    pop bx
    pop cx
    pop dx
    pop ax
	func_end:
	   	mov al, 20h
	   	out 20h, al
		iret
GetTime ENDP


Main	PROC  FAR 
	push DS
	sub AX,AX
	push AX
	mov AX, DATA
	mov DS, AX
	
	
	mov AH,35h ; дать вектор прерывания
	mov AL,08h ; номер вектора
	int 21h    ; вызов -> выход: ES:BX = адрес обработчика прерывания
	mov KEEP_IP, BX ; запоминание смещения
	mov KEEP_CS, ES ; запоминание сегмента
	

	
	
	push DS
	mov DX, offset GetTime	; смещение для процедуры
	mov AX, seg GetTime	; сегмент процедуры
	mov DS, AX
	mov AH, 25h 	; функция установки вектора
	mov AL, 08h 	; номер вектора
	int 21h 	; установить вектор прерывания на указанный адрес нового обработчика
	pop DS
	
	

	mov al, 0
	mov cx, 002Eh 
	mov dx, 0000h
	mov ah, 86h
	int 15h

	CLI 	; сбрасывает флаг прерывания IF
	push DS
	mov DX, KEEP_IP
	mov AX, KEEP_CS
	mov DS, AX
	mov AH, 25h
	mov AL, 08h
	
	int 21h
	STI 
	
	mov ah, 4ch
	int 21h 


Main ENDP
CODE ENDS
	END Main
