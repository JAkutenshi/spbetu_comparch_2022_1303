assume ss:my_stack, cs:my_code, ds:my_data

my_stack segment stack
    dw 12 dup('?')
my_stack ends

my_data segment

    i dw 0
    a dw 0
    b dw 0
    k dw 0

    i1 dw 0
    i2 dw 0
    res dw 0

my_data ends

my_code segment

f1_f2 proc near
    mov ax, a
    cmp ax, b
    jg greater

less_or_equal:
    mov ax, i
    sal ax, 1 ; 2 * i
    add ax, i ; 3 * i
    add ax, 4 ; 4 + 3 * i
    mov i1, ax ; i1 = 3 * i + 4

    add ax, 2 ; 6 + 3 * i
    jmp end_f1_f2

greater:
    mov cx, i 
    sal cx, 1 ; 2 * i
    mov ax, 15 ; 15 + 2 * i
    sub ax, cx ; 15 - 2 * i
    mov i1, ax ; i1 = 15 - 2 * i

    add cx, i ; 3 * i
    add cx, cx ; 6 * i
    mov ax, 4 
    sub ax, cx ; 4 - 6 * i

end_f1_f2:
    mov i2, ax  

    ret

f1_f2 endp

f3 proc near
    mov ax, k
    cmp ax, 0
    je equal_zero

not_equal_zero:
    mov ax, i1
    cmp ax, i2
    jle end_f3 ; i1 <= i2
    mov ax, i2 
    jmp end_f3 ; i1 > i2

equal_zero:
    mov ax, i1 
    add ax, i2
    cmp ax, 0
    jge end_f3 ; i1 + i2 >= 0

    abs: ; i1 + i2 < 0
        neg ax

end_f3:
    mov res, ax

    ret

f3 endp

main proc far
    push ds
    xor ax, ax
    push ax
    
    mov ax, my_data
    mov ds, ax

    call f1_f2
    call f3

    mov ax, i1
    mov bx, i2
    mov cx, res
    
    ret
main endp

my_code ends

end main