.586p
.MODEL FLAT, C
.CODE
second PROC C USES EDI ESI, array:dword, NInt:dword, x_min:dword, gr:dword, arr_out:dword

push eax
push ebx
push ecx
push edx
push esi
push edi

mov esi, array ; esi - input array address
mov ecx, NInt ; ecx - border array size
mov edi, gr ; edi - border array
mov ebx, 0

l1:
	mov eax, [edi + 4 * ebx] ; eax - left border
	sub eax, x_min ; eax - left index
	inc ebx
	mov edx, [edi + 4 * ebx] ; edx - right border
	sub edx, x_min ; edx - right index
	push ecx
	mov ecx, 0

	l2:
		add ecx, [esi + 4 * eax]
		inc eax
		cmp eax, edx
		jl l2
	dec ebx
	push edi
	mov edi, arr_out
	mov [edi + 4 * ebx], ecx
	inc ebx
	pop edi
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

second ENDP
END