.586p
.MODEL FLAT, C
.CODE
function PROC C USES EDI ESI, Digits:dword, len:dword, LBInt:dword, NInt:dword, result:dword

	push eax
	push ebx
	push ecx
	push edi
	push esi

	mov ecx, len
	mov esi, Digits
	mov edi, LBInt
	mov eax, 0
 
cycle:
        mov ebx, 0
	iter:
 		cmp ebx, NInt
		jge out_iter
		push eax 
		mov eax, [esi + 4 * eax]
		cmp eax, [edi + 4 * ebx]
		pop eax
		jl out_iter
		inc ebx
		jmp iter

	out_iter:
		dec ebx
		cmp ebx, -1
		je next_num
		mov edi, result
		push eax
		mov eax, [edi + 4 * ebx]
		inc eax
		mov [edi + 4 * ebx], eax
		pop eax
		mov edi, LBInt

	next_num:
		inc eax

loop cycle

pop esi
pop edi
pop ecx
pop ebx
pop eax

ret

function ENDP
END