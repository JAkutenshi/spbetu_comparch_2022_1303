#include <locale.h>
#include <stdio.h>
#include <stdlib.h>
#include <wchar.h>

#define N 81

int main() {
  setlocale(LC_CTYPE, "");

  wchar_t *translit = L"a\0" // А
                      L"b\0" // Б
                      L"v\0" // В
                      L"g\0" // Г
                      L"d\0" // Д
                      L"e\0" // Е
                      L"zh"  // Ж
                      L"z\0" // З
                      L"i\0" // И
                      L"i\0" // Й
                      L"k\0" // К
                      L"l\0" // Л
                      L"m\0" // М
                      L"n\0" // Н
                      L"o\0" // О
                      L"p\0" // П
                      L"r\0" // Р
                      L"s\0" // С
                      L"t\0" // Т
                      L"u\0" // У
                      L"f\0" // Ф
                      L"kh"  // Х
                      L"ts"  // Ц
                      L"ch"  // Ч
                      L"sh"  // Ш
                      L"\0\0"// Щ
                      L"ie"  // Ъ
                      L"y\0" // Ы
                      L"\0\0"// Ь
                      L"e\0" // Э
                      L"iu"  // Ю
                      L"ia"; // Я

  wchar_t str[N];
  wchar_t out[N * 4] = {};

  fgetws(str, N, stdin);

  asm("process_str:              \n" // Loop of string processing
      "  xor  rax, rax           \n"
      "  lodsd                   \n"
      "  cmp  eax, 0             \n" // Check if input string ends
      "  je   end_process        \n"

      "  cmp  eax, 1105          \n" // ё
      "  je   e_lower            \n"
      "  cmp  eax, 1025          \n" // Ё
      "  je   e_upper            \n"
      "  cmp  eax, 1097          \n" // щ
      "  je   chsh_lower         \n"
      "  cmp  eax, 1065          \n" // Щ
      "  je   chsh_upper         \n"

      "ru_lower_check:           \n" // Check if letter is ru and in lower case
      "  cmp  eax, 1072          \n" // 'а'
      "  jl   ru_upper_check     \n"
      "  cmp  eax, 1103          \n" // 'я'
      "  jg   write_ch           \n" 
      "  jmp  transliterate_lowercase \n" 

      "ru_upper_check:           \n" // Check if letter is ru and in UPPER case
      "  cmp  eax, 1040          \n" // 'А'
      "  jl   write_ch           \n" 
      "  cmp  eax, 1071          \n" // 'Я'
      "  jg   write_ch           \n"
      "  jmp  transliterate_uppercase \n" 

      "write_ch:                 \n" // Write letter to outer string
      "  stosd                   \n"
      "  jmp  process_str        \n"

      "e_lower:                  \n"
      "  mov  eax, 101           \n"
      "  jmp  write_ch           \n"

      "e_upper:                  \n"
      "  mov  eax, 69            \n"
      "  jmp  write_ch           \n"

      "chsh_lower:               \n"
      "  mov  eax, 115           \n"
      "  stosd                   \n"
      "  mov  eax, 104           \n"
      "  stosd                   \n"
      "  mov  eax, 99            \n"
      "  stosd                   \n"
      "  mov  eax, 104           \n"
      "  stosd                   \n"
      "  jmp  process_str        \n"

      "chsh_upper:               \n"
      "  mov  eax, 83            \n"
      "  stosd                   \n"
      "  mov  eax, 104           \n"
      "  stosd                   \n"
      "  mov  eax, 99            \n"
      "  stosd                   \n"
      "  mov  eax, 104           \n"
      "  stosd                   \n"
      "  jmp  process_str        \n"

      "transliterate_uppercase:  \n"
      "  sub  eax, 1040          \n" 
      "  xor  rcx, rcx           \n"
      "  mov  ecx, eax           \n"
      "  shl  ecx, 3             \n" // Multyply index by 2 plus size of wchar_t (4)
      "  mov  eax, [%[translit] + rcx]    \n" // Get letter from 'dictionary'
      "  cmp  eax, 0             \n" // Check if letter exists
      "  je   trans_upper_exit   \n" // If not --> goto exit
      "  sub  eax, 32            \n" // Make letter UPPER case
      "  stosd                   \n"
      "  add  rcx, 4             \n"
      "  mov  eax, [%[translit] + rcx]    \n" // Write second char of transliteration
      "  cmp  eax, 0             \n" // Check if it exists
      "  je   trans_upper_exit   \n" 
      "  stosd                   \n"
      "trans_upper_exit:         \n" // Exit of transliteration
      "  jmp  process_str        \n" 

      "transliterate_lowercase:  \n"
      "  sub  eax, 1072          \n"
      "  xor  rcx, rcx           \n"
      "  mov  ecx, eax           \n"
      "  shl  ecx, 3             \n"
      "  mov  eax, [%[translit] + rcx]   \n"
      "  cmp  eax, 0             \n"
      "  je   trans_lower_exit   \n"
      "  stosd                   \n"
      "  add  rcx, 4             \n"
      "  mov  eax, [%[translit] + rcx]    \n"
      "  cmp  eax, 0             \n"
      "  je   trans_lower_exit   \n"
      "  stosd                   \n"
      "trans_lower_exit:         \n"
      "  jmp  process_str        \n"

      "end_process:              \n"
      "  mov  eax, 0             \n"
      "  stosd                   \n"
      : // Output parameters
      : [out] "D"(out), [in] "S"(str), [translit] "r"(translit) // Input parameters
      : "rcx", "rax"); // Clobber list

  wprintf(L"%ls", out);

  return 0;
}
