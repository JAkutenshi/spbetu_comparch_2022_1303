ASSUME CS:CODE, SS:AStack, DS:DATA
 
AStack    SEGMENT  STACK
          DW 32 DUP(0)
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
	mov   AX,DATA
	mov   DS,AX
    mov cx, i
    mov AX, a 
    cmp AX, b
    JG part2      ; if a>b go to 2 
    sal cx, 1   
    add cx, i
    add cx, 4
    mov i1, cx

    sal cx, 1
    sub cx, 18
    mov i2, cx
    jmp f3
    
part2:  
    sal cx, 1  
    mov ax, 15
    sub ax, cx
    mov i1, ax

    sal ax, 1
    sub ax, 33
    mov i2, ax

f3:
    cmp k, 0
    JE min ;if k==0 go to min 
    mov ax, i1
    cmp ax, i2
    jge res1      ; if i1 >= i2

res2:
    mov ax, i2
    mov res, ax
    jmp endprog

min:
    mov ax, i1
    cmp ax, i2
    jge res2       ; if i1 >= i2 go to i2 

res1:
    mov ax, i1
    mov res, ax

endprog:
    int 20h

    Main      ENDP
    CODE      ENDS
          END Main
