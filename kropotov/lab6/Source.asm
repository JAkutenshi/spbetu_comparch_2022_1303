.MODEL FLAT, C
.CODE

func PROC C n: dword, nInt: dword, nums: dword, intervals: dword, res: dword

	push esi
	push edi
	push eax
	push ebx
	push ecx
	push edx

	mov ecx, n
	mov esi, nums
	mov edi, intervals
	mov eax, 0
	mov edx, nInt
	inc edx
	cycle:
		mov ebx, 0
		check:
			cmp ebx, edx
			jge next
			push eax
			mov eax, [esi + eax * 4]
			cmp eax, [edi + ebx * 4]
			pop eax
			jl right_num
			inc ebx
			jmp check
		right_num:
			dec ebx
			cmp ebx, -1
			je next
			mov esi, res
			push eax
			mov eax, [esi + ebx * 4]
			inc eax
			mov [esi + ebx * 4], eax
			pop eax
			mov esi, nums
		next:
			inc eax
	loop cycle

	finish:
	pop edx
	pop ecx
	pop ebx
	pop eax
	pop edi
	pop esi
	ret

func ENDP
END
