#include <iostream>
#include <stdio.h>
#include <cstring>

char input[81];
char output[321];

int main() {
    std::cout << "Korenev Danil from 1303\nTask 11: conversion from decimal to binary\n";
    fgets(input, 81, stdin);
    input[strlen(input)] = '\0';

    __asm {
        push ds
        pop es
        mov esi, offset input
        mov edi, offset output

    line:
        lodsb
        cmp al, '2'
        jne symbol3
        mov ax, '01'
        stosw
        jmp next

    symbol3:
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

    symbol5:
        cmp al, '5'
        jne symbol6
        mov ax, '01'
        stosw
        mov al, '1'
        stosb
        jmp next

    symbol6:
        cmp al, '6'
        jne symbol7
        mov ax, '11'
        stosw
        mov al, '0'
        stosb
        jmp next

    symbol7:
        cmp al, '7'
        jne symbol8
        mov ax, '11'
        stosw
        mov al, '1'
        stosb
        jmp next

    symbol8:
        cmp al, '8'
        jne symbol9
        mov eax, '0001'
        stosd
        jmp next

    symbol9 :
        cmp al, '9'
        jne letter
        mov eax, '1001'
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

    std::cout << output;
    FILE* f;
    fopen_s(&f, "output.txt", "w");
    fwrite(output, sizeof(char), strlen(output), f);
    fclose(f);
   
    return 0;
}
