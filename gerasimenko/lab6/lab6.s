.global function
#rdi - int *res_arr, rsi - int *nums_arr, rdx - int k_inter, rcx - int count_N, r8 - int *left_arrarr
function:
	lodsd
	push rcx
	mov rcx, rdx
f_interval:
	cmp eax, [r8+rcx*4-4]# сравниваем с крайней правой границой
	jge end_find
	loop f_interval
	jmp exit
end_find:
	inc dword ptr [rdi+rcx*4-4]
exit:
	pop rcx
	loop function
	ret
