.586p
.MODEL FLAT, C
.CODE
function PROC C USES EDI ESI, array:dword, len:dword, leftBord:dword, n_int:dword, result:dword, mins:dword

	push eax
	push ebx
	push ecx
	push edi
	push esi


	mov ecx, len
	mov esi, array
	mov edi, leftBord
	mov eax, 0

lp:
	mov ebx, 0 ; индекс текущего интервала
	iter:
 		cmp ebx, n_int ; while (i < n_int)
		jge out_iter ; если текущий индекс больше максимального, выходим из цикла

		push eax 
		mov eax, [esi + 4 * eax] ; кладем в eax элемент массива array
		cmp eax, [edi + 4 * ebx] ; сравниваем этот элемент с текущей левой границей
		pop eax		;возвращаем eax нулевое значение
		jl out_iter ; если элемент меньше, то выходим из цикла
		inc ebx		; если больше, то переходим к следующему интервалу
		jmp iter	;повторяем цикл до тех пор пока принудительно не выйдем из него

	out_iter:		;когда вышли из цикла
		dec ebx		;уменьшаем индекс интервала на 1

		cmp ebx, -1		;проверяем что мы не вышли за пределы массива интервалов
		je to_next_num	;если вышли - переходим к следующему числу
		mov edi, result
		push eax
		mov eax, [edi + 4 * ebx]	;в eax помещаем элемент массива result с индексом ebx
		inc eax						;увеличиваем его на 1
		mov [edi + 4 * ebx], eax	;устанавливаем полученное значение обратно в массив result
		pop eax

		push ebx					;	индекс текущего интервала		
		push eax					;	индекс текущего числа
		
		mov eax, [esi + 4 * eax]	;	в eax кладем число текущее
		push edi
		mov edi, mins
		cmp eax, [edi + 4 * ebx]	;	сравниваем число с минимумом
		jge not_change
		mov [edi + ebx], eax
		not_change:
		pop edi
		pop eax
		pop ebx
		
		mov edi, leftBord			;возвращаем в edi leftBord для дальнейших итераций

	to_next_num:
		inc eax		;увеливаем индекс рассматриваемого числа

loop lp				;начинаем новую итерацию. Каждый раз ecx (в котором хранится длина массива) уменьшается на 1
					;цикл  выполняется пока длина не окажется нулевой

pop esi
pop edi
pop ecx
pop ebx
pop eax

ret

function ENDP
END