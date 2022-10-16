ASSUME CS:CODE, SS:AStack, DS:DATA
 
AStack    SEGMENT  STACK
          DW 32 DUP(0)
AStack    ENDS
 
DATA      SEGMENT
 
i	DW	0
a 	DW 	0
b	DW	0
k	DW	0
 
i1	DW	0		;f1
i2	DW	0		;f2
res	DW	0		;f3
 
DATA      ENDS
 
CODE SEGMENT
 
Main      PROC  FAR
	mov   AX,DATA
	mov   DS,AX
 
;Вычисление f1 и f2
	mov ax,a	;ax = a
	mov cx,i	;cx = i
	cmp ax,b	;Сравнение значений a и b	
	jg PART1	;если a>b то на PART1
 
	;если a<=b:
	sal cx,1	;cx = i*2
	add cx,i	;cx = 2*i + i = 3*i	
	mov ax,4	;ax = 4
	add cx,ax	;cx = 3*i + 4
	mov i1,cx	;i1(f1) = cx = 3i + 4
 
	sal cx, 1	;cx = 6i + 8
	sub cx, 18	;cx = cx - ax = 6i - 10
	mov i2,cx	;i2(f2) = cx = 6i - 10
	jmp PART2	;идем на PART2
 
PART1:			;если a>b
	mov cx,i	;cx = i	
	sal cx,1	;i = i*2
	mov ax,15	;ax = 15
	sub ax,cx	;ax = ax - cx = 15 - 2i
	mov i1,ax	;i1(f1) = cx = 15 - 2i
 
	sal ax, 1	;ax = 30 - 4i
	sub ax,33	;ax = ax - cx = -3 - 4i
	mov i2,ax	;i2(f2) = cx = -(3 + 4i)
 
;Вычисление f3
PART2:
	mov ax,k
 
	cmp ax,0	;сравниваем k и 0
	JNe PART4	;если k не равно 0, то на PART4
 
				;если к = 0
	mov ax,i1	;ax = i1
	cmp ax,i2
	JGe PART3	;если i1 >= i2 то на PART3
 
	mov res,ax	;res = ax = i1
	jmp ENDPART
 
PART3:
	mov res,bx	;res = bx = i2
	jmp ENDPART
 
PART4:
				;если k не равно 0
	mov ax,i1	;ax = i1
	cmp ax,i2
	JGe PART5 	;если i1 >= i2 то на PART5
 
	mov res,bx	;res = bx = i2
	jmp ENDPART
 
PART5:			;если i1 >= i2
	mov res,ax	;res = ax = i1
 
ENDPART:
	int 20h
 
Main      ENDP
CODE      ENDS
          END Main
 
