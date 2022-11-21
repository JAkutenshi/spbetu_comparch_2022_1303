AStack SEGMENT STACK
	DW 512 DUP(?)
AStack ENDS

DATA SEGMENT
        KEEP_CS DW 0
        KEEP_IP DW 0
DATA ENDS


CODE SEGMENT
ASSUME CS:CODE, DS:DATA, SS:AStack

IntToStr PROC
   	push AX ; сохранение регистров
   	push DX
   	push BX
   	push CX

   	xor CX, CX ; обнуление CX для хранения кол-ва символов
   	mov BX, 10 ; делитель 10
division:
    xor DX,DX	; обнуление DX
    div BX	; деление AX = (DX, AX)/BX, остаток в DX
    add DL, '0' ; перевод цифры в символ
    push DX	; сохранение остатка на стек 
    inc CX	; увеличить счетчик
    test AX, AX ; проверка AX
    jnz division; если частное не 0, то повторяем
    mov ah, 02h
    
print:
    pop DX	; достать символ из стека CX раз
    int 21h
    loop print	; пока cx != 0 выполнить переход

    pop CX	; вернуть значения со стека
    pop BX
    pop DX
    pop AX
    ret
IntToStr endp

IntToMin PROC
   	push AX ; сохранение регистров
   	push DX
   	push BX
   	push CX
   	
   	mov BX, 10920
   	xor DX, DX
   	div BX	
	push DX
	mov DX, AX
	add DL, '0'
   	mov AH, 02h
   	int 21h
   	
   	mov BX, 1092
   	pop DX
   	mov AX, DX
   	xor DX, DX
   	div BX	
	push DX
	mov DX, AX
	add DL, '0'
   	mov AH, 02h
   	int 21h
   	
   	
   	mov DL,':'
	mov AH, 02h
	int 21h
   	
	mov BX, 180
   	pop DX
   	mov AX, DX
   	xor DX, DX
   	div BX
   	push DX
   	mov DX, AX
   	add DL, '0'
   	mov AH, 02h
   	int 21h
   	
   	mov BX, 18
   	pop DX
   	mov AX, DX
   	xor DX, DX
   	div BX
   	mov DX, AX
   	add DL, '0'
   	mov AH, 02h
   	int 21h
   		

    	pop CX	; вернуть значения со стека
    	pop BX
    	pop DX
    	pop AX
    	ret
IntToMin endp



GetTime PROC FAR
       jmp time
	KEEP_SS DW 0
	KEEP_SP DW 0
	Stack DB 50 dup(" ")
time:
	mov KEEP_SS, SS
	mov KEEP_SP, SP
	mov SP, SEG Stack
	mov SS, SP
	mov SP, offset time

	push AX    ; сохранение изменяемых регистров
	push CX
	push DX
	
	mov AH, 00h	; читать часы (счетчик тиков)
	int 1Ah	; CX,DX = счетчик тиков
	
	mov AX, CX
	call IntToStr
	mov DL,':'
	mov AH, 02h
	int 21h
	mov AX, DX
	call IntToMin
	
	pop DX
	pop CX
	pop AX   ; восстановление регистров

	mov SS, KEEP_SS 
	mov SP, KEEP_SP

	mov AL, 20H
	out  20H,AL
	iret
GetTime ENDP


Main	PROC  FAR
	push DS
	sub AX,AX
	push AX
	mov AX, DATA
	mov DS, AX

	mov AH,35h ; дать вектор прерывания
	mov AL,60h ; номер вектора
	int 21h    ; вызов -> выход: ES:BX = адрес обработчика прерывания
	mov KEEP_IP, BX ; запоминание смещения
	mov KEEP_CS, ES ; запоминание сегмента

	push DS
	mov DX, offset GetTime	; смещение для процедуры
	mov AX, seg GetTime	; сегмент процедуры
	mov DS, AX
	mov AH, 25h 	; функция установки вектора
	mov AL, 60h 	; номер вектора
	int 21h 	; установить вектор прерывания на указанный адрес нового обработчика
	pop DS

	int 60h	; вызов прерывания пользователя
	
	CLI 	; сбрасывает флаг прерывания IF
	push DS
	mov DX, KEEP_IP
	mov AX, KEEP_CS
	mov DS, AX
	mov AH, 25h
	mov AL, 60h
	int 21h
	pop DS
	STI 

	ret
Main ENDP
CODE ENDS
	END Main
