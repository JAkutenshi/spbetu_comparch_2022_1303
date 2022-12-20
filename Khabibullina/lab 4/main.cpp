#include <iostream>
#include <fstream>
#include <windows.h>
using namespace std;
char input_str[81];
char output_str[81];

int main() {

    SetConsoleCP(1251);
    SetConsoleOutputCP(1251);

    cout << "*Хабибуллина Алина 1303.\n*Задание: Инвертирование введенных во входной строке цифр в десятичной СС и преобразование заглавных русских букв в строчные.\n";
    cout << "*Введите строку: ";
    cin.getline(input_str, 81);

    ofstream file;
    file.open("out.txt");

    __asm {
        push ds
        pop es
        mov esi, offset input_str
        mov edi, offset output_str

        check :
            lodsb
            cmp al, '\0'
            je finish

            cmp al, '0'
            jb symbol

            cmp al, '9'
            jbe inverse

            cmp al, 'Ё'
            je sym

            cmp al, 'А'
            jb symbol

            cmp al, 'Я'
            jbe change

            cmp al, 'Я'
            jg symbol

        sym :
            add al, 16
            jmp symbol

        change :
            add al, 32
            jmp symbol

        inverse :
            neg al
            add al, 105

        symbol :
            stosb
            jmp check

        finish :

    };

    cout << "*Итог: " << output_str;
    file << output_str;
    file.close();

    return 0;
}
