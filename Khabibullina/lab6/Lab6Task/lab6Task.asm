.586p
.MODEL FLAT, C
.CODE
function PROC C USES EDI ESI, array:dword, len:dword, LGrInt:dword, NInt:dword, answer:dword, ENum:dword

	push eax
	push ebx
	push ecx
	push edi
	push esi

	mov ecx, len
	mov esi, array
	mov edi, LGrInt
	mov eax, 0

loop_:
	mov ebx, 0
	border_count:
 		cmp ebx, NInt
		jge out_border

		push eax
		mov eax, [esi + 4 * eax]
		cmp eax, [edi + 4 * ebx]
		pop eax
		jl out_border
		inc ebx
		jmp border_count

	out_border:
		dec ebx

		cmp ebx, -1
		je next
		mov edi, answer
		push eax
		mov eax, [edi + 4 * ebx]
		inc eax
		mov [edi + 4 * ebx], eax
		pop eax
		push eax
		mov edi, ENum
		mov eax, [esi + 4 * eax]
		test eax,1
		jnz check
		mov eax, [edi+4*ebx]
		inc eax
		mov [edi+4*ebx], eax
		mov edi, LGrInt
	check:
		pop eax
		mov edi, LGrInt

	next:
		inc eax

loop loop_

pop esi
pop edi
pop ecx
pop ebx
pop eax

ret

function ENDP
END