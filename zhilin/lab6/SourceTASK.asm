.MODEL FLAT, C
.CODE

func PROC C n: dword, nInt: dword, nums: dword, intervals: dword, res: dword

	push esi
	push edi
	push eax
	push ebx
	push ecx
	push edx

	mov ecx, nInt
	mov esi, nums
	mov edi, intervals
	mov eax, 0
	mov edx, -32768
	cycle:
		mov ebx, 0
		check:
			push ebx
			mov ebx, [esi + ebx * 4]
			push ecx
			neg ecx
			add ecx, nInt
			inc ecx
			cmp ebx, [edi + ecx * 4]
			pop ecx
			pop ebx
			jl second_check
			inc ebx
			cmp ebx, n
			jl check
			jmp end_it

		second_check:
			cmp edx, [esi + ebx * 4]
			jge skip_add
			mov edx, [esi + ebx * 4]
		skip_add:
			inc ebx
			cmp ebx, n
			jl check

		end_it:
			push ecx
			neg ecx
			add ecx, nInt
			inc ecx
			mov esi, res
			dec ecx
			mov [esi + ecx * 4], edx
			mov esi, nums
			pop ecx
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
