AStack  SEGMENT STACK
    DB 1024 DUP(?)
AStack  ENDS

DATA    SEGMENT
    KEEP_CS DW 0    
    KEEP_IP DW 0
	MESSAGE DB 'Hello!', 0dh, 0ah, '$'
	END_MES DB 'end', 0dh, 0ah, '$'
	FLAG    DB 0
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
		cmp  FLAG, 0
		jne  func_end
		mov  FLAG, 1
		
		push ax
		push bx
		push cx
		push dx
		push ds
		
		
        mov        al,4                 ; CMOS 04h - час
        call       print_cmos
        mov        al,':'               
        int        29h
        mov        al,2                 ; CMOS 02h - минута
        call       print_cmos
        mov        al,':'               
        int        29h
        mov        al,0h                ; CMOS 00h - секунда
        call       print_cmos
		mov		   al, 0dh
		int 	   29h
		mov 	   al, 0ah
		int 	   29h
		
		pop ds
		pop dx
		pop cx
		pop bx
		pop ax
		func_end:
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
    
	mov al, 0
	mov cx, 002Eh 
	mov dx, 0000h
	mov ah, 86h
	int 15h

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