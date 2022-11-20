DATA SEGMENT
    keep_ip dw 0 ; здесь будет храниться смещение прерывания
    keep_cs dw 0 ; здесь будет храниться сегмент прерывания, которое мы заменим
    message DB 10,13,'The interraption was called!$' ; 10,13 это перевод строки
DATA ENDS

AStack SEGMENT STACK
    DW 1024  DUP(?)
AStack ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:AStack
 
SUBR_INT PROC FAR
    push ax
	push bx
	push dx
	push cx
    mov ah, 09h
    int 21h

	pop cx
	pop dx
	pop bx
    pop ax
    
    mov al, 20h    ;разрешение обработки прерываний с более низким уровнем
    out 20h, al    
    IRET
SUBR_INT ENDP
  
Main PROC FAR
    push ds
    sub ax, ax
    push ax
    mov ax, DATA
    mov ds, ax
    
    ;сохранение старого прерывания
    MOV AH, 35H 
    MOV AL, 1CH
    INT 21H
    MOV KEEP_IP, BX ; сохраняем смещение старого прерывания
    MOV KEEP_CS, ES ; и сегмент
    
    ;устанавливаем новое прерывание
    PUSH DS
    MOV DX, offset SUBR_INT
    MOV AX, seg SUBR_INT 
    MOV DS, AX 
    MOV AH, 25H
    mov al, 1CH
    INT 21H ; меняем смещение и сегмент прерывания на наши собственные
    POP DS
    
    ;вызываем прерывание
    mov dx, offset message
    int 1CH

    
    ;востанавливаем старое прерывание
    CLI
    PUSH DS
    MOV DX, keep_ip
    MOV AX, keep_cs
    MOV DS, AX
    MOV AH, 25H
    MOV AL, 1CH
    INT 21H
    POP DS
    STI
    
    ret
Main ENDP

CODE ENDS
     END Main