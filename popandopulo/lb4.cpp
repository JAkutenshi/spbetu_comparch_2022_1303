#include <iostream>
#include <stdio.h>
#include <cstring>
#include <fstream>

char input[81];
char output[300];

int main() {
    system("chcp 1251 > nul");
    setlocale(LC_CTYPE, "rus");

    std::cout << "Попандопуло Александр 1303\nПреобразование введенных во входной строке шестнадцатиричных цифр в двоичную СС.\n";
    
    std::cout << "Введите строку..\n";
    std::cin.getline(input, 81);

    std::ofstream file;
    file.open("result.txt");

    __asm {
        push ds
        pop es
        mov esi, offset input
        mov edi, offset output

        line :
        lodsb
            cmp al, '2'
            jne symbol3
            mov ax, '01'
            stosw
            jmp next

            symbol3 :
        cmp al, '3'
            jne symbol4
            mov ax, '11'
            stosw
            jmp next

            symbol4 :
        cmp al, '4'
            jne symbol5
            mov ax, '01'
            stosw
            mov al, '0'
            stosb
            jmp next

            symbol5 :
        cmp al, '5'
            jne symbol6
            mov ax, '01'
            stosw
            mov al, '1'
            stosb
            jmp next

            symbol6 :
        cmp al, '6'
            jne symbol7
            mov ax, '11'
            stosw
            mov al, '0'
            stosb
            jmp next

            symbol7 :
        cmp al, '7'
            jne symbol8
            mov ax, '11'
            stosw
            mov al, '1'
            stosb
            jmp next

            symbol8 :
        cmp al, '8'
            jne symbol9
            mov eax, '0001'
            stosd
            jmp next

            symbol9 :
        cmp al, '9'
            jne symbolA
            mov eax, '1001'
            stosd
            jmp next

            symbolA :
        cmp al, 'A'
            jne symbolB
            mov eax, '0101'
            stosd
            jmp next

            symbolB :
        cmp al, 'B'
            jne symbolC
            mov eax, '1101'
            stosd
            jmp next

            symbolC :
        cmp al, 'C'
            jne symbolD
            mov eax, '0011'
            stosd
            jmp next

            symbolD :
        cmp al, 'D'
            jne symbolE
            mov eax, '1011'
            stosd
            jmp next

            symbolE :
        cmp al, 'E'
            jne symbolF
            mov eax, '0111'
            stosd
            jmp next

            symbolF:
        cmp al, 'F'
            jne letter
            mov eax, '1111'
            stosd
            jmp next

            
            letter :
        stosb
  
            next :
        mov ecx, '\0'
            cmp ecx, [esi]
            je end
            jmp line
            end :
    };

    std::cout << "Строка с шестнадцатиричными цифрами, преобразованными в двоичную СС:\n";
    std::cout << output;
    file << output;
    file.close();

    return 0;
}