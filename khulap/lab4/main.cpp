#include <iostream>
#include <fstream>

char str_in[81];
char str_out[81];

using namespace std;

int main() {
	system("chcp 1251 > nul");
	setlocale(LC_CTYPE, "rus");

	cout << "Хулап Олеся 1303\nЗадание: формирование выходной строки только из цифр и русских букв.\n";

	cout << "Введите строку\n";
	cin.getline(str_in, 81);
	ofstream f;
	f.open("result.txt");

	__asm {
		push ds
		pop es
		mov esi, offset str_in
		mov edi, offset str_out

		check :
			lodsb
			cmp al, '\0'
			je finish
			cmp al, 'ё'
			je write
			cmp al, 'Ё'
			je write
			cmp al, 'я'
			jle check_rus
			cmp al, '9'
			jle check_digit

			jmp check

		check_digit :
			cmp al, '0'
			jge write
			jmp check

		check_rus :
			cmp al, 'А'
			jge write
			jmp check

		write :
			stosb
			jmp check

		finish :
	}

	cout << "Строка только из цифр и русских букв\n";
	cout << str_out;
	f << str_out;
	f.close();

	return 0;
}