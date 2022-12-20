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
cmp AX,b
jg True

sal CX,1
add CX,i
mov i1,CX
add i1,4

sal CX,1
mov i2,8
sub i2,CX

jmp F3

True:
sal CX,1
mov i1,15
sub i1,CX

sal CX,1
mov i2,7
sub i2,CX

F3:
cmp k,0
jl K_LESS
mov AX,i1
sub AX,i2
mov res,AX
cmp res,0
jl NEGRES
jmp QUIT

NEGRES:
neg res
jmp QUIT

K_LESS:
mov AX,10
sub AX,i2
cmp i1,AX
jg i1_GREATER
mov res,AX
jmp QUIT

i1_GREATER:
mov AX,i1
mov res,AX

QUIT:
    int 20

Main    ENDP
CODE    ENDS
        END Main
