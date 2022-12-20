

#include <iostream>
#include <fstream>
char inp_str[81];
char out_str[81];

int main()
{
	system("chcp 1251 > nul");
	setlocale(LC_CTYPE, "rus");

	std::cout << "Чубан Дмитрий 1303 \n Формирование выходной строки только из русских и латинских букв входной строки.\n";
	std::cin.getline(inp_str, 81);
	std::ofstream file;
	file.open("res.txt");

	__asm {
		push ds
		pop es
		mov esi, offset inp_str
		mov edi, offset out_str

		check:
			lodsb
			cmp al, '\0'
			je end

			cmp al, 'А'
			jl check

			cmp al, 'я'
			jle write

			cmp al, 'A'
			jl check

			cmp al, 'z'
			jg check

		write:
			stosb
			jmp check
		end:

	};
	std::cout << out_str;
	file << out_str;
	file.close();
	return 0;
}
