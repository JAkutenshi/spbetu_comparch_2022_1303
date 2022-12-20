.586p
.MODEL FLAT, C
.CODE
function PROC C USES EDI ESI, array:dword, len:dword, LGrInt:dword, NInt:dword, result:dword

	push eax
	push ebx
	push ecx
	push edi
	push esi


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
		cmp eax, [edi + 4 * ebx] ; сравниваем элемент массива array с левой границей
		pop eax
		jl out_iter ; если меньше, то выходим в out_iter
		inc ebx ; если больше, то переходим на следующий интервал
		jmp iter

	out_iter:
		dec ebx ; уменьшаем номер интервала на 1

		cmp ebx, -1
		je to_next_num
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

pop esi
pop edi
pop ecx
pop ebx
pop eax

ret

function ENDP
END
