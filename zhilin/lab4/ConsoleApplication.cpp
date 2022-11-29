#include <iostream>
#include <fstream>

using namespace std;

char inStr[81];
char outStr[81];

int main() {
    system("chcp 1251 > nul");
    setlocale(LC_CTYPE, "rus");
    cout << "Жилин Илья 1303\nФормирование строки только из цифр и латинских букв входной строки\n";
    cin.getline(inStr, 81);
    ofstream res;
    res.open("result.txt", ios::out | ios::trunc);
    __asm {
        mov esi, offset inStr
        mov edi, offset outStr

        symCheck:
            lodsb
            cmp al, '\0'
            je endBlock
            cmp al, '9'
            jle checkDigit
            cmp al, 'Z'
            jle checkUpper
            cmp al, 'z'
            jle checkLower
            jmp symCheck

        checkDigit:
            cmp al, '0'
            jge writeSym
            jmp symCheck

        checkUpper:
            cmp al, 'A'
            jge writeSym
            jmp symCheck

        checkLower :
            cmp al, 'a'
            jge writeSym
            jmp symCheck

        writeSym:
            stosb
            jmp symCheck

        endBlock:
    };
    cout << outStr;
    res << outStr;
    res.close();
    return 0;
}
