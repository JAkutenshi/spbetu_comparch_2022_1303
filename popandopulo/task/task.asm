.586p
.MODEL FLAT, C
.CODE
process_hits PROC C USES EDI ESI, array:dword, len:dword, LBorders:dword, NInt:dword, hits:dword, maximums:dword
	push eax
	push ebx
	push ecx
	push edi
	push esi

	mov ecx, len
	mov esi, array
	mov edi, LBorders
	mov eax, 0

process:
	mov ebx, 0
	intervals_cycle:
 		cmp ebx, NInt
		jge over_interval; 
		push eax 
		mov eax, [esi + 4*eax] 
		cmp eax, [edi + 4*ebx]
		pop eax
		jl over_interval
		inc ebx
		jmp intervals_cycle

	over_interval:
		dec ebx
		cmp ebx, -1
		je next_num
		mov edi, hits
		push eax
		mov eax, [edi + 4*ebx]
		inc eax
		mov [edi + 4*ebx], eax
		pop eax

		push eax
		push edi
		mov edi, maximums
		mov eax, [esi + 4*eax]
		cmp [edi + 4*ebx], eax
		jge less
		mov [edi + 4*ebx], eax
		less:
		pop edi
		pop eax

		mov edi, LBorders
	next_num:
		inc eax

loop process

pop esi
pop edi
pop ecx
pop ebx
pop eax

ret
process_hits ENDP
END