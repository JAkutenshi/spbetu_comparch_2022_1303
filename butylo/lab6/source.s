.global processing_intervals

processing_intervals:
	push rax

get_data_loop:
	lodsd

	push rcx
	mov rcx, r8

	push rdi

find_interval_index_loop:
	mov edi, [rdx + rcx * 4 - 4]
	cmp eax, edi
	jge find_interval_index_end
	loop find_interval_index_loop
	xor rax, rax

find_interval_index_end:
	mov rax, rcx

	pop rdi

	pop rcx

	cmp rax, 0
	je continue_loop

	inc dword ptr [rdi + rax * 4 - 4]

continue_loop:
	loop get_data_loop

	pop rax
	ret
