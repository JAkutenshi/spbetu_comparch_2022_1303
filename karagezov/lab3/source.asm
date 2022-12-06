assume ss:my_stack, cs:my_code, ds:my_data

my_stack segment stack
  dw 12 dup('?')
my_stack ends

my_data segment

  i dw 0
  a dw 0
  b dw 0
  k dw 0

  i1 dw 0
  i2 dw 0
  res dw 0

my_data ends

my_code segment

main proc far
  push ds
  xor ax, ax
  push ax

  mov ax, my_data
  mov ds, ax

; f1 & f2
  mov ax, a
  cmp ax, b
  jg greater

less_or_equal:
  mov ax, i
  sal ax, 1  ; 2 * i
  add ax, i  ; 3 * i
  push ax
  sub ax, 2  ; 3 * i - 2
  neg ax     ; 2 - 3 * i
  mov i2, ax

  pop ax     ; 3 * i
  sal ax, 1  ; 6 * i
  sub ax, 10 ; 6 * i - 10
  mov i1, ax
  jmp end_f1_f2

greater:
  mov ax, i
  sal ax, 1  ; 2 * i
  sub ax, 2  ; 2 * i - 2
  mov i2, ax

  add ax, 2  ; 2 * i
  sal ax, 1  ; 4 * i
  add ax, 3  ; 4 * i + 3
  neg ax     ; -(4 * i + 3)
  mov i1, ax

end_f1_f2:
; f3
  mov ax, k
  cmp ax, 0
  je equal_zero

not_equal_zero:
  mov ax, i1
  cmp ax, 0
  jge greater_zero_1
  neg ax
greater_zero_1:
  mov bx, i2
  cmp bx, 0
  jge greater_zero_2
  neg bx
greater_zero_2:
  add ax, bx
  jmp end_f3

equal_zero:
  mov ax, i1
  cmp ax, 0
  jge greater_zero_3
  neg ax
greater_zero_3:
  cmp ax, 6
  jle end_f3
  mov ax, 6

end_f3:
  mov res, ax

  mov ax, i1
  mov bx, i2
  mov cx, res

  ret
main endp

my_code ends

end main
