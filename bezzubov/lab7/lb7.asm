AStack  SEGMENT STACK
    DB 1024 DUP(?)
AStack  ENDS

DATA    SEGMENT
	DECIM DB 'Decimal: ', '$'
	N DW 0
    DEC_STR DB ' ', '$'
    SIGN DB ' ', '$'
    NUMBER DW 1111h
DATA    ENDS


CODE    SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:AStack
    

WriteMsg  PROC  NEAR
          mov AH, 9
          int 21h 
          ret
WriteMsg  ENDP


Int_to_dec_str proc FAR
    push ax
    push cx
    push dx
    push bx
    xor cx,cx               ;Обнуление CX
    mov bx,10               ;В BX делитель (10 для десятичной системы)
    mov di, offset DEC_STR
 
lp1:                  ;Цикл получения остатков от деления
    xor dx,dx               ;Обнуление старшей части двойного слова
    div bx                  ;Деление AX=(DX:AX)/BX, остаток в DX
    add dl,'0'            ;Преобразование остатка в код символа
    push dx                 ;Сохранение в стеке
    inc cx                  ;Увеличение счетчика символов
    test ax,ax              ;Проверка AX
    jnz lp1           ;Переход к началу цикла, если частное не 0.
 
lp2:                  ;Цикл извлечения символов из стека
    pop dx                  ;Восстановление символа из стека
    mov [di],dl             ;Сохранение символа в буфере
    inc di                  ;Инкремент адреса буфера
    loop lp2          ;Команда цикла
    
    mov bx, '$'
    mov [di], bx
    
    pop bx
    pop dx
    pop cx
    pop ax
    ret
Int_to_dec_str ENDP


Dec_str_to_int proc FAR
    push di
    push cx
    push bx
    push dx

    mov di, offset DEC_STR
    mov dx, '$'

    xor bx,bx
    len:
    cmp [di+bx], dx
    je en
    inc bx
    jmp len
    en:
    mov cx, bx

    mov bx, 10
    mov dx, 0

    lp_1:
        mul bx
        mov dl, [di]
        sub dl, '0'
        add al, dl
        inc di
    loop lp_1

    mov di, offset N
    mov dx, [di]
    cmp dx, 0
    je pos_num

    neg ax

    pos_num:

    pop dx
    pop bx
    pop cx
    pop di
    ret
Dec_str_to_int endp


MAIN PROC FAR
    push DS
    xor ax,ax
    push ax
    mov ax, DATA
    mov ds, ax

    mov dx, offset DECIM
    call WriteMsg

    mov ax, NUMBER
    mov di, offset SIGN
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
    mov dx, offset SIGN
    call WriteMsg
    pop ax

    call Int_to_dec_str
    push ax
    mov dx, offset DEC_STR
    call WriteMsg
    pop ax

    xor ax, ax
    call Dec_str_to_int
    ret
MAIN ENDP
CODE ENDS
    END MAIN