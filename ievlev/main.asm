AStack SEGMENT STACK
	dw 1024 dup(?)
AStack ENDS


DATA SEGMENT
	KEEP_CS dw 0
	KEEP_IP dw 0
	message db 'Hello world! $'
	end_message db 'Leaving!$'
DATA ENDS


CODE SEGMENT
	ASSUME CS:CODE, DS:DATA, SS:Astack

SUBR_INT PROC FAR
	push ax
	push bx
	push cx
	push dx

	mov ah, 09h

output:
	int 21h
	loop output

	mov ah, 0
	int 1Ah
	add bx, dx

delay:
	mov ah, 0
	int 1Ah
	cmp bx, dx
	jg delay

	mov dx, offset end_message
	mov ah, 09h
	int 21h

	pop ax
	pop bx
	pop cx
	pop dx

	mov al, 20h
	out 20h, al
	iret
SUBR_INT ENDP


Main PROC FAR
	push ds
	sub ax, ax
	push ax
	mov ax, data
	mov ds, ax

	mov ah, 35h
	mov al, 60h
	int 21h
	mov KEEP_CS, es
	mov KEEP_IP, bx

	push ds
	mov dx, offset SUBR_INT
	mov ax, seg SUBR_INT
	mov ds, ax
	mov ah, 25h
	mov al, 60h
	int 21h
	pop ds

	mov dx, offset message
	mov cx, 05h
	mov bx, 30h
	int 60h

	CLI
	push ds
	mov dx, KEEP_IP
	mov ax, KEEP_CS
	mov ds, ax
	mov ah, 25h
	mov al, 1ch
	int 21h
	pop ds
	STI
	
	mov ah, 4ch
	int 21h
Main ENDP
CODE ENDS
	END Main