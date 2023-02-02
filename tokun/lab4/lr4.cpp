#include <iostream>
#include <stdio.h>
#include <clocale>

char instr[81];
char outstr[162];

int main()
{
	setlocale(LC_ALL, "cp866");
	fgets(instr, 81, stdin);
	instr[strlen(instr) - 1] = '\0';
	__asm {
		push ds
		pop es
		mov esi, offset instr
		mov edi, offset outstr
		L :
		lodsb; копирует один байт в al
			; space (32)
			cmp al, 32
			jne skip1
			stosb
			jmp final

			; 0 - 9 (48 - 57)
			skip1:
			cmp al, 48
			jb final
			cmp al, 57
			ja skip2
			stosb
			jmp final

			; A - п (128 - 175)
			skip2:
			cmp al, 128
			jb final
			cmp al, 175
			ja skip3
			stosb
			jmp final

			; р - ё(224 - 241)
			skip3:
			cmp al, 224
			jb final
			cmp al, 241
			ja final
			stosb
			ja final

			final:
		mov  ecx, '\0'
			cmp  ecx, [esi]
			je   LExit;
		jmp  L
			LExit :
	};

	std::cout << outstr;
	FILE* f;
	fopen_s(&f, "out.txt", "w");
	fwrite(outstr, sizeof(char), strlen(outstr), f);
	return 0;
}