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
          cmp AX, B
          jle ALessB
          
BLessA:
	  ;2(i+1)-4
          add CX, 1
          shl CX, 1
          sub CX, 4
          mov I2, CX
          
	  ;-(4i+3)
	  shl CX, 1
	  add CX, 7
	  neg CX
	  mov I1, CX
          jmp ABSI1

ALessB:
	  ; 5 - 3*(i+1)
	  add CX, 1
          mov BX, CX
          
          shl CX, 1
          shl CX, 1
          sub CX, BX
          neg CX
          add CX, 5
          mov I2, CX
          
          ;6i - 10
          shl CX, 1
          neg CX
          sub CX, 6
          mov I1, CX         
          
ABSI1:
          mov CX, I1
          cmp CX, 0
          jge F3
          neg I1

F3:
          mov CX, K
          cmp CX, 0
          jne ABSI2     

F3_1:
          mov CX, I1
          cmp CX, 6
          jle MIN
          mov AX, 6
          jmp F3RESULT
   
MIN:
          mov AX, I1
          jmp F3RESULT
          
ABSI2:
          mov CX, I2
          cmp CX, 0
          jge F3_2
          neg I2

F3_2:
          mov AX, I1
          add AX, I2
          jmp F3RESULT         

F3RESULT:
          mov RES, AX
          ret
          		  
Main      ENDP
CODE      ENDS
          END Main
