assume cs:my_code, ds:my_data, ss:my_stack

my_stack  segment stack
    db 1024 dup(0)
my_stack  ends

my_data    segment
    delay     dw 2000
    cached_cs dw 0    
    cached_ip dw 0
my_data    ends

my_code    segment

my_interruption proc far
    push ax
    push cx

    mov  al, 10110110b
    out  43h, al
    in   al, 61h                      ; Информация о динамике
    push ax
    or   al, 00000011b
    out  61h, al                      ; Включить динамик
    mov  al, dl
    out  42h, al                      ; Включить таймер для подачи сигналов на динамик
    mov  al, dh
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
    
    pop  cx
    pop  ax

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
    mov  al, 16h 
    int  21h 
    mov  cached_cs, es
    mov  cached_ip, bx 
    

    push ds                         
    mov  dx, offset my_interruption ; смещение для процедуры в DX
    mov  ax, seg my_interruption    ; сегмент процедуры
    mov  ds, ax                    
    mov  ah, 25h                    ; функция установки вектора
    mov  al, 16h                    ; номер вектора
    int  21h                        ; меняем прерывание
    pop  ds

    push dx
    mov  dx, 1000
    
    input_symb_loop:                   ; ждать нажатие клавиши
        in   al, 60h                   ; считать информацию из порта ввода клавиатуры
        cmp  al, 01h                   
        je   exit
        cmp  al, 4Eh
        je   increase
        cmp  al, 4Ah
        je   decrease
        jmp  input_symb_loop

    increase:
        cmp  dx, 32668
        jge   default
        add  dx, 100
        int  16h
        jmp  input_symb_loop

    decrease:
        cmp  dx, 100
        jle  default
        sub  dx, 100
        int  16h
        jmp  input_symb_loop

    default:
        mov  dx, 1000
        int  16h
        jmp  input_symb_loop

    exit:
        pop  dx
        
	    cli                             ; Сброс флага прерывания
	    push ds
	    mov  dx, cached_ip
	    mov  ax, cached_cs
	    mov  ds, ax
	    mov  ah, 25h
	    mov  al, 16h
	    int  21h                        ; восстанавливаем старый вектор прерывания
	    pop  ds
	    sti                             ; Установка флага прерывания
        ret

main endp

my_code ends
end main