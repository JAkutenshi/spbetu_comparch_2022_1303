.MODEL FLAT, C
.CODE

f PROC C inter: dword, num: dword, answer: dword, N_int: dword, N: dword

    push eax
	push ebx
	push ecx
	push edi
	push esi

	mov eax, 0
    mov esi, num
    

c_loop:
	mov ebx, 0
	iter:
		cmp ebx, N_int
		jge out_cur_iter
		mov ecx, [esi + 4*eax]
		mov edi, inter
		cmp ecx, [edi + 4*ebx]
		jl out_cur_iter
		inc ebx
		jmp iter

	out_cur_iter:
		dec ebx
		mov edi, answer
		mov ecx, [edi + 4*ebx]
		inc ecx
		mov [edi + 4*ebx], ecx

	next_number:
		inc eax
		cmp eax, N
		jg exit
	
jmp c_loop


exit:
    pop edx
	pop ecx
	pop ebx
	pop eax
	pop edi
	pop esi
ret
f ENDP
END