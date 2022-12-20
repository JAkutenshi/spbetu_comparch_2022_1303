ASSUME CS:CODE, SS:AStack, DS:DATA

AStack    SEGMENT  STACK
          DW 12 DUP(0)
AStack    ENDS

DATA      SEGMENT

a   DW  ?
b   DW  ?
i   DW  ?
k   DW  ?

i1  DW  ?       ;f3
i2  DW  ?       ;f6
res DW  ?       ;f4
DATA      ENDS

CODE SEGMENT

Main      PROC  FAR
        push DS
        sub ax,ax
        push ax
        mov   AX,DATA
        mov   DS,AX
        ;Вычисление f1 и f2
        mov ax,a    ;ax = a
        mov cx,i    ;cx = i
        cmp ax,b    ;Сравнение значений a и b   
        jg PART1    ;если a>b то на PART1
 
        ;если a<=b:
        add cx,i   ;cx=2i
        add cx,i   ;cx=3i
        sal cx,1    ;cx = 6i
        mov ax,8    ;ax = 8
        sub ax,cx   ;ax = 8 - 6i
        mov i1,ax   ;i1(f1) = cx = 8-6i
 
        shr ax, 1   ;ax = 4 - 3i 
        sub ax, 2  ;ax = ax - 2 = 2 - 3i
        mov i2,ax   ;i2(f2) = ax = 2-3i
        jmp PART2   ;идем на PART2
 
PART1:          ;если a>b
        mov cx,i    ;cx = i 
        sal cx,1    ;i = i*4
        sal cx,1
        mov ax,7   ;ax = 7
        sub ax,cx   ;ax = ax - cx = 7 - 4i
        mov i1,ax   ;i1(f1) = cx = 7 - 4i
 
        shr ax,1 ; ax=3-2i
        sub ax,1   ;ax = ax - cx = 2 - 2i
        neg ax
        mov i2,ax   ;i2(f2) = cx = -(2 - 2i)

        ;Вычисление f3
PART2:
        mov ax,k
 
        cmp ax,0    ;сравниваем k и 0
        JGe PART4   ;если k больше или равно 0, то на PART4
 
                ;если k<0
        mov ax,i1   ;ax = i1
        cmp ax,i2
        JGe PART3   ;если i1 >= i2 то на PART3

        sub ax,i1
        cmp ax,2
        JGe PART6

        mov res,ax  ;res = ax
        jmp ENDPART

 
PART3:
        sub ax,i2 ; вычисляем разность i1 и i2 если i1 больше
        cmp ax,2
        JGe PART6   ;если модуль больше 2, то на PART6

        mov res,ax  ;res = ax
        jmp ENDPART

PART4:
                ;если k больше или равно 0,
        mov bx,i2
        neg i2
        cmp i2,-6
        JGe PART5   ;если i2 >= -6 то на PART5
 
        mov res,-6  ;res = -6
        jmp ENDPART
 
PART5:          ;если i2 >= -6
        mov res,bx  ;res = i2
        jmp ENDPART
PART6:
        mov res,2  ;res = 2
        jmp ENDPART
 
ENDPART:
        int 20h
 
Main      ENDP
CODE      ENDS
          END Main
 