.global poly

#; Input:
#; x: double  -> xmm0
#; n: int     -> rdi
#; c: double* -> rsi
poly:
  movsd xmm1, xmm0
  subsd xmm0, xmm0
  test  rdi, rdi
  jz    poly_end
  mov   rcx, rdi
horner:
   mulsd xmm0, xmm1
   addsd xmm0, [rsi + rcx * 8 - 8]
   loop  horner
poly_end:
  ret
