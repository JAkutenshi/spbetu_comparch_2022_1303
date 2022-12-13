.586p
.MODEL FLAT, C
.CODE
handleNumbers PROC C USES EDI ESI, array:dword, len:dword, leftBord:dword, n_int:dword, result:dword
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
	handle:
 		cmp ebx, n_int ; цикл пока i < n_int
		jge after_handle ; выход из цикла
		push eax 
		mov eax, [esi + 4 * eax] ; кладем в eax элемент массива
		cmp eax, [edi + 4 * ebx] ; сравниваем этот элемент с текущей левой границей
		pop eax		; возвращаем eax нулевое значение
		jl after_handle ; выходим из цикла если элемент меньше
		inc ebx		; переход к след. интервалу если элемент больше
		jmp handle	; повторяем пока не выйдем

	after_handle:		; после завершения while
		dec ebx		; уменьшаем индекс интервала на 1
		cmp ebx, -1		; проверка на выход за пределы массива интервалов
		je to_next_num	; если условие сработало то переходим к след. числу
		mov edi, result
		push eax
		mov eax, [edi + 4 * ebx]	; в eax помещаем элемент массива result с индексом ebx
		inc eax						
		mov [edi + 4 * ebx], eax	; устанавливаем полученное значение обратно в массив result
		pop eax
		mov edi, leftBord			; возвращаем в edi leftBord для дальнейших итераций

	to_next_num:
		inc eax		; увеливаем индекс рассматриваемого числа

loop lp				;цикл  выполняется пока длина не окажется нулевой
pop esi
pop edi
pop ecx
pop ebx
pop eax
ret

handleNumbers ENDP
END