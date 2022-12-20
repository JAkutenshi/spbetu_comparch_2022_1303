.MODEL FLAT, C
.CODE

func PROC C intervals: dword, N_int: dword, N: dword, numbers: dword, final_answer: dword,	average_answer: dword, sum:dword

    push eax
	push ebx
	push ecx
	push edi
	push esi

    mov esi, numbers
	mov edi, final_answer
	mov edx, sum
	mov eax, 0
    

checking_loop:
	mov ebx, 0
	iter:
		cmp ebx, N_int
		jge out_cur_iter
		mov ecx, [esi + 4*eax]
		mov edi, intervals
		cmp ecx, [edi+4*ebx]
		jl out_cur_iter
		inc ebx
		jmp iter

	out_cur_iter:
		dec ebx
		add [edx+4*ebx], ecx
		mov edi, final_answer
		mov ecx, [edi+4*ebx]
		inc ecx
		mov [edi+4*ebx], ecx
		

	next_number:
		inc eax
		cmp eax, N
		jg cont
	
jmp checking_loop

cont:

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

exit:
    pop edx
	pop ecx
	pop ebx
	pop eax
	pop edi
	pop esi
ret
func ENDP
END
