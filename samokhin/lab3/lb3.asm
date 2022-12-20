ASSUME CS:CODE, SS:AStack, DS:DATA

AStack    SEGMENT  STACK
          DW 12 DUP('!')   
AStack    ENDS


DATA      SEGMENT
a DW 0
b DW 0
i DW 0
k DW 0
i1 DW 0
i2 DW 0
res DW 0 
DATA      ENDS

CODE SEGMENT

Main PROC FAR
push DS
sub AX,AX
push AX

mov AX, DATA
mov DS, AX

mov AX,a
mov CX,i
sal CX,1
cmp AX,b
jg Abigger

add CX,i
mov i1,CX
add i1,6
mov i2,CX
sub i2,10
neg i2

jmp F3

Abigger:
mov i2,CX
sal i2,1
sub i2,5
neg i2

add CX,i
sal CX,1
mov i1,CX
sub i1,4
neg i1

F3:
cmp k,0
jl K_LESS
mov AX,i1
sub AX,i2
mov res,AX
cmp res,0
jl NEGATRES
jmp QUIT

NEGATRES:
neg res
jmp QUIT

K_LESS:
mov AX,10
sub AX,i2
cmp i1,AX
jg i1_BIGGER
mov res,AX
jmp QUIT

i1_BIGGER:
mov AX,i1
mov res,AX

QUIT:
    int 20

Main    ENDP
CODE    ENDS
        END Main
