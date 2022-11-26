.global process_data

#; Input:
#; rdx --> int *borders_array
#; rcx --> int borders_number
#; rax --> int number
#; Output:
#; rax --> int interval_index + 1
#; rax = 0 --> not in interval
find_interval_index:

find_interval_index_loop:
  cmp  eax, [rdx + rcx * 4 - 4]
  jge  find_interval_index_end
  loop find_interval_index_loop

find_interval_index_end:
  mov  rax, rcx

  ret

#; Input:
#; rdi --> int *result_array  (qword)
#; rsi --> int *source_array  (qword)
#; rdx --> int *borders_array (qword)
#; rcx --> int count          (dword)
#; r8  --> int borders_number (dword)
process_data:
  push rax

process_data_loop:
  lodsd

  push rcx
  mov  rcx, r8
  call find_interval_index
  pop  rcx

  test rax, rax
  jz   continue_loop

  inc dword ptr [rdi + rax * 4 - 4]

continue_loop:
  loop process_data_loop

  pop  rax
	ret
