#include <iostream>
#include <stdio.h>
#include <cstring>

char input[81];
char output[321];

int main() {
	std::cout << "Ivanov Artur from 1303\nTask 11: conversion from hex to binary\n";
	fgets(input, 81, stdin);
	input[strlen(input)] = '\0';

	__asm {
			push ds
			pop es
			mov esi, offset input
			mov edi, offset output

		line :
			lodsb
			cmp al, '2'
			jne count3
			mov ax, '01'
			stosw
			jmp next

		count3 :
			cmp al, '3'
			jne count4
			mov ax, '11'
			stosw
			jmp next

		count4 :
			cmp al, '4'
			jne count5
			mov ax, '01'
			stosw
			mov al, '0'
			stosb
			jmp next

		count5 :
			cmp al, '5'
			jne count6
			mov ax, '01'
			stosw
			mov al, '1'
			stosb
			jmp next

		count6 :
			cmp al, '6'
			jne count7
			mov ax, '11'
			stosw
			mov al, '0'
			stosb
			jmp next

		count7 :
			cmp al, '7'
			jne count8
			mov ax, '11'
			stosw
			mov al, '1'
			stosb
			jmp next

		count8 :
			cmp al, '8'
			jne count9
			mov eax, '0001'
			stosd
			jmp next

		count9 :
			cmp al, '9'
			jne count10
			mov eax, '1001'
			stosd
			jmp next

		count10 :
			cmp al, 'A'
			jne count11
			mov eax, '0101'
			stosd
			jmp next

		count11 :
			cmp al, 'B'
			jne count12
			mov eax, '1101'
			stosd
			jmp next

		count12 :
			cmp al, 'C'
			jne count13
			mov eax, '0011'
			stosd
			jmp next

		count13 :
			cmp al, 'D'
			jne count14
			mov eax, '1011'
			stosd
			jmp next

		count14 :
			cmp al, 'E'
			jne count15
			mov eax, '0111'
			stosd
			jmp next

		count15 :
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

	FILE* f;
	fopen_s(&f, "result.txt", "w");
	fwrite(output, sizeof(char), strlen(output), f);
	fclose(f);
	return 0;
}