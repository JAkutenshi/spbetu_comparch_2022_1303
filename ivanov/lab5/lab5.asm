AStack SEGMENT STACK
	DW 512 DUP(?)
AStack ENDS

DATA SEGMENT
        temp_cs DW 0
        temp_ip DW 0
DATA ENDS

CODE SEGMENT
ASSUME CS:CODE, DS:DATA, SS:AStack

print_point proc 
	push AX
	push DX
	mov DL,'.'
	mov AH, 02h
	int 21h
	pop DX
	pop AX	
	ret
print_point endp

print_double proc
	push AX
	push DX
	mov DL,':'
	mov AH, 02h
	int 21h
	pop DX
	pop AX	
	ret
print_double endp

print_space proc
	push AX
	push DX
	mov DL,' '
	mov AH, 02h
	int 21h
	pop DX
	pop AX	
	ret
print_space endp

print proc
	push AX
	push DX
	push BX
        aam
        mov BX, AX
        mov ah, 02h        
        mov DL, BH
        add DL, '0'
        int 21h
        mov DL, BL
        add DL, '0'
        int 21h
	pop BX
	pop DX
	pop AX
	ret
print endp

get_time PROC FAR
       jmp time
	temp_ss DW 0
	temp_sp DW 0
	Stack DB 50 dup(" ")
time:
	mov temp_ss, SS
	mov temp_sp, SP
	mov SP, SEG Stack
	mov SS, SP
	mov SP, offset time
	push AX    
	push CX
	push DX
	
	mov ah, 2Ah     ; ѕолучение системной даты [DD in dl , MM in dh, YYYY in cx]
        int 21h
	mov al, dl ; день
	call print
	call print_point ; символ точки
	mov al, dh ; мес€ц
	call print

	call print_space ; пробел между DD.MM и hh:mm:ss

	mov ah, 2ch ; ѕолучение системной даты  [HH in ch, MM in cl, SS in dh]
	int 21h
	mov al, ch ; часы
	call print 
	call print_double
	mov al, cl ; минуты
	call print
	call print_double
	mov al, dh ;секунды
	call print
	
	pop DX
	pop CX
	pop AX 
	mov SS, temp_ss 
	mov SP, temp_sp

	mov AL, 20H
	out  20H,AL
	iret
get_time ENDP


Main	PROC  FAR
	push DS
	sub AX,AX
	push AX
	mov AX, DATA
	mov DS, AX
	mov AH,35h 
	mov AL,60h 
	int 21h    
	mov temp_ip, BX 
	mov temp_cs, ES 
	push DS
	mov DX, offset get_time	
	mov AX, seg get_time	
	mov DS, AX
	mov AH, 25h 	
	mov AL, 60h 	
	int 21h 	
	pop DS
	int 60h	
	CLI 	
	push DS
	mov DX, temp_ip
	mov AX, temp_cs
	mov DS, AX
	mov AH, 25h
	mov AL, 60h
	int 21h
	pop DS
	STI 
	ret
Main ENDP
CODE ENDS
	END Main