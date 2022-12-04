.section .rodata
  newline_str:
    .string "\n"

.section .data
  input_number:
    .long -1350000000

#; Uninitialized data
.bss
  number_str:
    .space 11  #; first symbol is 8 if num < 0
    .set number_str_len, 11
  dx_ax_str:
    .space 40
    .set dx_ax_str_len, 40

.section .text

#; Input:
#; dx:ax -- number
#; Output:
#; number_str -- number to oct string
make_str:
  push rdi
  std

  xor  rcx, rcx
  mov  rdi, offset number_str
  add  rdi, 10

#; process ax
  mov  cl, 5
ax_loop:
  push ax

  and  ax, 0x7
  add  ax, '0'
  stosb

  pop  ax
  shr  ax, 3

  loop ax_loop

#; between ax and dx
  push dx

  and  dx, 0x3
  shl  dx, 1
  add  ax, dx
  add  ax, '0'
  stosb

  pop  dx
  mov  ax, dx
  shr  ax, 2

#; process dx
  mov  cl, 5
dx_loop:
  push ax

  and  ax, 0x7
  add  ax, '0'
  stosb

  pop  ax
  shr  ax, 3

  loop dx_loop

  cld
  pop  rdi

  ret

#; Input:
#; rsi -- input str
#; Output:
#; dx:ax -- number
get_number:
  push rbx
  push rcx
  xor  rdx, rdx
  xor  rbx, rbx
  xor  rcx, rcx

  mov  cx, 4
proceed_digit_dx:
  lodsb
  sub  ax, '0'
  add  dx, ax
  shl  dx, 3
  loop proceed_digit_dx

  lodsb
  sub  ax, '0'
  add  dx, ax
  shl  dx, 2

  lodsb
  sub  ax, '0'
  mov  bx, ax
  shr  ax, 1
  add  dx, ax

  mov  cx, 5
proceed_digit_ax:
  lodsb
  sub  ax, '0'
  shl  bx, 3
  add  bx, ax
  loop proceed_digit_ax

  mov  rax, rbx

  pop  rcx
  pop  rbx
  ret

invert_number:
  test ax, ax
  jz   ax_null
  dec  ax
  jmp  neg_number

ax_null:
  dec  dx

neg_number:
  xor  ax, 0xffff
  xor  dx, 0xffff

  ret

#; rdi -- string to write
display_dx_ax:
  push rdi
  push rsi
  push rdx
  push rcx

  xor  rcx, rcx

  mov  rdi, offset dx_ax_str

  push rax
  mov  cx, 4
display_dx_ax_proceed_dx_space:
  push cx
  mov  cx, 4
display_dx_ax_proceed_dx:
  rcl  dx, 1
  jc   proceed_dx_one

  mov  ax, '0'
  jmp  proceed_dx_next

proceed_dx_one:
  mov  ax, '1'

proceed_dx_next:
  stosb
  loop display_dx_ax_proceed_dx

  pop  cx
  mov  ax, ' '
  stosb

  loop display_dx_ax_proceed_dx_space
  pop  rax

  mov  dx, ax
  push rax
  mov  cx, 4
display_dx_ax_proceed_ax_space:
  push cx
  mov  cx, 4
display_dx_ax_proceed_ax:
  rcl  dx, 1
  jc   proceed_ax_one

  mov  ax, '0'
  jmp  proceed_ax_next

proceed_ax_one:
  mov  ax, '1'

proceed_ax_next:
  stosb
  loop display_dx_ax_proceed_ax

  pop  cx
  mov  ax, ' '
  stosb

  loop display_dx_ax_proceed_ax_space

  mov  rax, 1
  mov  rdi, 1
  mov  rsi, offset dx_ax_str
  mov  rdx, dx_ax_str_len
  syscall

  mov  rax, 1
  mov  rdi, 1
  mov  rsi, offset newline_str
  mov  rdx, 1
  syscall

  pop  rax

  pop  rcx
  pop  rdx
  pop  rsi
  pop  rdi
  ret

.global  _start
_start:
#; Insert number
  mov  edx, input_number

  mov  ax, dx
  shr  edx, 16

#; Display dx:ax registers
  call display_dx_ax

#; Remove sign
  rcl  dx, 1
  jnc  positive
  rcr  dx, 1
  call invert_number
  jmp  make_number_str

positive:
  shr  dx, 1

make_number_str:
  call make_str

#; Print oct number
  mov  rax, 1
  mov  rdi, 1
  mov  rsi, offset number_str
  mov  rdx, number_str_len
  syscall

#; Print new line
  mov  rax, 1
  mov  rdi, 1
  mov  rsi, offset newline_str
  mov  rdx, 1
  syscall

#; Get value from str to dx:ax
  mov  rsi, offset number_str
  call get_number

#; Display dx:ax registers
  call display_dx_ax

#; Print new line
  mov  rax, 1
  mov  rdi, 1
  mov  rsi, offset newline_str
  mov  rdx, 1
  syscall

#; Insert number
  mov  edx, input_number

  mov  ax, dx
  shr  edx, 16

#; Display dx:ax registers
  call display_dx_ax

  call make_str

#; Print oct number
  mov  rax, 1
  mov  rdi, 1
  mov  rsi, offset number_str
  mov  rdx, number_str_len
  syscall

#; Print new line
  mov  rax, 1
  mov  rdi, 1
  mov  rsi, offset newline_str
  mov  rdx, 1
  syscall

#; Get value from str to dx:ax
  mov  rsi, offset number_str
  call get_number

#; Display dx:ax registers
  call display_dx_ax

#; Exit
  mov  rax, 60
  mov  rdi, 0
  syscall
