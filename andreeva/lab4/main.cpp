#include <iostream>
#include <fstream>

char input_str[81];
char output_str[81];


using namespace std;

int main() {
	system("chcp 1251 > nul");
	setlocale(LC_CTYPE, "rus");

	cout << "Андреева Елизавета 1303\nЗадание: формирование выходной строки только из цифр и русских букв входной строки.\n";

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
			je write
			cmp al, 'Ё'
			je write
			cmp al, 'я'
			jle checking_rus
			cmp al, '9'
			jle checking_digit

			jmp checking

			checking_digit :
		cmp al, '0'
			jge write
			jmp checking

			checking_rus :
		cmp al, 'А'
			jge write
			jmp checking


			write :
		stosb
			jmp checking

			finish :
	};

	cout << "Строка только из цифр и латинских букв.\n";
	cout << output_str;
	file << output_str;
	file.close();

	return 0;
}
