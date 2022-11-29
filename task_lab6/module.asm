.MODEL FLAT, C
.CODE

PUBLIC C func 
func PROC C intervals: dword, N_int: dword, N: dword, numbers: dword, final_answer:dword, sum: dword, average_answer:dword
	push esi
	push edi
	push eax
	push ebx
	push ecx
	push edx

	mov esi, numbers
	mov edi, final_answer
	mov eax,0

	begin:
		mov ebx,[esi + 4*eax]	;берем текущее число из массива сгенерированных чисел
		push esi
		mov ecx, N_int
							
		mov esi, intervals
		cmp [esi + 4*ecx],ebx   ;проверка на то, что число находится между правой границей и Xmax
		jl ending               ;в случае если это так - пропускаем его
		dec ecx
		border_begin:
			cmp ebx, [esi + 4*ecx]  ;проверка на то что, взятое число больше следующей левой границы
			jge print_result	;в случае если это так -  переходим к его записи
			dec ecx
			jmp border_begin
		
		print_result:           ;запись числа в массив вывода

			push esi            ;Подготовка массива сумм на интервалах
			push eax
			mov esi, sum
			mov eax,[esi +4*ecx]
			add eax,ebx
			mov [esi + 4*ecx],eax
			pop eax
			pop esi

			mov esi,final_answer   
			mov ebx,[esi + 4*ecx]
			inc ebx
			mov [edi + 4*ecx], ebx
			

		ending:                  
			pop esi
			inc eax
			cmp eax,N			 ;проверка на то что, весь массив чисел обработан	
			jne begin

	;Задание

	mov esi,sum
	mov edi,final_answer
	sub ecx,ecx
	

	average_begin:
		sub edx,edx

		mov eax,[esi + 4*ecx]
		mov ebx,[edi + 4*ecx]
		cmp ebx,0
		je average_ending
		cmp eax, 0
		jl lower_zero
		jmp higher_zero

		lower_zero:
			neg eax
			div ebx
			neg eax
			jmp write_average
		
		higher_zero:
			div ebx

		write_average:	
			push esi
			mov esi,average_answer
			mov [esi + 4*ecx],eax
			pop esi
			jmp all_ending

		average_ending:
			mov eax,0
			push esi
			mov esi,average_answer
			mov [esi + 4*ecx],eax
			pop esi

		all_ending:
			inc ecx
			cmp ecx,N_int
			jne average_begin

	;Конец задания


	pop edx
	pop ecx
	pop ebx
	pop eax
	pop edi
	pop esi
ret
func ENDP
END 
