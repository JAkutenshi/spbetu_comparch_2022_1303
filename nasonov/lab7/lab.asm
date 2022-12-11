AStack  SEGMENT STACK
    DB 1024 DUP(?)
AStack  ENDS

DATA    SEGMENT
	number_output DB 'Decimal representation: ', '$'
	N DW 0
    number_string DB ' ', '$'
    sign DB ' ', '$'
    number DW 142h
DATA    ENDS


CODE    SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:AStack
    

WriteMsg  PROC  NEAR
          mov ah, 9
          int 21h 
          ret
WriteMsg  ENDP


Number_to_String proc FAR
    push ax
    push bx
    push cx
    push dx
    
    xor cx, cx
    mov bx, 10  ; делитель 10 для десятичной c.c.
    mov di, offset number_string
 
division_mod:
    xor dx, dx
    div bx  ; ax = (dx:ax) / bx, остаток в dx
    add dl, '0'
    push dx
    inc cx
    test ax, ax
    jnz division_mod

symbols_from_stack:
    pop dx
    mov [di],dl
    inc di
    loop symbols_from_stack
    
    mov bx, '$'
    mov [di], bx
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret
Number_to_String ENDP


String_to_Number proc FAR
    push di
    push cx
    push bx
    push dx

    mov di, offset number_string
    mov dx, '$'

    xor bx,bx

find_len:
    cmp [di+bx], dx
    je len_found
    inc bx
    jmp find_len

len_found:
    mov cx, bx

    mov bx, 10
    mov dx, 0

mul_numbers:
    mul bx
    mov dl, [di]
    sub dl, '0'
    add al, dl
    inc di
    loop mul_numbers

    mov di, offset N
    mov dx, [di]
    cmp dx, 0
    je positive_num

    neg ax

positive_num:
    pop dx
    pop bx
    pop cx
    pop di
    ret
String_to_Number endp


MAIN PROC FAR
    push DS
    xor ax,ax
    push ax
    mov ax, DATA
    mov ds, ax

    mov dx, offset number_output
    call WriteMsg

    mov ax, number
    mov di, offset sign
    mov bx, "+"
    cmp ax, 0
    jge set_sign
    mov bx, "-"
    neg ax
    push bx
    mov bx, 1
    mov N, bx
    pop bx

set_sign:
    mov [di], bx
    inc di
    mov bx, '$'
    mov [di], bx

    push ax
    mov dx, offset sign
    call WriteMsg
    pop ax

    call Number_to_String
    push ax
    mov dx, offset number_string
    call WriteMsg
    pop ax

    xor ax, ax
    call String_to_Number
    ret
MAIN ENDP
CODE ENDS
    END MAIN