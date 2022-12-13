#include <locale.h>
#include <stdio.h>
#include <wchar.h>

#define N 81

int main() {
  setlocale(LC_CTYPE, "");

  wprintf(L"Карагезов Савелий, гр. 1303.\nВариант 4:  Преобразование введенных "
          L"во входной строке десятичных цифр в двоичную СС, остальные символы "
          L"входной строки передаются в выходную строку непосредственно.\n");

  wchar_t in[4 * N];
  wchar_t out[N];
  int count = 0;

  fgetws(in, N, stdin);

  asm("xor  %[cnt], %[cnt]          \n"
      "process_str:                 \n"
      "  xor  rax, rax              \n"
      "  lodsd                      \n"
      "  cmp  eax, 0                \n"
      "  je   end_process           \n"

      "process_ch:                  \n"
      "  cmp  eax, 48               \n" // '0'
      "  jl   write_ch              \n"
      "  cmp  eax, 57               \n" // '9'
      "  jg   write_ch              \n"
      "  mov  rdx, rax              \n"
      "  sub  edx, 48               \n"
      "  mov  rcx, 4                \n"
      "  sal  dl, 4                 \n"
      "print_bin:                   \n"
      "  mov  eax, 48               \n"
      "  rcl  dl, 1                 \n"
      "  jnc  zero_ch               \n"
      "  add  eax, 1                \n"
      "  jmp  not_zero_ch           \n"
      "zero_ch:                     \n"
      "  inc  %[cnt]                \n"
      "not_zero_ch:                 \n"
      "  stosd                      \n"
      "  loop print_bin             \n"
      "  jmp  process_str           \n"

      "write_ch:                    \n"
      "  stosd                      \n"
      "  jmp  process_str           \n"

      "end_process:                 \n"
      "  mov  eax, 0                \n"
      "  stosd                      \n"
      : [cnt] "+r"(count)
      : [in] "S"(in), [out] "D"(out)
      : "rax", "rcx", "rdx");

  wprintf(L"%ls\n", out);
  wprintf(L"%d\n", count);

  return 0;
}
