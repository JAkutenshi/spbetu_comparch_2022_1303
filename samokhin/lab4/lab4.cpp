#include <iostream>
#include <fstream>
#include <windows.h>

char input_str[81];
char output_str[81];

int main() {
    system("chcp 1251 > nul");
    setlocale(LC_CTYPE, "rus");
    std::cout << "Самохин Кирилл 1303.\nВариант 22. Преобразование всех заглавных латинских букв входной строки в строчные, а десятичных цифр в инверсные, остальные символы входной строки передаются в выходную строку непосредственно.\n";
    std::cout << "Введите строку: ";
    std::cin.getline(input_str, 81);
    std::ofstream file("res.txt");
    __asm {
        push ds
        pop es
        mov esi, offset input_str
        mov edi, offset output_str
        check :
            lodsb
            cmp al, '\0'
            je end
            cmp al, '0'
            jb writing
            cmp al, '9'
            jbe inverse
            cmp al, 'A'
            jb writing
            cmp al, 'Z'
            jbe swap
            jmp writing

        swap :
            add al, 32
            jmp writing

        inverse :
            neg al
            add al, 105
            jmp writing

        writing :
            stosb
            jmp check

        end :
    };
    std::cout << "Результат: " << output_str;
    file << output_str;
    file.close();
    return 0;
}