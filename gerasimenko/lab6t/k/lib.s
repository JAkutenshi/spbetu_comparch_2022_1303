
.global func
#RDI - int *res, RSI - int *nums, RDX - int k, RCX - int n, R8 - int *arr, R9 - int *sums
func:
	lodsd
	push rcx
	mov rcx, rdx
find_interval:
	cmp eax, [r8+rcx*4-4]
	jge end_find
	loop find_interval
	jmp exit
end_find:
	inc dword ptr [rdi+rcx*4-4]
	add dword ptr [r9+rcx*4-4], eax
exit:
	pop rcx
	loop func
	ret
