.MODEL FLAT, C
.CODE

PUBLIC C func 
func PROC C intervals: dword, N_int: dword, N: dword, numbers: dword, final_answer: dword
	push esi
	push edi
	push eax
	push ebx
	push ecx
	push edx

	mov esi, numbers
	mov edi, final_answer
	mov eax,0

	begin:
		mov ebx,[esi + 4*eax]	;����� ������� ����� �� ������� ��������������� �����
		push esi
		mov ecx, N_int
							
		mov esi, intervals
		cmp [esi + 4*ecx],ebx   ;�������� �� ��, ��� ����� ��������� ����� ������ �������� � Xmax
		jl ending               ;� ������ ���� ��� ��� - ���������� ���
		dec ecx
		border_begin:
			cmp ebx, [esi + 4*ecx]  ;�������� �� �� ���, ������ ����� ������ ��������� ����� �������
			jge print_result	;� ������ ���� ��� ��� -  ��������� � ��� ������
			dec ecx
			jmp border_begin
		
		print_result:           ;������ ����� � ������ ������
			mov esi,final_answer   
			mov ebx,[esi + 4*ecx]
			inc ebx
			mov [edi + 4*ecx], ebx

		ending:                  
			pop esi
			inc eax
			cmp eax,N			 ;�������� �� �� ���, ���� ������ ����� ���������	
			jne begin


	pop edx
	pop ecx
	pop ebx
	pop eax
	pop edi
	pop esi
ret
func ENDP
END 