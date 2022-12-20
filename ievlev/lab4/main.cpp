#include <iostream>
using namespace std;
char input_str[80];
char output_str[80];


int main() {
	system("chcp 1251 > nul");
	setlocale(LC_CTYPE, "rus");
	cout << "Иевлев Егор 1303\n";
    cout << "Преобразование введённых во входной строке шестнадцатиричных чисел в десятичную СС, \n";
    cout << "остальные символы входной строки передеются в выходную строку непосредственно.\n";
    cout << "Введите строку:\n";
	cin.getline(input_str, 80);

    __asm {
        push ds
        pop es
        mov esi, offset input_str
        mov edi, offset output_str

        reading:
            lodsb
            cmp al, '\0'
            je ending
            cmp al, 'A'
            jl write
            cmp al, 'F'
            jg write

            cmp al, 'A'
            je converting_A
            cmp al, 'B'
            je converting_B
            cmp al, 'C'
            je converting_C
            cmp al, 'D'
            je converting_D
            cmp al, 'E'
            je converting_E
            cmp al, 'F'
            je converting_F

        converting_A:
            mov ax, '01'
            stosw
            jmp reading

        converting_B:
            mov ax, '11'
            stosw
            jmp reading

        converting_C:
            mov ax, '21'
            stosw
            jmp reading

        converting_D:
            mov ax, '31'
            stosw
            jmp reading

        converting_E :
            mov ax, '41'
            stosw
            jmp reading

        converting_F :
            mov ax, '51'
            stosw
            jmp reading

        write:
            stosb
            jmp reading

        ending:
    };

	cout << output_str;

	return 0;
}