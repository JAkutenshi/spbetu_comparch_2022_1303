#include <iostream>
#include <fstream>
using namespace std;
char input_str[81];
char output_str[81];

int main() {
	system("chcp 1251 > nul");
	setlocale(LC_CTYPE, "rus");

	cout << "�������� ������� 1303\n�������: �������� �������� �������� �������� � ����\n";

	cout << "������� ������\n";
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
			cmp al, '�'
			je checking
			cmp al, '�'
			je checking
			cmp al, '�'
			jl write
			cmp al, '�'
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

	cout << "������ ��� �������� �������� �������� � ����\n";
	cout << output_str;
	file << output_str;
	file.close();

	return 0;
}