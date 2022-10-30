#include <iostream>
#include <fstream>
char input_string[81];
char output_string[81];

int main() {
    
    system("chcp 1251 > nul");
    setlocale(LC_CTYPE, "rus");

    std::cout << "Беззубов Даниил 1303\nЗадание: Формирование выходной строки только из русских и латинских букв входной строки\n";

    std::cout << "Введите строку\n";
    std::cin.getline(input_string, 81);

    std::ofstream file;
    file.open("result.txt");

    __asm {
        push ds
        pop es
        mov esi, offset input_string
        mov edi, offset output_string
        checking:

        lodsb
            cmp al,'\0'
            je end

            cmp al, 'А'
            jl checking

            cmp al, 'я'
            jle save

            cmp al, 'A'
            jl checking

            cmp al, 'z'
            jg checking

            save:
            stosb
            jmp checking
            end:
    };

    std::cout << "Строка из символов латиницы и кириллицы\n";
    std::cout << output_string;
    file << output_string;
    file.close();

    return 0;
}