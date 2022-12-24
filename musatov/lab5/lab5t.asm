assume cs:my_code, ds:my_data, ss:my_stack

my_stack  segment stack
  db 1024 dup(0)
my_stack  ends

my_data    segment
  delay     dw 2000
  cached_cs dw 0
  cached_ip dw 0
  flag      db 0
my_data    ends

my_code    segment

; dx -- speaker sound frequency (decimal)
my_interruption proc far
  cmp  flag, 0
  je   my_interruption_exit
  mov  flag, 0
  push ax

  in   al, 61h                      ; Информация о динамике
  push ax
  or   al, 00000011b
  out  61h, al                      ; Включить динамик, управление таймером
  mov  al, 10110110b                ; Настройка управляющего регистра таймера
  mov  ax, dx
  out  42h, al                      ; Установка заданной частоты
  mov  cl, 4
  shr  ax, cl
  out  42h, al
  mov  cx, delay

; Задержка
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
  out  61h, al                      ; Выключить динамик

  pop  ax

my_interruption_exit:
  mov  al, 20h
  out  20h, al

  iret
my_interruption endp

main proc far
  push ds
	xor  ax, ax
	push ax

  mov  ax, my_data
  mov  ds, ax

  mov  ah, 35h                    ; сохраняем адрес старого прерывания
  mov  al, 1ch
  int  21h
  mov  cached_cs, es
  mov  cached_ip, bx

  push ds
  mov  dx, offset my_interruption ; смещение для процедуры в DX
  mov  ax, seg my_interruption    ; сегмент процедуры
  mov  ds, ax
  mov  ah, 25h                    ; функция установки вектора
  mov  al, 1ch                    ; номер вектора
  int  21h                        ; меняем прерывание
  pop  ds

input_loop:
  in   al, 60h
  cmp  al, 01h
  je   exit
  cmp  al, 1dh
  jne  input_loop
input_c_loop:
  in   al, 60h
  cmp  al, 9dh
  je   input_loop
  cmp  al, 2eh
  jne  input_c_loop

  mov  flag, 1

  xor  ax, ax
  mov  ah, 86h
  mov  cx, 0fh
  mov  dx, 4240h
  int  15h

exit:
  cli                             ; Сброс флага прерывания
  push ds
  mov  dx, cached_ip
  mov  ax, cached_cs
  mov  ds, ax
  mov  ah, 25h
  mov  al, 1ch
  int  21h                        ; восстанавливаем старый вектор прерывания
  pop  ds
  sti                             ; Установка флага прерывания
  ret

main endp

my_code ends
end main
