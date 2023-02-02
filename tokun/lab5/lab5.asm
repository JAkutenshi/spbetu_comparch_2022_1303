STACK SEGMENT STACK
    DW 512 DUP(0)
STACK ENDS

DATA SEGMENT
    KEEP_CS DW 0
    KEEP_IP DW 0
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:STACK
    SUBR_INT PROC FAR
        push ax
        push dx
        push bx

        mov al, 10110110b
        out 43h, al

        mov ax, 4400
        out 42h, al
        mov al, ah
        out 42h, al

        in al, 61h
        or al, 00000011b
        out 61h, al

        mov  ah, 0
        int  1ah
        mov  bx, dx
        add  bx, 45
        delay_loop:
        int  1ah
        cmp  dx, bx
        jne  delay_loop
 
        in al, 61h
        and al, 11111100b
        out 61h, al 

        pop bx
        pop dx
        pop ax
        mov al, 20h
        out 20h, al
        iret
    SUBR_INT ENDP

    MAIN PROC FAR
        push DS
        sub AX, AX
        push AX
        mov AX, DATA
        mov DS, AX

        mov AX, 3523h
        int 21h
        mov KEEP_CS, es
        mov KEEP_IP, bx
        
        push ds
        mov dx, offset SUBR_INT
        mov ax, seg SUBR_INT
        mov ds, ax
        mov ax, 2523h
        int 21h
        pop ds

        mov ah, 01h
        int 21h

        ;int 23h

        CLI
        mov dx, KEEP_IP
        mov ax, KEEP_CS
        mov ds, ax
        mov ax, 2523h
        int 21h
        pop ds
        STI

        mov AH, 4ch
        int 21h
    MAIN ENDP

CODE ENDS

END MAIN