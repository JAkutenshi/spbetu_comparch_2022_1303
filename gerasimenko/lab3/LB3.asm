AStack    SEGMENT  STACK
	  DW 12 DUP(?)
AStack    ENDS

DATA      SEGMENT
A	   DW 14
B	   DW -5
I	   DW 2

K	   DW 0
I1 	   DW ?
I2	   DW ?

RES	   DW ?
DATA      ENDS

CODE      SEGMENT
	ASSUME CS:CODE, DS:DATA, SS:AStack
	
Main      PROC  FAR
          push  DS
          sub   AX,AX
          push  AX
          mov   AX,DATA
          mov   DS,AX
          
          mov AX, A
          mov CX, I
          cmp AX, B ; меняет флаги(компоратор) 
          jle ALessB ;  прыжом если меньше либо равно(jump less ec) 
          
BLessA:
	  ;15-2*i
        shl CX, 1
        neg CX
		add CX, 15
		mov I1, CX
		
	  ;20-4*i
	  shl CX,1 
	  sub CX,10
	  mov I2, CX
          jmp CMPK

ALessB:
	  ; 3*i+4
	  mov BX,CX
	  shl CX, 1
	  add CX, BX
	  add CX, 4
	  mov I1, CX
	  
          ;-(6*i-6)
		shl CX, 1
		neg CX
       add CX, 14
	   mov I2,CX
	   
	   
          
CMPK:
	      cmp K, 0
		  mov  BX, K
		  jge F4_2
		
F4_1:
		mov CX, I1
		sub CX, I2
        cmp CX, 0
		jle ABSV
		jmp MIN 

ABSV:
		neg CX
   
MIN:
        cmp CX, 2
		jle F4_res
		mov CX, 2
          
F4_res:
        mov AX, CX
		jmp F4_ans

F4_2:
	mov CX, I2
	neg CX
	mov AX, 6
	neg AX
	cmp CX, AX
	jle F4_ans
	mov AX, CX

F4_ans:
          mov RES, AX
          ret
          		  
Main      ENDP
CODE      ENDS
          END Main

