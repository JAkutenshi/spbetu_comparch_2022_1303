.global poly

#; Input:
#; x: double  -> xmm0
#; n: int     -> rdi
#; c: double* -> rsi
#; Output:
#; rax
poly:
  movq  rax, xmm0
  push  rax
  fld qword ptr [rsp]
  fldz
  test  rdi, rdi
  jz    poly_end
  mov   rcx, rdi
horner:
    fmul  st(1)
    fadd qword ptr [rsi + rcx * 8 - 8]
    loop  horner
poly_end:
  fstp qword ptr [rsp]
  pop   rax
  movq  xmm0, rax
  ret
