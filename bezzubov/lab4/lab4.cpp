#include <iostream>
#include <fstream>
char input_string[81];
char output_string[81];

int main() {
    
    system("chcp 1251 > nul");
    setlocale(LC_CTYPE, "rus");

    std::cout << "�������� ������ 1303\n�������: ������������ �������� ������ ������ �� ������� � ��������� ���� ������� ������\n";

    std::cout << "������� ������\n";
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

            cmp al, '�'
            jl checking

            cmp al, '�'
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

    std::cout << "������ �� �������� �������� � ���������\n";
    std::cout << output_string;
    file << output_string;
    file.close();

    return 0;
}