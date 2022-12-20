.MODEL FLAT, C
.CODE

PUBLIC C func 
func PROC C intervals: dword, interval_count: dword, number_count: dword, numbers: dword, result: dword
	push esi
	push edi
	push eax
	push ebx
	push ecx
	push edx

	mov esi, numbers
	mov edi, result
	mov eax, 0

	start:
		mov ebx, [esi + 4*eax]  ; берем число из массива сгенерированных чисел
		push esi
		mov ecx, interval_count	
		
		mov esi, intervals
		cmp [esi], ebx
		jg ending

		dec ecx
		border_start:
			cmp ebx, [esi + 4*ecx]  ; проверка, что взятое число >= следующей левой границы
			jge write_result  ; тогда переходим к его записи
			dec ecx
			jmp border_start
		
		write_result:  ; запись числа в массив для вывода
			mov esi, result   
			mov ebx, [esi + 4*ecx]
			inc ebx
			mov [edi + 4*ecx], ebx

		ending:                  
			pop esi
			inc eax
			cmp eax, number_count  ; проверка, что весь массив чисел обработан
			jne start


	pop edx
	pop ecx
	pop ebx
	pop eax
	pop edi
	pop esi
ret
func ENDP
END