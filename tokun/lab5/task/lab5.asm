AStack  SEGMENT STACK
    DB 1024 DUP(?)
AStack  ENDS

DATA    SEGMENT
  KEEP_CS DW 0    ; для хранения сегмента вектора прерывания
  KEEP_IP DW 0    ; для смещения вектора прерывания
  MESSAGE DB 'Hello world', 0dh, 0ah, '$'
DATA    ENDS

CODE    SEGMENT
ASSUME CS:CODE, DS:DATA, SS:AStack

WriteMsg  PROC  NEAR
  push ax
  mov AH, 9
  int 21h 
  pop ax
  ret
WriteMsg  ENDP

FUNC PROC FAR
	push dx

	mov dx, OFFSET MESSAGE
	call WriteMsg
	
	pop dx
	
  mov al, 20h
  out 20h, al
	iret
FUNC ENDP

MAIN PROC FAR
  push ds
  mov ax, DATA
  mov ds, ax
    
  mov ah, 35h ; функция получения вектора
  mov al, 08h ; номер вектора
  int 21h
  mov KEEP_IP, bx ; запоминание смещения
  mov KEEP_CS, es ; и сегмента вектора прерывания
    
  push ds
  mov dx, OFFSET FUNC ; смещение для процедуры в DX
  mov ax, SEG FUNC ; сегмент процедуры
  mov ds, ax ; помещаем в DS
  mov ah, 25h ; функция установки вектора
  mov al, 08h ; номер вектора
  int 21h ; меняем прерывание
  pop ds
    
  mov cx, 1000
loop_1:
  push cx
  mov cx, 1000
  loop_2:
    nop
    loop loop_2
  pop cx
  loop loop_1
    
  cli
  push ds
  mov dx, KEEP_IP
  mov ax, KEEP_CS
  mov ds, ax
  mov ah, 25h
  mov al, 08h
  int 21h ; восстанавливаем старый вектор прерывания
  pop ds
  sti
  mov ah, 4ch
  int 21h
MAIN ENDP
CODE ENDS
 END MAIN
