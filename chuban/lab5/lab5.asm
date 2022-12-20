DATA SEGMENT 
    SAVE_IP DW 0
    SAVE_CS DW 0
DATA ENDS

AStack SEGMENT STACK
    DW 1024 DUP(?)
AStack ENDS

CODE SEGMENT 
    ASSUME CS:CODE, DS:DATA, SS:AStack

SUBR_INT PROC FAR
    push AX
    push BX
    push DX
    push CX

    ;mov di, 10000 ;freq
    mov bx, 5;time
    mov al, 0b6h
    out 43h, al
    mov dx, 0014h
    mov ax, 4f38h
    div di

    ; set freq
    out 42h, al 
    mov al, ah
    out 42h, al
    
    ;sound on
    in al, 61H ;cur port state to al
    mov ah, al ;save state in ah
    or al, 3 ;set 0 and 1 bit at 1 
    out 61H, al ;speaker on 

    l1: mov cx, 2801h
    l2: loop l2
    dec bx
    jnz l1
    mov al, ah
    and al, 11111100b
    out 61H, al


    pop AX
    pop BX
    pop DX
    pop CX
    mov AL, 20H
    out 20H, AL
    iret
SUBR_INT ENDP

Main PROC FAR
    push ds
    sub ax,ax
    push ax
    mov ax, DATA
    mov ds, ax

    mov di, 10000

    MOV AH, 35H 
    MOV AL, 08H
    INT 21H
    MOV SAVE_IP, BX
    MOV SAVE_CS, ES

    push DS
    mov DX, offset SUBR_INT
    mov ax, seg SUBR_INT
    mov ds, ax
    mov ah, 25h
    mov al, 08H
    int 21h
    pop ds

    
loop_int:
    push ax
    mov ah, 1h
    int 21H

    cmp al, "-"
    je minus

    cmp al, "+"
    je plus

    cmp al, 1bh
    
    pop ax
    jnz loop_int
    jmp exit

plus:
    add di, 1000
    pop ax
    jmp loop_int

minus:
    sub di, 1000
    pop ax
    jmp loop_int


exit:
    CLI
    PUSH DS
    MOV  DX, SAVE_IP
    MOV  AX, SAVE_CS
    MOV  DS, AX
    MOV  AH, 25H
    MOV  AL, 08H
    INT  21H
    POP  DS
    STI

    ret
Main ENDP

CODE ENDS
     END Main
