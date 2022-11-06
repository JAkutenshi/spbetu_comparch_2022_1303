#include <iostream>
#include <fstream>
using namespace std;
char input_str[81];
char output_str[81];
// hello world 5 in the привет мир hello world !!!
int main() {
	system("chcp 1251 > nul");
	setlocale(LC_CTYPE, "rus");

	cout << "Насонов Ярослав 1303\nЗадание: Исключение латинских букв и цифр, \nвведенных во входной строке при формировании выходной строки\n";

	cout << "Введите строку\n";
	cin.getline(input_str, 81);

	ofstream file;
	file.open("result.txt");

	__asm {
		push ds
		pop es
		mov esi, offset input_str
		mov edi, offset output_str

		checking:
			lodsb
			cmp al, '\0'
			je finish
			cmp al, '0'
			jl write
			cmp al, '9'
			jle checking
			cmp al, 'A'
			jl write
			cmp al, 'Z'
			jle checking
			cmp al, 'a'
			jl write
			cmp al, 'z'
			jle checking

		write:
			stosb
			jmp checking

		finish :
	};

	cout << "Строка без латинских букв и цифр\n";
	cout << output_str;
	file << output_str;
	file.close();

	return 0;
}