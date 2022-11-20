AStack  SEGMENT STACK
    DB 1024 DUP(?)
AStack  ENDS

DATA    SEGMENT
    KEEP_CS DW 0    
    KEEP_IP DW 0
DATA    ENDS

CODE    SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:AStack

print_cmos proc near
        out        70h,al               ; послать AL в индексный порт CMOS
        in         al,71h               ; прочитать данные
        push       ax
		mov        cl, 4
        shr        al,cl                ; выделить старшие четыре бита
        add        al,'0'               ; добавить ASCII-код цифры 0
        int        29h                  ; вывести на экран
        pop        ax
        and        al,0Fh               ; выделить младшие четыре бита
        add        al,30h               ; добавить ASCII-код цифры 0
        int        29h                  ; вывести на экран
        ret
print_cmos endp

FUNC PROC FAR
		push ax
		push bx
		push cx
		push dx
		push ds
		
		mov        al,0Bh               ; CMOS OBh - управляющий регистр В
        out        70h,al               ; порт 70h - индекс CMOS
        in         al,71h               ; порт 71h - данные CMOS
        and        al,11111011b         ; обнулить бит 2 (форма чисел - BCD)
        out        71h,al               ; и записать обратно
        mov        al,32h               ; CMOS 32h - две старшие цифры года
        call       print_cmos           ; вывод на экран
        mov        al,9                 ; CMOS 09h - две младшие цифры года
        call       print_cmos
        mov        al,'-'               ; минус
        int        29h                  ; вывод на экран
        mov        al,8                 ; CMOS 08h - текущий месяц
        call       print_cmos
        mov        al,'-'               ; еще один минус
        int        29h
        mov        al,7                 ; CMOS 07h - день
        call       print_cmos
        mov        al,' '               ; пробел
        int        29h
        mov        al,4                 ; CMOS 04h - час
        call       print_cmos
        mov        al,'h'               ; буква "h"
        int        29h
        mov        al,' '               ; пробел
        int        29h
        mov        al,2                 ; CMOS 02h - минута
        call       print_cmos
        mov        al,':'               ; двоеточие
        int        29h
        mov        al,0h                ; CMOS 00h - секунда
        call       print_cmos
		
		pop ds
		pop dx
		pop cx
		pop bx
		pop ax
	   	mov al, 20h
	   	out 20h, al
		iret
FUNC ENDP

MAIN PROC FAR
    push ds
	sub ax, ax
	push ax
    mov ax, DATA
    mov ds, ax
    
    mov ah, 35h 
    mov al, 08h 
    int 21h
    mov KEEP_IP, bx 
    mov KEEP_CS, es 
    
    push ds
    mov dx, OFFSET FUNC 
    mov ax, SEG FUNC 
    mov ds, ax 
    mov ah, 25h 
    mov al, 08h 
    int 21h
    pop ds
    
	int 08h

	cli
	push ds
	mov dx, KEEP_IP
	mov ax, KEEP_CS
	mov ds, ax
	mov ah, 25h
	mov al, 08h
	int 21h
	pop ds
	sti
	mov ah, 4ch
	int 21h    
MAIN ENDP
CODE ENDS
     END MAIN
