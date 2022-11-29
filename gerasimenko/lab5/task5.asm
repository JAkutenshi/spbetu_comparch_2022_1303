ASSUME CS:CODE, DS:DATA, SS:STACK

STACK    SEGMENT  STACK
          DW 1024 DUP(?)
STACK    ENDS

DATA SEGMENT
        KEEP_CS DW 0 
        KEEP_IP DW 0 
		NUM DW 0
		MESSAGE DB 2 DUP(?)
DATA ENDS

CODE SEGMENT

OutInt PROC
	push DX
	push CX

    xor     cx, cx 
    mov     bx, 10 
oi2:
    xor     dx,dx 
    div     bx 
    push    dx
    inc     cx
	
    test    ax, ax 
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
       
	PUSH AX    ; сохранение изменяемых регистров
	PUSH CX
	PUSH DX
	;INT 1aH: ввод-вывод для времени
       
	mov AH, 00H
	; выход: CX,DX = счетчик тиков с момента сброса. CX - старшая часть значения.
         ;  AL = 0, если таймер не переполнялся за 24 часа с момента сброса.
         
	int 1AH
	
	mov AX, CX
	call OutInt
	mov AX, DX
	call OutInt
	
	POP  DX
	POP  CX
	POP  AX   ; восстановление регистров
	
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
	MOV  AH, 35H   ; функция получения вектора возвращает значение
;	вектора прерывания для INT (AL); то есть, загружает в BX 0000:[AL*4]
	MOV  AL, 08H   ; номер вектора (вектор который мы будем получать)
	INT  21H   ;(вызывает функцию 35h для вектора 08h)
	MOV  KEEP_IP, BX  ; запоминание смещения
	MOV  KEEP_CS, ES  ; и сегмента
	;Вектор прерывания — закреплённый за устройством номер, который идентифицирует
	;соответствующий обработчик прерываний. Векторы прерываний объединяются в таблицу векторов 
	;прерываний, содержащую адреса обработчиков прерываний. Местоположение таблицы 
	;зависит от типа и режима работы процессора.
	
	
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
	Сбрасывается флаг IF
	;Комментарий:	Команда CLI очищает флаг IF.
 ;На другие флаги или регистры она не влияет.
 ;Внешние прерывания не распознаются в конце 
 ;команды CLI и начиная с этого момента до установки флага прерываний.

	PUSH DS
	MOV  DX, KEEP_IP ; тут сохранен предыдущий ip 
	MOV  AX, KEEP_CS ;код сегмент
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
