#include <locale.h>
#include <stdio.h>
#include <wchar.h>

#define N 81

int main() {
  setlocale(LC_CTYPE, "");

  wprintf(
      L"Мусатов Дмитрий, гр. 1303.\nВариант 4: Преобразование всех заглавных "
      L"латинских букв в строчные, а восьмеричных цифр в инверсные, остальные "
      L"символы исходной строки передаются в выходную строку непосредственно.");

  wchar_t in[N];
  wchar_t out[N];

  fgetws(in, N, stdin);

  asm("process_str:                 \n"
      "  xor  rax, rax              \n"
      "  lodsd                      \n"
      "  cmp  eax, 0                \n"
      "  je   end_process           \n"

      "latin_check:                 \n"
      "  cmp  eax, 65               \n"
      "  jl   oct_check             \n"
      "  cmp  eax, 90               \n"
      "  jg   write_ch              \n"
      "  add  eax, 32               \n"
      "  jmp  write_ch              \n"

      "oct_check:                   \n"
      "  cmp  eax, 48               \n"
      "  jl   write_ch              \n"
      "  cmp  eax, 55               \n"
      "  jg   write_ch              \n"
      "  neg  eax                   \n"
      "  add  eax, 103              \n"
      "  jmp  write_ch              \n"

      "write_ch:                    \n"
      "  stosd                      \n"
      "  jmp  process_str           \n"

      "end_process:                 \n"
      "  mov  eax, 0                \n"
      "  stosd                      \n"
      :
      : [in] "S"(in), [out] "D"(out)
      : "rax");

  wprintf(L"%ls", out);

  return 0;
}
