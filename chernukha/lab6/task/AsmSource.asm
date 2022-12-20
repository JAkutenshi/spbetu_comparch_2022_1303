.586p
.MODEL FLAT, C
.CODE
numcount PROC C USES EDI ESI, arr:dword, NumsRat:dword, arrLGrInt:dword, NInt:dword, res:dword, resnech:dword

push eax
push ebx
push ecx
push edi
push esi

mov esi, arr
mov ecx, NumsRat
mov edi, arrLGrInt
mov eax, 0

	mov ecx, NumsRat	
	check:
		dec ecx
		mov eax, 0
		cmp ecx, -1
		je endprog
		mov ebx, [esi + 4*ecx]; new num
	   check2:
		cmp eax, NInt
		je check
		
		cmp ebx, [edi + 4*eax] ; new left border 
        jge checkjg 

		inc eax
		jmp check2

		checkjg:
        inc eax
		cmp eax, NInt;-1 ;if -1
		je count

		cmp ebx, [edi + 4*eax];	
		jl count
     	jmp check2

		count:
		push ebx
		push edi
		mov edi, res
		dec eax
		mov ebx, [edi + 4 * eax]
		inc ebx
		mov [edi + 4 * eax], ebx
		pop edi
		pop ebx
		push ebx
		push edi
		test ebx,1
		jz check
		mov edi, resnech
		mov ebx, [edi + 4 * eax]
		inc ebx
		mov [edi + 4 * eax], ebx
		pop edi
		pop ebx

		jmp check

		endprog:
pop esi
pop edi
pop ecx
pop ebx
pop eax

ret

numcount ENDP
END

