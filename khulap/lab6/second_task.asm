.586p
.MODEL FLAT, C
.CODE
second_task PROC C USES EDI ESI, array:dword, NInt:dword, x_min:dword, gr:dword, arr_out: dword

push eax
push ebx
push ecx
push edx
push esi
push edi

mov esi, array
mov ecx, NInt
mov edi, gr
mov ebx, 0

l1:
	mov eax, [edi + 4 * ebx]
	push ecx
	mov ecx, eax
	sub eax, x_min
	inc ebx
	mov edx, [edi + 4 * ebx]
	sub edx, x_min
	push ebx
	l2:
		mov ebx, [esi + 4 * eax]
		cmp ebx,0
		jne l7
		inc ecx
		inc eax
		cmp eax, edx
		jl l2
	l7:
	pop ebx
	dec ebx
	push edi
	mov edi, arr_out
	mov [edi + 4 * ebx], ecx
;	inc ebx
	pop edi
	inc ebx ;
	pop ecx
	dec ecx
	jnz l1


pop edi
pop esi
pop edx
pop ecx
pop ebx
pop eax
ret

second_task ENDP
END