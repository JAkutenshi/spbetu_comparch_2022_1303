.MODEL FLAT, C
.CODE

func PROC C intervals: dword, N_int: dword, N: dword, numbers: dword, final_answer: dword

    push eax
	push ebx
	push ecx
	push edi
	push esi

    mov esi, numbers
	mov edi, final_answer
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
		mov edi, final_answer
		mov ecx, [edi+4*ebx]
		inc ecx
		mov [edi+4*ebx], ecx

	next_number:
		inc eax
		cmp eax, N
		jg exit
	
jmp checking_loop
	

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