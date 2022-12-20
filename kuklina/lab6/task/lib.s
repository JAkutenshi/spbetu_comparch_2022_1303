.global f

find:

find_loop:
	cmp  eax, [rdx + rcx * 4 - 4]
	jge  find_end
	loop find_loop

find_end:
	cmp eax, [r9 + rcx * 4 - 4]
	jge greater
	mov dword ptr [r9 + rcx * 4 - 4], eax
greater:
	mov rax, rcx

	ret

f:
	push rax

f_loop:
	lodsd

	push rcx
	mov  rcx, r8
	mov r10, rax
	call find
	pop  rcx

	cmp rax, 0
	je  continue_loop

	incd [rdi + rax * 4 - 4]

continue_loop:
	loop f_loop

	pop rax
	ret
