
ASSUME CS:CODE, SS:AStack, DS:DATA

AStack    SEGMENT  STACK
          DW 12 DUP(0)
AStack    ENDS

DATA      SEGMENT

	i	DW	0
	a 	DW 	0
	b	DW	0
	k	DW	0

	i1	DW	0
	i2	DW	0		
	res	DW	0		
DATA      ENDS

CODE SEGMENT

Main      PROC  FAR
    push ds
    sub ax,ax
    push ax
	mov   ax,DATA
	mov   ds,ax


	mov ax,a	;а -> ах
	mov cx,i	;i -> cx
	cmp ax,b	;Сравнение значений a и b
	jg STEP1	;при a>b переход на STEP1

	;if a<=b
	add cx, i 	;i+i = 2i
	add cx, i 	;2i+i = 3i
	add cx,6  	;3i+6
	mov i1,cx 	;перемещаем результат в i1
	
	neg cx		;-(3i+6) = -3i-6
	add cx,18	;-3i-6+18 = -3i+12
	mov i2,cx	;перемещаем результат в i2
	jmp STEP2	;переход на STEP2

STEP1:
	;if a>b
	mov cx, i   ;cx = i
	add cx, i 	;i+i = 2i
	add cx, i 	;2i+i = 3i
	sal cx, 1 	;3i<<1 = 3i*2 = 6i
	sub cx, 4 	;6i-4
	neg cx    	;-(6i-4)
	mov i1,cx 	;перемещаем результат в i1

	sub cx, 12	;-6i+4-12 = -6i-8 = -(6i+8)
	mov i2,cx 	;перемещаем результат в i2

;Вычисление f3
STEP2:
	mov ax,k
	cmp ax,0	;сравнение к и 0
	JNe STEP3 	;если k не равно 0 то переход на STEP3
	
	;к = 0
	mov dx,i1	;dx = i1
	add dx,i2	;dx = i1 + i2
	cmp dx,0	;сравнение i1+i2 и 0
	JGe STEP5	;если i1+ i2 >= 0 то перейти на STEP5
	
	neg dx		;если i1 + i2 < 0 то меняем знак на противоположный
	mov res,dx	;res = dx
	jmp STEP6
STEP5:
	mov res,dx
	jmp STEP6
STEP3:
	mov ax,i1	;если k не равно 0
	mov bx,i2
	cmp ax,bx	;сравнение i1 и i2
	JGe STEP4 	;если i1 >= i2 то перейти на STEP4
	
	mov res,ax
	jmp STEP6
STEP4:
	mov res,bx	;если i1 >= i2, то в res перемещаем значение i2
STEP6:
	int 20h
		  
Main      ENDP
CODE      ENDS
          END Main