#include <iostream>
#include <fstream>
using namespace std;
char input_str[81];
char output_str[81];

int main() {
    system("chcp 1251 > nul");
    setlocale(LC_CTYPE, "rus");

    cout << "Кропотов Никита 1303\nЗадание: формирование строки с исключенными русскими буквами и цифрами.\n";

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
            cmp al, 'Z'
            jle checking_upper
            cmp al, 'z'
            jle checking_lower
            jmp checking

            checking_upper :
        cmp al, 'A'
            jge write
            jmp checking

            checking_lower :
        cmp al, 'a'
            jge write
            jmp checking

            write :
        stosb
            jmp checking

            finish :
    };

    cout << "Строка с исключенными русскими буквами и цифрами.\n";
    cout << output_str;
    file << output_str;
    file.close();

    return 0;
}