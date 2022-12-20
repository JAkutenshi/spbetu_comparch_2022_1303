.586p
.MODEL FLAT, C
.CODE
first PROC C USES EDI ESI, arr:dword, len:dword, x_min:dword, x_max:dword, arr_out:dword

push eax
push ebx
push ecx
push edx
push esi
push edi

mov esi, arr ; esi - input array address
mov ecx, len ; ecx - input array size
mov edi, arr_out ; edi - output array address
mov eax, x_max
sub eax, x_min
inc eax

mov ebx, eax
mov edx, 0
mov eax, 0


mov edx, 0
l1:
	mov eax, [esi + 4 * edx]
	sub eax, x_min
	mov ebx, [edi + 4 * eax]
	inc ebx
	mov [edi + 4 * eax], ebx
	inc edx
	dec ecx
	cmp ecx, 0
	jne l1

pop edi
pop esi
pop edx
pop ecx
pop ebx
pop eax
ret

first ENDP
END