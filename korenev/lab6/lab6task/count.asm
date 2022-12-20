.586p
.MODEL FLAT, C
.CODE
countNumbers PROC C USES EDI ESI, array:dword, totalNumbers:dword, arrayLGrInt:dword, totalNInt:dword, result:dword

push eax
push ebx
push ecx
push edi
push esi

mov esi, array
mov ecx, totalNumbers
mov edi, arrayLGrInt
mov eax, 0

run: 
	mov ebx, 0
	next_border:
 		cmp ebx, totalNInt
		jge previous_border
		push eax
		mov eax, [esi + 4 * eax]
		cmp eax, [edi + 4 * ebx]
		pop eax
		jl previous_border
		inc ebx
		jmp next_border

	previous_border:
		dec ebx
		cmp ebx, -1
		je next_num
		mov edi, result
		push eax
		mov eax, [edi + 4 * ebx]
		inc eax
		mov [edi + 4 * ebx], eax
		pop eax
		mov edi, arrayLGrInt

	next_num:
		inc eax

loop run

pop esi
pop edi
pop ecx
pop ebx
pop eax

ret

countNumbers ENDP
END