ASSUME CS:CODE, SS:AStack, DS:DATA

AStack    SEGMENT  STACK
          DW 12 DUP(?)
AStack    ENDS

DATA      SEGMENT

a	DW	0
b	DW	0
i	DW	0
k	DW	0

i1	DW	0
i2	DW	0
res	DW	0

DATA      ENDS

CODE      SEGMENT

Main      PROC  FAR
          mov   ax,DATA             ; Загрузка сегментного
          mov   DS,ax               ; регистра данных.

		  ;вычисление f1 и f2
		  mov	ax, a
		  mov	dx, i
		  
		  sal	dx, 1		; i*2 тк это значение потребуется в обоих случаях
		  add	i1, dx
		  add	i1, dx		; i*4 тк это значение потребуется в обоих случаях
		  
		  cmp ax, b
		  jle SecondSituation	;if ax<= b идем на SecondSituation
		  
		  ;f1
		  add	i1, 3	; i*4 + 3
		  neg	i1		; -(i*4 + 3)
		  ;f2
		  mov	bx, i1 
		  mov	i2, bx	; -i*4 -3
		  sub	i2, dx	; -i*6 -3
		  add	i2, 7	; -i*6 +4 = -(i*6 -4)
		  jmp	EndOfFunction1_2
		  
		  SecondSituation:
		  ;f1
		  add	i1, dx	; i*6
		  sub	i1, 10	; i*6 - 10
		  ;f2
		  mov	bx, i1
		  mov	i2, bx	; i*6 - 10
		  sar	i2, 1	; i*3 - 5
		  add	i2, 11	; i*3 + 6 = 3*(i+2)

		  EndOfFunction1_2:
		  ;вычисление f3
		  mov   ax,i1		; нашли модуль i1, тк используется в обоих случаях
		  getabs1:			
		  neg	ax			
		  js	getabs1	
		  
		  mov	cx, k
		  cmp	cx, 0
		  jge	ElsePart	;if k>=0 идем на ElsePart
		  
		  mov   bx,i2		; нашли модуль i2
		  getabs2:			
		  neg	bx			
		  js	getabs2		
		  
		  add	bx, ax		; сложили модули
		  mov	res, bx
		  jmp	EndOfFunc3
		  
		  ElsePart:
		  cmp	ax, 6
		  jl	secondMax
		  mov	res, ax
		  jmp	EndOfFunc3
		  secondMax:
		  mov	res, 6
		  
		  EndOfFunc3:
          int 20h
		  
Main      ENDP
CODE      ENDS
          END Main
