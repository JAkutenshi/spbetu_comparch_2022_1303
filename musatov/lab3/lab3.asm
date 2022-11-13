ASSUME CS:CODE, SS:AStack, DS:DATA

AStack    SEGMENT  STACK
          DW 32 DUP(0)
AStack    ENDS

DATA      SEGMENT

a 	DW 	?
b	DW	?
i	DW	?
k	DW	?

i1	DW	?		;f3
i2	DW	?		;f5
res	DW	?		;f3

DATA      ENDS

CODE SEGMENT

	;f3 = 7-4i, a>b
	;	  8-6i, a<=b
	;f5 = 20-4i, a>b
	;	  -(6i-6), a<=b
	;f3 = |i1+i2|, k=0
	;	  min(i1,i2), k/=0
	
Main      PROC  FAR
	mov   AX,DATA
	mov   DS,AX
	
;Вычисление f1 и f2
	mov ax,a	;заносим значение а в ах
	mov cx,i	;заносим i в cx
	cmp ax,b	;сравнение значений a и b	
	jg PART1	;если a>b, то на PART1

				;если a<=b
	sal cx,1	;умножение i на 2 => cx = i*2
	add cx,i	;cx = 2*i + i = 3*i
	sal cx,1	;умножение 3i на 2 => cx = i*6
	neg cx		;cx = -6*i
	add cx,8	;cx = -6*i + 8
	mov i1,cx	;сохранение результата в i1
	
	sub cx,2	;cx = -6*i + 8 - 2 = -6*i + 6
	mov i2,cx	;сохраняем результат в i2
	jmp PART2	;пропускаем следующие шаги
	
PART1:			;если a>b
	mov cl, 2
	mov dx,i	;восстановление значения i в dx	
	sal dx,cl	;dx = i*4
	mov ax,7	;ax = 7
	sub ax,dx	;ax = ax - dx = 7 - 4i
	mov i1,ax	;сохраняем результат в i1

	mov ax,20	;ax = 20
	sub ax,dx	;ax = ax - dx = 20 - 4*i 
	mov i2,ax	;сохраняем результат в i2
	
;Вычисление f3
PART2:
	mov ax,k
	cmp ax,0	;сравниваем k и 0
	JNe PART4	;если k не равно 0 то перйти на PART4
	
				;решение при к = 0
	mov dx,i1	;dx = i1
	add dx,i2	;dx = i1 + i2
	cmp dx,0
	JGe PART3	;если i1+ i2 >= 0 то перейти на PART3
	
	neg dx		;если i1 + i2 < 0 то меняем знак на противоположный
	mov res,dx	;res = dx
	jmp ENDPART
	
PART3:
	mov res,dx
	jmp ENDPART
	
PART4:
	mov ax,i1	;если k не равно 0
	mov bx,i2
	cmp ax,bx
	JGe PART5 	;если i1 >= i2 то перейти на PART5
	
	mov res,ax
	jmp ENDPART
	
PART5:
	mov res,bx	;если i1 >= i2
	
ENDPART:
	int 20h
		  
Main      ENDP
CODE      ENDS
          END Main