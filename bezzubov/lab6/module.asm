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
	mov eax,0
    

checking_loop:
    
    mov ebx, [esi+4*eax]

    push esi
    mov ecx, 1

    mov esi, intervals

new_inter:
    cmp ebx, [esi + 4*ecx]
    jge next_inter

    sub ecx, 1
    
    push ebx
    mov ebx, [edi + 4*ecx]
    inc ebx
    mov [edi + 4*ecx], ebx
    pop ebx

    inc eax
    cmp eax, N
    pop esi
    jl checking_loop
    jmp exit

next_inter:
    inc ecx
    cmp ecx, N_int
    jle new_inter
    inc eax
    pop esi
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
