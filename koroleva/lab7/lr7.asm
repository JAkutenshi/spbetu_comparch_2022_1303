AStack  SEGMENT STACK
    DB 1024 DUP(?)
AStack  ENDS

DATA    SEGMENT
	N DW 0
    Oct_str DB 10, 13, ' ', '$'
    SIGN DB '  ', '$'
	NUMBER DW -36
DATA    ENDS

CODE    SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:AStack
    

WriteMsg  PROC  NEAR
          mov AH, 9
          int 21h 
          ret
WriteMsg  ENDP



Int_to_oct_str proc FAR
    push ax
    push cx
    push dx
    push bx
    xor cx,cx              ;CX = 0
    mov bx,8               ;В BX делитель (8 для восьмиричной системы)
    mov di, offset Oct_str
 
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
    mov [di],dl             ;Сохранение символа в Oct_str 
    inc di                  ;Смещаем адрес Oct_str на единичку вправо
    loop lp2          ;Команда цикла
    
    mov bx, '$'
    mov [di], bx		;положили символ конца строки
    
    pop bx
    pop dx
    pop cx
    pop ax
    ret
Int_to_oct_str ENDP


Oct_str_to_int proc FAR
    push di
    push cx
    push bx
    push dx

    mov di, offset Oct_str
    mov dx, '$'

    xor bx,bx
    len:
    cmp [di+bx], dx
    je en			;Если встреченный символ - конец строки, выходим из цикла
    inc bx
    jmp len
    en:
    mov cx, bx

    mov bx, 8
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
Oct_str_to_int endp


MAIN PROC FAR
    push DS
    xor ax,ax
    push ax
    mov ax, DATA
    mov ds, ax

    mov dx, offset Oct_str
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

    call Int_to_oct_str
	
    push ax
    mov dx, offset Oct_str
    call WriteMsg
    pop ax

    xor ax, ax
    call Oct_str_to_int
    ret
MAIN ENDP
CODE ENDS
    END MAIN