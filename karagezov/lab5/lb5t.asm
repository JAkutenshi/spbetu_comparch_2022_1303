AStack SEGMENT STACK
	DW 512 DUP(?)
AStack ENDS

DATA SEGMENT
    KEEP_CS DW 0
    KEEP_IP DW 0
DATA ENDS


CODE SEGMENT
ASSUME CS:CODE, DS:DATA, SS:AStack

IntToStr2 PROC
   	push AX ; сохранение регистров
   	push DX
   	push BX
   	push CX

    push ax
    mov cl, 4
    shr ax, cl
    and al, 0Fh
    add al, '0'
    int 29h

    pop ax
    and al, 0Fh
    add al, '0'
    int 29h

    pop CX	; вернуть значения со стека
    pop BX
    pop DX
    pop AX
    ret
IntToStr2 endp

IntToStr PROC
   	push AX ; сохранение регистров
   	push DX
   	push BX
   	push CX

    push ax
    mov cl, 12
    shr ax, cl
    add al, '0'
    int 29h

    pop ax
    push ax
    mov cl, 8
    shr ax, cl
    and al, 0Fh
    add al, '0'
    int 29h

    pop ax
    push ax
    mov cl, 4
    shr ax, cl
    and al, 0Fh
    add al, '0'
    int 29h

    pop ax
    and al, 0Fh
    add al, '0'
    int 29h

    pop CX	; вернуть значения со стека
    pop BX
    pop DX
    pop AX
    ret
IntToStr endp

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
	
	; mov AH, 00h	; читать часы (счетчик тиков)
	; int 1Ah	; CX,DX = счетчик тиков
	; 
	; mov AX, CX
	; call IntToStr
	; mov AX, DX
	; call IntToStr
  mov ah, 04h
  int 1ah

  mov ax, cx
  call IntToStr
  mov al, '-'
  int 29h

  xor ax, ax
  mov al, dh
  call IntToStr2
  mov al, '-'
  int 29h

  xor ax, ax
  mov al, dl
  call IntToStr2

  mov al, ' '
  int 29h
	
  mov ah, 02h
  int 1ah

  xor ax, ax
  mov al, ch
  call IntToStr2
  mov al, ':'
  int 29h

  xor ax, ax
  mov al, cl
  call IntToStr2
  mov al, ':'
  int 29h

  xor ax, ax
  mov al, dh
  call IntToStr2

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
