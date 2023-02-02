ASSUME CS:CODE, DS:DATA, SS:STACK

STACK SEGMENT STACK
	DW    512 DUP(0)
STACK ENDS

DATA SEGMENT
  delay dw 2000
	KEEP_CS DW 0
	KEEP_IP DW 0
DATA ENDS

CODE   SEGMENT

FUNC PROC FAR
  push ax
  push cx

  mov  al, 10110110b
  out  43h, al
  in   al, 61h
  push ax
  or   al, 00000011b
  out  61h, al
  mov  al, dl
  out  42h, al
  mov  al, dh
  out  42h, al

  mov  cx, delay
sound_duration:
  push cx
  mov  cx, delay
  sound_duration_2:
    nop
    loop sound_duration_2
  pop  cx
  loop sound_duration

  pop  ax
  and  al, 11111100b
  out  61h, al
  
  pop  cx
  pop  ax

	mov  al, 20h
  out  20h, al

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
