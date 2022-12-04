assume cs:CODE, ds:DATA, ss:AStack

AStack segment stack
dw     1024 dup(0)
AStack ends

DATA segment
  delay dw 2000
  KEEP_CS dw 0    ;хранить сs
  KEEP_IP dw 0   ;хранить ip
  error db 'Invalid number, enter new number (100--9000)', 0ah, 0dh, '$'
DATA ends

CODE segment

; dx -- input
FUNC PROC FAR
	push ax; сохранение изменяемых регистров

	mov  al, 10110111b
	out  43h, al
	in   al, 61h; получить Информация о динамике(61h)
	push ax; и сохранить ее
	or   al, 00000011b; установить 2 младших бита
	out  61h, al; Включить динамик
	mov  al, dl; высота звука
	out  42h, al; (42h - порт управл
	mov  al, dh
	out  42h, al
	mov  cx, delay; установить длительность звука

	;    Задержка
SOUND_STOP:                       ; 4 000 000 раз
	push cx
	mov  cx, delay

SOUND_STOP_2:
	nop  ; занимает мето и время
	loop SOUND_STOP_2; loop - уменьшает cs в цикле
	pop  cx
	loop SOUND_STOP

	pop ax
	and al, 11111100b
	out 61h, al; выкл
	pop ax

	mov al, 20h

	out 20h, al

	iret ; возврат из прерывания
FUNC ENDP

; al -> number
scan_digit proc near
  xor  ax, ax

  mov  ah, 01h
  int  21h

  cmp  al, 0dh
  je   enter_symbol
  sub  al, '0'
  and  ax, 00ffh
  jmp  end_scan_digit

enter_symbol:
  mov  al, 10
  and  ax, 00ffh

end_scan_digit:
  ret
scan_digit endp

MAIN PROC FAR
	push ds
	xor  ax, ax
	push ax

	mov  ax, DATA
	mov  ds, ax

	mov  ah, 35h
	mov  al, 23h
	int  21h
	mov  KEEP_CS, es
	mov  KEEP_IP, bx

  mov  cx, 4
scan_number:
  xor  dx, dx
  xor  ax, ax

  call scan_digit
  cmp  al, 10
  je   check_number
  add  dx, ax

  call scan_digit
  cmp  al, 10
  je   check_number
  shl  dx, cl
  add  dx, ax

  call scan_digit
  cmp  al, 10
  je   check_number
  shl  dx, cl
  add  dx, ax

  call scan_digit
  cmp  al, 10
  je   check_number
  shl  dx, cl
  add  dx, ax

check_number:
  cmp  dx, 100h
  jge  check_greater
  cmp  dx, 9000h
  jle  exit
  jmp  print_error

check_greater:
  jmp  exit

print_error:
  mov  dx, offset error 
  mov  ah, 09h
  int  21h
  jmp  scan_number

exit:
  push dx
	push ds
	mov  dx, offset FUNC
	mov  ax, seg FUNC
	mov  ds, ax
	mov  ah, 25h
	mov  al, 23h
	int  21h
	pop  ds
  pop  dx

  int  23h

	cli

	push ds
	mov  dx, KEEP_IP
	mov  ax, KEEP_CS
	mov  ds, ax
	mov  ah, 25h
	mov  al, 23h
	int  21h
	pop  ds

	sti 

	ret

MAIN ENDP

CODE ENDS
END  MAIN
