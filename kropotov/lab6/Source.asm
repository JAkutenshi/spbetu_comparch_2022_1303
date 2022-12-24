.MODEL FLAT, C
.CODE

firstFunc PROC C numCount: dword, tempResSize: dword, numbers: dword, tempIntervals: dword, tempRes: dword

	push esi
	push edi
	push eax
	push ebx
	push ecx
	push edx

	mov ecx, numCount
	mov esi, numbers
	mov edi, tempIntervals
	mov eax, 0
	mov edx, tempResSize
	inc edx
	lp:
		mov ebx, 0
		check_num:
			cmp ebx, edx
			jge next_num
			push eax
			mov eax, [esi + eax * 4]
			cmp eax, [edi + ebx * 4]
			pop eax
			jl right_num
			inc ebx
			jmp check_num
		right_num:
			dec ebx
			cmp ebx, -1
			je next_num
			mov esi, tempRes
			push eax
			mov eax, [esi + ebx * 4]
			inc eax
			mov [esi + ebx * 4], eax
			pop eax
			mov esi, numbers
		next_num:
			inc eax
	loop lp

	finish:
	pop edx
	pop ecx
	pop ebx
	pop eax
	pop edi
	pop esi
	ret

firstFunc ENDP



secondFunc PROC C tempResSize: dword, intCount: dword, tempRes: dword, tempIntervals: dword, intervals: dword, res: dword
	
	push esi
	push edi
	push eax
	push ebx
	push ecx
	push edx

	mov ecx, tempResSize
	mov esi, tempIntervals
	mov edi, intervals
	mov eax, 0
	mov edx, intCount
	inc edx
	lp:
		mov ebx, 0
		check_int:
			cmp ebx, edx
			jge next_int
			push eax
			mov eax, [esi + eax * 4]
			cmp eax, [edi + ebx * 4]
			pop eax
			jl right_int
			inc ebx
			jmp check_int
		right_int:
			dec ebx
			cmp ebx, -1
			je next_int
			mov esi, tempRes
			push eax
			mov eax, [esi + eax * 4]
			mov esi, res
			push ecx
			mov ecx, [esi + ebx * 4]
			add ecx, eax
			mov [esi + ebx * 4], ecx
			pop ecx
			pop eax
			mov esi, tempIntervals
		next_int:
			inc eax
	loop lp

	finish:
	pop edx
	pop ecx
	pop ebx
	pop eax
	pop edi
	pop esi
	ret

secondFunc ENDP
END
