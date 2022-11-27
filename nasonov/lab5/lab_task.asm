DATA SEGMENT
    previous_seg dw 0
    previous_ip dw 0
    output_message db 'output message. $'
    exit_message db 'exit message.$'
    ticks_delay dw 5
DATA ENDS

AStack SEGMENT STACK
    dw 512 dup(?)
AStack ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:AStack

INT_CUSTOM PROC FAR
    push ax  ; storing registers
    push bx
    push cx  ; push numbers of output message prints
    push dx

    mov ah, 9h  ; print cx times

output_loop:
    int 21h  ; DOS service
    loop output_loop

    mov ah, 0  ; delay
    int 1Ah  ; I/O for time
    add bx, dx

delay:
    mov ah, 0
    int 1Ah  ; I/O for time
    cmp bx, dx
    jg delay

    mov dx, offset exit_message  ; print exit message
    mov ah, 9h
    int 21h  ; DOS service

    pop dx   ; restoring
    pop cx
    pop bx
    pop ax

    mov al, 20h
    out 20h, al
    iret
INT_CUSTOM ENDP

Main PROC FAR
    push ds
    sub ax, ax
    push ax
    mov ax, data
    mov ds, ax

    mov cl, 2  ; set default times to print
    sub ax, ax
    int 16h  ; get user input
    
    cmp al, '1'  ; if lesser -> use default
    jl set_time
    cmp al, '9'  ; if greater -> use default
    jg set_time

    sub al, '0'
    mov cl, al  ; set times to print from user
    
set_time:
    mov ticks_delay, 60  ; set default delay (3 sec)
    sub ax, ax
    int 16h  ; get user input
    
    cmp al, '1'  ; if lesser -> use default
    jl set_int
    cmp al, '9'  ; if greater -> use default
    jg set_int

    sub al, '0'
    mov bl, al
    mov al, 20
    mul bl
    mov ticks_delay, ax

set_int:
    mov ax, 3560h  ; storing previous interruption
    int 21h  ; DOS service
    mov previous_seg, es
    mov previous_ip, bx

    push ds  ; setting custom interruption
    mov dx, offset int_custom
    mov ax, seg int_custom
    mov ds, ax
    mov ax, 2560h
    int 21h  ; DOS service
    pop ds

    mov dx, offset output_message  ; setting registers using custom interruption manual
    ;mov cx, 03h  ; number of messages
    mov bx, ticks_delay
    ;mov bx, 64h  ; delay in ticks of process /seconds/
    int 60h  ; user interruption

    CLI  ; restoring previous interruption
    push ds
    mov dx, previous_ip
    mov ax, previous_seg
    mov ds, ax
    mov ax, 2523h
    int 21h  ; DOS service
    pop ds
    STI

    ret

main ENDP

CODE ENDS
END Main
