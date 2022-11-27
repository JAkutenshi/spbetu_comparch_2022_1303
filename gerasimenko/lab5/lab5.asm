ASSUME CS:CODE, DS:DATA, SS:STACK

STACK    SEGMENT  STACK
          DW 1024 DUP(?)
STACK    ENDS

DATA SEGMENT
        KEEP_CS DW 0 ; для хранения сегмента
        KEEP_IP DW 0 ; и смещения вектора прерывания
		NUM DW 0
		MESSAGE DB 2 DUP(?)
DATA ENDS

CODE SEGMENT

OutInt PROC
	push DX
	push CX

    xor     cx, cx ; cx - количество цифр
    mov     bx, 10 ; основание сс. 10 для десятеричной и т.п.
oi2:
    xor     dx,dx
    div     bx ; делим число на основание сс и сохраняем остаток в стеке
    push    dx
    inc     cx; увеличиваем количество цифр в cx
	
    test    ax, ax ; проверка на 0
    jnz     oi2
; Вывод
    mov     ah, 02h
oi3:
    pop     dx
    add     dl, '0' ; перевод цифры в символ
    int     21h
; Повторим ровно столько раз, сколько цифр насчитали.
    loop    oi3 ; пока cx не 0 выполняется переход
    
	POP CX
	POP DX
    ret
 
OutInt endp


SUBR_INT PROC FAR
        JMP start_proc
		save_SP DW 0000h
		save_SS DW 0000h
		INT_STACK DB 40 DUP(0)
start_proc:
    MOV save_SP, SP
	MOV save_SS, SS
	MOV SP, SEG INT_STACK
	MOV SS, SP
	MOV SP, offset start_proc
	PUSH AX    ; сохранение изменяемых регистров
	PUSH CX
	PUSH DX
	
	mov AH, 00H
	int 1AH
	
	mov AX, CX
	call OutInt
	mov AX, DX
	call OutInt
	
	POP  DX
	POP  CX
	POP  AX   ; восстановление регистров
	MOV  SS, save_SS
	MOV  SP, save_SP
	MOV  AL, 20H
	
	OUT  20H,AL
       
	iret
	
SUBR_INT ENDP


Main	PROC  FAR
	push  DS       ;\  Сохранение адреса начала PSP в стеке
	sub   AX,AX    ; > для последующего восстановления по
	push  AX       ;/  команде ret, завершающей процедуру.
	mov   AX,DATA             ; Загрузка сегментного
	mov   DS,AX   


	; Запоминание текущего вектора прерывания
	MOV  AH, 35H   ; функция получения вектора
	MOV  AL, 08H   ; номер вектора
	INT  21H
	MOV  KEEP_IP, BX  ; запоминание смещения
	MOV  KEEP_CS, ES  ; и сегмента
	
	; Установка вектора прерывания
	PUSH DS
	MOV  DX, OFFSET SUBR_INT ; смещение для процедуры в DX
	MOV  AX, SEG SUBR_INT    ; сегмент процедуры
	MOV  DS, AX          ; помещаем в DS
	MOV  AH, 25H         ; функция установки вектора
	MOV  AL, 08H         ; номер вектора
	INT  21H             ; меняем прерывание
	POP  DS

	int 08H; на всякий вывод в консоль отдельно от отладчика

	; Восстановление изначального вектора прерывания (можно закомментить)
	CLI
	PUSH DS
	MOV  DX, KEEP_IP
	MOV  AX, KEEP_CS
	MOV  DS, AX
	MOV  AH, 25H
	MOV  AL, 08H
	INT  21H          ; восстанавливаем вектор
	POP  DS
	STI
	
	MOV AH, 4Ch                          
	INT 21h
Main      ENDP
CODE ENDS
	END Main 
