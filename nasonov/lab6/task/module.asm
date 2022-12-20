.MODEL FLAT, C
.CODE

PUBLIC C func 
func PROC C intervals: dword, interval_count: dword, number_count: dword, numbers: dword, result: dword, maxs: dword
	push esi
	push edi
	push eax
	push ebx
	push ecx
	push edx

	mov esi, numbers
	mov edi, result
	mov eax, 0

	start:
		mov ebx, [esi + 4*eax]  ; ����� ����� �� ������� ��������������� �����
		push esi
		mov ecx, interval_count	
		
		mov esi, intervals
		cmp [esi + 4*ecx], ebx  ; ��������, ��� ����� ��������� ����� ������ �������� � ����. ����.
		jl ending  ; ����� ���������� ���

		dec ecx
		border_start:
			cmp ebx, [esi + 4*ecx]  ; ��������, ��� ������ ����� >= ��������� ����� �������
			jge write_result  ; ����� ��������� � ��� ������
			dec ecx
			jmp border_start
		
		write_result:  ; ������ ����� � ������ ��� ������
			mov esi, result   
			mov ebx, [esi + 4*ecx]
			inc ebx
			mov [edi + 4*ecx], ebx

			pop esi
			push eax
			push edi

			mov edi, maxs
			mov eax, [esi + 4 * eax]
			cmp eax, [edi + 4 * ecx]
			jle ending
			mov [edi + 4 * ecx], eax

		ending:   
			pop edi
			pop eax
			inc eax
			cmp eax, number_count  ; ��������, ��� ���� ������ ����� ���������
			jne start


	pop edx
	pop ecx
	pop ebx
	pop eax
	pop edi
	pop esi
ret
func ENDP
END