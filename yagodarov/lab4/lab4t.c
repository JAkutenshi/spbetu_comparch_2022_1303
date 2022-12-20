#include <locale.h>
#include <stdio.h>
#include <wchar.h>

#define N 81

int main() {
  setlocale(LC_CTYPE, "");

  wprintf(L"Ягодаров Михаил, гр. 1303.\nВариант 4: Преобразование всех "
          L"заглавных латинских букв в строчные, а восьмеричных цифр в "
          L"инверсные, остальныe символы исходной строки передаются в выходную "
          L"строку непосредственно.\n");

  wchar_t in[N];
  wchar_t out[N];
  int sum = 0;

  fgetws(in, N, stdin);

  asm("xor  %[sum], %[sum]          \n"
      "process_str:                 \n"
      "  xor  rax, rax              \n"
      "  lodsd                      \n"
      "  cmp  eax, 0                \n"
      "  je   end_process           \n"

      "latin_check:                 \n"
      "  cmp  eax, 65               \n"
      "  jl   oct_check             \n"
      "  cmp  eax, 90               \n"
      "  jg   process_ch            \n"
      "  add  eax, 32               \n"
      "  jmp  process_ch            \n"

      "oct_check:                   \n"
      "  cmp  eax, 48               \n"
      "  jl   process_ch            \n"
      "  cmp  eax, 55               \n"
      "  jg   process_ch            \n"
      "  neg  eax                   \n"
      "  add  eax, 103              \n"
      "  jmp  process_ch            \n"

      "process_ch:                  \n"
      "  cmp  eax, 48               \n" // '0'
      "  jl   write_ch              \n"
      "  cmp  eax, 57               \n" // '9'
      "  jg   write_ch              \n"
      "  add  %[sum], eax           \n"
      "  sub  %[sum], 48            \n"
      "write_ch:                    \n"
      "  stosd                      \n"
      "  jmp  process_str           \n"

      "end_process:                 \n"
      "  mov  eax, 0                \n"
      "  stosd                      \n"
      : [sum] "=r"(sum)
      : [in] "S"(in), [out] "D"(out)
      : "rax");

  wprintf(L"%ls\n", out);
  wprintf(L"Sum of digits is: %d\n", sum);

  return 0;
}
