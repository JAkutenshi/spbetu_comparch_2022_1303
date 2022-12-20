; Учебная программа N2  цикла лаб.раб. по дисциплине
;   "Организация и функционирование ЭВМ"
;
EOL  EQU  '$'
ind  EQU  2
n1   EQU  500
n2   EQU  -50

; Стек  программы

AStack    SEGMENT  STACK
          DW 12 DUP(?)
AStack    ENDS

; Данные программы

DATA      SEGMENT

;  Директивы описания данных

mem1      DW    0
mem2      DW    0
mem3      DW    0
vec1      DB    8,7,6,5,1,2,3,4
vec2      DB    -30,-40,30,40,-10,-20,10,20
matr      DB    -1,-2,-3,-4,8,7,6,5,-5,-6,-7,-8,4,3,2,1

DATA      ENDS

; Код программы

CODE      SEGMENT
          ASSUME CS:CODE, DS:DATA, SS:AStack

; Головная процедура
Main      PROC  FAR
          push  DS
          sub   AX,AX
          push  AX
          mov   AX,DATA
          mov   DS,AX

;  ПРОВЕРКА РЕЖИМОВ АДРЕСАЦИИ НА УРОВНЕ СМЕЩЕНИЙ
;  Регистровая адресация
          mov  ax,n1
          mov  cx,ax
          mov  bl,EOL
          mov  bh,n2
;  Прямая   адресация
          mov  mem2,n2
          mov  bx,OFFSET vec2
          mov  mem1,ax
;  Косвенная адресация
          mov  al,[bx]    ; --- записываем значение лежащее по адресу bx
;          mov  mem3,[bx]               -------------------------------- некорректнаая конструкция
;  Базированная адресация
          mov  al,[bx]+3
          mov  cx,3[bx]
;  Индексированная адресация
          mov  di,ind
          mov  al,vec2[di]
;          mov  cx,vec2[di]             -------------------------------- некорректнаая конструкция
;  Адресация с базированием и индексированием
          mov  bx,3
          mov  al,matr[bx][di]
;          mov  cx,matr[bx][di]         -------------------------------- некорректнаая конструкция
;          mov  ax,matr[bx*4][di]       -------------------------------- некорректнаая конструкция

;  ПРОВЕРКА АДРЕСАЦИИ С УЧЕТОМ СЕГМЕНТОВ
;  Переопределение сегмента
;  ------ вариант 1
          mov  ax, SEG vec2
          mov  es, ax
          mov  ax, es:[bx]
		  mov  ax, 0
;  ------ вариант 2
          mov  es, ax
          push ds
          pop  es
          mov  cx, es:[bx-1]
          xchg cx,ax
;  ------ вариант 3
          mov  di,ind
          mov  es:[bx+di],ax
;  ------ вариант 4
;          mov  ax,matr[bp+bx]          -------------------------------- некорректнаая конструкция
;          mov  ax,matr[bp+di+si]       -------------------------------- некорректнаая конструкция
;  Использование сегмента стека
          push  mem1
          push  mem2
          mov  bp,sp
          mov  dx,[bp]+2
          ret   2
Main      ENDP
CODE      ENDS
          END Main
