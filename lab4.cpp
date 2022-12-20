#include <iostream>
#include <fstream>
using namespace std;
char input_str[81];
char output_str[81];

int main() {
	system("chcp 1251 > nul");
	setlocale(LC_CTYPE, "rus");

	cout << "Кузнецов Николай 1303\nЗадание: удаление символов русского алфавита и цифр\n";

	cout << "Введите строку\n";
	cin.getline(input_str, 81);

	ofstream file;
	file.open("result.txt");

	__asm {
		push ds
		pop es
		mov esi, offset input_str
		mov edi, offset output_str

		checking :
			lodsb
			cmp al, '\0'
			je finish
			cmp al, 'ё'
			je checking
			cmp al, 'Ё'
			je checking
			cmp al, 'А'
			jl write
			cmp al, 'я'
			jle checking
			cmp al, '0'
			jl write
			cmp al, '9'
			jle checking

		write :
			stosb
			jmp checking

		finish :
	};

	cout << "Строка без символов русского алфавита и цифр\n";
	cout << output_str;
	file << output_str;
	file.close();

	return 0;
}
