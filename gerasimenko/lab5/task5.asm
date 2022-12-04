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

double proc
	push AX
	push DX
	mov DL,':'
	mov AH, 02h
	int 21h
	pop DX
	pop AX	
	ret
double endp


print proc
	push AX
	push DX
	push BX

        aam ; AH = AL//10
        mov BX, AX
        mov ah, 02h        
        
        mov DL, BH
        add DL, '0'
        int 21h
        
        mov DL, BL
        add DL, '0'
        int 21h
	
	pop BX
	pop DX
	pop AX
	ret
print endp

GetTime PROC FAR

	cmp  FLAG, 0
	jne  func_end
	mov  FLAG, 1
		
	push AX    ; сохранение изменяемых регистров
	push CX ;
	push DX; 
	push BX
	mov ah, 2ch 


	int 21h
	
	mov al, ch
	call print
	call double
	mov al, cl
	call print
	call double
	mov al, dh
	call print
	
	pop BX
	pop DX
	pop CX
	pop AX   ; восстановление регистров


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
