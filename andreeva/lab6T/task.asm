.586p
.MODEL FLAT, C
.CODE
function PROC C USES EDI ESI, array:dword, len:dword, LGrInt:dword, NInt:dword, result:dword, even_num:dword

	push eax
	push ebx
	push ecx
	push edi
	push esi
	push edx


	mov ecx, len
	mov esi, array
	mov edi, LGrInt
	mov eax, 0

lp:
	mov ebx, 0 ; количество пройденных интервалов
	iter:
 		cmp ebx, NInt
		jge out_iter ; если количество пройденных интервалов больше, чем NInt, то выходим в out_iter

		push eax 
		
		mov eax, [esi + 4 * eax] ; в eax элемент массива array
		
		xor edx, edx
		mov edx, eax
		
		cmp eax, [edi + 4 * ebx] ; сравниваем элемент массива array с левой границей
		pop eax
		jl out_iter ; если меньше, то выходим в out_iter
		inc ebx ; если больше, то переходим на следующий интервал
		jmp iter

	out_iter:
		dec ebx ; уменьшаем номер интервала на 1

		cmp ebx, -1
		je to_next_num
		
		;bt edx, 1
		;jc odd


		test edx,1
		jnz odd
		
		push edi
		mov edx, even_num
		xor edi, edi
		mov edi, [edx + 4 * ebx]
		inc edi
		mov [edx + 4 * ebx], edi
		pop edi
		
		
	odd:
		mov edi, result
		push eax
		mov eax, [edi + 4 * ebx] ; в eax помещаем элемент массива result с номером ebx
		inc eax ; увеличиваем этот элемент на 1
		mov [edi + 4 * ebx], eax
		pop eax
		mov edi, LGrInt

	to_next_num:
		inc eax

loop lp

push edx
pop esi
pop edi
pop ecx
pop ebx
pop eax

ret

function ENDP
END
