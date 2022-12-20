assume ss:my_stack, cs:my_code, ds:my_data

my_stack segment stack
  db 1024 dup(0)
my_stack ends

my_data segment
  int_segment dw 0
  int_offset dw 0

  msg db 'Some message', 0ah, 0dh, '$'
  int_msg db 'Interruption is done', 0ah, 0dh, '$'
  flag db 0
my_data ends

my_code segment

display_message proc near ; print message from `dx` register
  push ax

  mov  ah, 09h
  int  21h

  pop  ax
  ret
display_message endp

my_int_proc proc far
; To run procedure only once
  cmp  flag, 0
  jne  my_int_proc_end
  mov  flag, 1

  push cx
  push dx
  push ax

; Print messages
  xor  cx, cx
  mov  cx, 5
  mov  dx, offset msg

print_msg_loop:
  call display_message
  loop print_msg_loop

; Wait...
  xor  cx, cx
  mov  cx, 20
update_dx:
  mov  dx, 0ffffh
wait_loop:
  nop
  dec  dx
  cmp  dx, 0
  jne  wait_loop
  loop update_dx

; Print `end` message
  mov  dx, offset int_msg
  call display_message

  pop  ax
  pop  dx
  pop  cx

my_int_proc_end:
  mov  al, 20h
  out  20h, al

  iret
my_int_proc endp

main proc far
  push ds
  xor  ax, ax
  push ax

  mov  ax, my_data
  mov  ds, ax

; Save previous interruption info
  mov  ah, 35h
  mov  al, 08h
  int  21h
  mov  int_offset, bx
  mov  int_segment, es

; Change interruption to custom
  push ds

  mov  dx, offset my_int_proc
  mov  ax, seg my_int_proc
  mov  ds, ax

  mov  ah, 25h
  mov  al, 08h
  int 21h

  pop ds

; Wait 1 second
  xor  ax, ax
  mov  ah, 86h
  mov  cx, 0fh
  mov  dx, 4240h
  int  15h

; Restore interruption
  cli
  push ds

  mov  dx, int_offset
  mov  ax, int_segment
  mov  ds, ax

  mov  ah, 25h
  mov  al, 08h
  int  21h

  pop  ds
  sti

  ret
main endp

my_code ends

end main
