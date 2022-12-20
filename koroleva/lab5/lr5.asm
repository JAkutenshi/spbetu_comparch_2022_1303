DATA SEGMENT
    keep_ip dw 0 ; здесь будет храниться смещение прерывания
    keep_cs dw 0 ; здесь будет храниться сегмент прерывания, которое мы заменим
DATA ENDS

AStack SEGMENT STACK
    DW 1024  DUP(?)
AStack ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:AStack

print_cmos proc near
        out        70h,al               ; послать AL в индексный порт CMOS
        in         al,71h               ; прочитать данные
        push       ax
		mov        cl, 4
        shr        al,cl                ; выделить старшие четыре бита
        add        al,'0'               ; добавить ASCII-код цифры 0
        int        29h                  ; вывести на экран
        pop        ax
        and        al,0Fh               ; выделить младшие четыре бита
        add        al,30h               ; добавить ASCII-код цифры 0
        int        29h                  ; вывести на экран
        ret
print_cmos endp

SUBR_INT PROC FAR
    push ax
	push bx
	push dx
	push cx


	mov        al,4                 ; CMOS 04h - час
	call       print_cmos
	mov        al,':'               
	int        29h
	mov        al,2                 ; CMOS 02h - минута
	call       print_cmos
	mov        al,':'               
	int        29h
	mov        al,0h                ; CMOS 00h - секунда
	call       print_cmos
	mov		   al, 0dh
	int 	   29h
	mov 	   al, 0ah
	int 	   29h


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
    
    ;вызываем таймер, во время которого будет вызвано прерывание автоматически
	
	mov al, 0
	mov cx, 7
	mov dx, 0
	mov ah, 86h
	int 15h
	
    
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