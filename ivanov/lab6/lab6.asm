.586p
.MODEL FLAT, C
.CODE
handleNumbers PROC C USES EDI ESI, array:dword, len:dword, leftBord:dword, n_int:dword, result:dword
	push eax
	push ebx
	push ecx
	push edi
	push esi
	mov ecx, len
	mov esi, array
	mov edi, leftBord
	mov eax, 0
lp:
	mov ebx, 0 ; ������ �������� ���������
	handle:
 		cmp ebx, n_int ; ���� ���� i < n_int
		jge after_handle ; ����� �� �����
		push eax 
		mov eax, [esi + 4 * eax] ; ������ � eax ������� �������
		cmp eax, [edi + 4 * ebx] ; ���������� ���� ������� � ������� ����� ��������
		pop eax		; ���������� eax ������� ��������
		jl after_handle ; ������� �� ����� ���� ������� ������
		inc ebx		; ������� � ����. ��������� ���� ������� ������
		jmp handle	; ��������� ���� �� ������

	after_handle:		; ����� ���������� while
		dec ebx		; ��������� ������ ��������� �� 1
		cmp ebx, -1		; �������� �� ����� �� ������� ������� ����������
		je to_next_num	; ���� ������� ��������� �� ��������� � ����. �����
		mov edi, result
		push eax
		mov eax, [edi + 4 * ebx]	; � eax �������� ������� ������� result � �������� ebx
		inc eax						
		mov [edi + 4 * ebx], eax	; ������������� ���������� �������� ������� � ������ result
		pop eax
		mov edi, leftBord			; ���������� � edi leftBord ��� ���������� ��������

	to_next_num:
		inc eax		; ��������� ������ ���������������� �����

loop lp				;����  ����������� ���� ����� �� �������� �������
pop esi
pop edi
pop ecx
pop ebx
pop eax
ret

handleNumbers ENDP
END