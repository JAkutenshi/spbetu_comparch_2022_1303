ASSUME CS:CODE, DS:DATA, SS:STACK

STACK    SEGMENT  STACK
          DW 1024 DUP(?)
STACK    ENDS

DATA SEGMENT
        KEEP_CS DW 0 ; ��� �������� ��������
        KEEP_IP DW 0 ; � �������� ������� ����������
		NUM DW 0
		MESSAGE DB 2 DUP(?)
DATA ENDS

CODE SEGMENT

OutInt PROC
	push DX
	push CX

    xor     cx, cx ; cx - ���������� ����
    mov     bx, 10 ; ��������� ��. 10 ��� ������������ � �.�.
oi2:
    xor     dx,dx
    div     bx ; ����� ����� �� ��������� �� � ��������� ������� � �����
    push    dx
    inc     cx; ����������� ���������� ���� � cx
	
    test    ax, ax ; �������� �� 0
    jnz     oi2
; �����
    mov     ah, 02h
oi3:
    pop     dx
    add     dl, '0' ; ������� ����� � ������
    int     21h
; �������� ����� ������� ���, ������� ���� ���������.
    loop    oi3 ; ���� cx �� 0 ����������� �������
    
	POP CX
	POP DX
    ret
 
OutInt endp


SUBR_INT PROC FAR
        JMP start_proc
		save_SP DW 0000h
		save_SS DW 0000h
		INT_STACK DB 40 DUP(0)
start_proc:
    MOV save_SP, SP
	MOV save_SS, SS
	MOV SP, SEG INT_STACK
	MOV SS, SP
	MOV SP, offset start_proc
	PUSH AX    ; ���������� ���������� ���������
	PUSH CX
	PUSH DX
	
	mov AH, 00H
	int 1AH
	
	mov AX, CX
	call OutInt
	mov AX, DX
	call OutInt
	
	POP  DX
	POP  CX
	POP  AX   ; �������������� ���������
	MOV  SS, save_SS
	MOV  SP, save_SP
	MOV  AL, 20H
	
	OUT  20H,AL
       
	iret
	
SUBR_INT ENDP


Main	PROC  FAR
	push  DS       ;\  ���������� ������ ������ PSP � �����
	sub   AX,AX    ; > ��� ������������ �������������� ��
	push  AX       ;/  ������� ret, ����������� ���������.
	mov   AX,DATA             ; �������� �����������
	mov   DS,AX   


	; ����������� �������� ������� ����������
	MOV  AH, 35H   ; ������� ��������� �������
	MOV  AL, 08H   ; ����� �������
	INT  21H
	MOV  KEEP_IP, BX  ; ����������� ��������
	MOV  KEEP_CS, ES  ; � ��������
	
	; ��������� ������� ����������
	PUSH DS
	MOV  DX, OFFSET SUBR_INT ; �������� ��� ��������� � DX
	MOV  AX, SEG SUBR_INT    ; ������� ���������
	MOV  DS, AX          ; �������� � DS
	MOV  AH, 25H         ; ������� ��������� �������
	MOV  AL, 08H         ; ����� �������
	INT  21H             ; ������ ����������
	POP  DS

	int 08H; �� ������ ����� � ������� �������� �� ���������

	; �������������� ������������ ������� ���������� (����� ������������)
	CLI
	PUSH DS
	MOV  DX, KEEP_IP
	MOV  AX, KEEP_CS
	MOV  DS, AX
	MOV  AH, 25H
	MOV  AL, 08H
	INT  21H          ; ��������������� ������
	POP  DS
	STI
	
	MOV AH, 4Ch                          
	INT 21h
Main      ENDP
CODE ENDS
	END Main 
