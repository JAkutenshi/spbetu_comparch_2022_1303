#include <iostream>
#include <fstream>
char input_str[81];
char output_str[81];

int main() {
    system("chcp 1251 > nul");
    setlocale(LC_CTYPE, "rus");

    std::cout << "Автор: Чернуха Владимир, 1303. Задание: вывести строку только из латинских букв и цифр.\nВведите строку\n";
    std::cin.getline(input_str, 81);

    __asm {
        push ds
        pop es
        mov esi, offset input_str
        mov edi, offset output_str

        checking :
            lodsb
            cmp al, '\0'
            je endprog

            cmp al, 'a'
            jge checklow
            
            cmp al, 'A'
            jge checkup

            cmp al, '0'
            jge checkdigit

            jmp checking

        checkdigit:
            cmp al, '9'
            jle write
            jmp checking

        checkup:
            cmp al, 'Z'
            jle write
            jmp checking

        checklow:
            cmp al, 'z'
            jle write
            jmp checking

        write:
            stosb
            jmp checking

        endprog:
    };

    std::ofstream fp;
    fp.open("text.txt");
    std::cout << "Выходная строка, только латиница и цифры:\n" << output_str;
    fp << output_str;
    fp.close();

    return 0;
}