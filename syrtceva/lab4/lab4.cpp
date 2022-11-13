#include <iostream>
#include <fstream>
#include <windows.h>

char input_str[81];
char output_str[81];

int main() {
	system("chcp 1251 > nul");
	setlocale(LC_CTYPE, "rus");
	std::cout << "������� ����� 1303.\n������� 22. �������������� ���� ��������� ��������� ���� ������� ������ � ��������, � ���������� ���� � ���������, ��������� ������� ������� ������ ���������� � �������������� ���������������.\n";
	std::cout << "������� ������: ";
	std::cin.getline(input_str, 81);
	std::ofstream file("res.txt");

	__asm {
		push ds
		pop es
		mov esi, offset input_str
		mov edi, offset output_str

		symb_reading :
			lodsb
			cmp al, '\0'
			je finish
			cmp al, '0'
			jb symb_writing
			cmp al, '9'
			jbe inverse
			cmp al, 'A'
			jb symb_writing
			cmp al, 'Z'
			jbe swap
			jmp symb_writing

		swap :
			add al, 32
			jmp symb_writing

		inverse :
			neg al
			add al, 105

		symb_writing :
			stosb
			jmp symb_reading

		finish :
	};
	std::cout << "���������: " << output_str;
	file << output_str;
	file.close();

	return 0;
}