; Программа изучения режимов адресации процессора IntelX86

EOL EQU '$'
ind EQU 2
n1 EQU 500
n2 EQU -50

; Стек программы

AStack SEGMENT STACK
DW 12 DUP(?) ; word - 2 байта
AStack ENDS

; Данные программы

DATA SEGMENT

; Директивы описания данных

mem1 DW 0 ; word - 2 байта
mem2 DW 0
mem3 DW 0
vec1 DB 31,32,33,34,38,37,36,35 ; byte - 1 байт
vec2 DB 50,60,-50,-60,70,80,-70,-80
matr DB -4,-3,7,8,-2,-1,5,6,-8,-7,3,4,-6,-5,1,2

DATA ENDS

; Код программы

CODE SEGMENT

ASSUME CS:CODE, DS:DATA, SS:AStack

; Головная процедура

Main PROC FAR

push DS ; push data segment
sub AX,AX
push AX
mov AX,DATA
mov DS,AX

; ПРОВЕРКА РЕЖИМОВ АДРЕСАЦИИ НА УРОВНЕ СМЕЩЕНИЙ
; Регистровая адресация

mov ax,n1
mov cx,ax
mov bl,EOL
mov bh,n2

; Прямая адресация

mov mem2,n2
mov bx,OFFSET vec1
mov mem1,ax

; Косвенная адресация

mov al,[bx]
; нельзя работать с операндами, 
; оба из которых находятся в оперативной памяти
;mov mem3,[bx] 

; Базированная адресация

mov al,[bx]+3
mov cx,3[bx]

; Индексная адресация

mov di,ind ; destination index
mov al,vec2[di]

; cx - слово (2 bytes), vec2[di] - 1 byte
;mov cx,vec2[di]

; Адресация с базированием и индексированием

mov bx,3
mov al,matr[bx][di]

; cx - word (2 bytes), matr[bx][di] - byte
;mov cx,matr[bx][di]

; в непосредственной адресации с базированием 
; и индексированием берётся сумма базового и
; индексного регистра, к ним добавляется смещение, но
; умножение там не фигурирует
;mov ax,matr[bx*4][di]

; ПРОВЕРКА РЕЖИМОВ АДРЕСАЦИИ С УЧЕТОМ СЕГМЕНТОВ

; Переопределение сегмента

; ------ вариант 1

mov ax, SEG vec2
mov es, ax
mov ax, es:[bx]
mov ax, 0

; ------ вариант 2

mov es, ax
push ds
pop es
mov cx, es:[bx-1]
xchg cx,ax

; ------ вариант 3

mov di,ind
mov es:[bx+di],ax

; ------ вариант 4

mov bp,sp

; в косвенной адресации с с индексированием адрес
; берётся в виде суммы адресов базового и индексного
; регистров, но тут оба регистра базовые
;mov ax,matr[bp+bx]

; 2 индексных и 1 базовый регистр, должны быть
; базовый и индексный регистры
;mov ax,matr[bp+di+si]

; Использование сегмента стека

push mem1
push mem2
mov bp,sp
mov dx,[bp]+2
ret 2

Main ENDP
CODE ENDS
END Main