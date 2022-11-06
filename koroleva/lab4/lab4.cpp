#include <iostream>
#include <stdio.h>

char input_str[81];
char output_str[321];

int main()
{
    std::cout << "Author: Koroleva Polina\n";
    std::cout << "Task: converting numbers from hex to bin\n";
    std::cout << "Hello, print your string:\n";
	fgets(input_str, 81, stdin);
	input_str[strlen(input_str) - 1] = '\0';
	__asm {
        push ds
        pop es
        mov esi, offset input_str  //сместились до source
        mov edi, offset output_str //сместились до destination
    next:                          //начало цикла
        lodsb;                          //загружаем 1 байт из esi в al
        cmp al, '0'                     // сравниваем с 0
        jl writeSymbol                  //если меньше 0, переходим к написанию символа, иначе идем дальше
        cmp al, 'F'
        jg writeSymbol                  //если больше F переходим к написанию символа, если мы все еще здесь - значит встреченный символ - 16-ричное число
        cmp al, '9'                     
        jle digit                       //если <= 9 значит 16 ричное число выражено цифрой, переходим в блок для перевода числа
        cmp al, 'A'
        jge letter                      //если >= A значит 16 ричное число выражено буквой, переходим в блок для перевода буквы
        jmp writeSymbol                 //если ничего из перечисленного не подошло - просто печатаем символ
        digit :
            sub al, '0'
            jmp tobin
        letter :
            sub al, 'A'
            add al, 10
            jmp tobin
        tobin :
            mov bl, al
            mov cl, 8
            and cl, bl                  // побитовое сравнение 1000 и ?XXX
            jnz writeOne1               // если результатом оказался не 0, т.е bl = 1... переходим в writeone1
            mov al, '0'                 // иначе зануляем al и переходим к проверке второго бита
            jmp checkSecondBit
            writeOne1:
            mov al, '1'                 // если в рерзультате сравнения получился не 0, кладем в al код единицы и проверяем второй бит
            checkSecondBit :
            stosb                       // проверка второго бита начинается с копирования al в destination str
            mov cl, 4
            and cl, bl                  // проверяем второй бит 0100 & Х?ХХ
            jnz writeOne2               // если получаем не 0 переходим в написание второго бита, иначе кладем в al код 0
            mov al, '0'
            jmp checkThirdBit
            writeOne2 :
            mov al, '1'
            checkThirdBit :
            stosb                       //записываем в destination второй бит
            mov cl, 2
            and cl, bl                  // сравнение 0010 и XX?X, определяем третий бит
            jnz writeOne3               // если получен не 0, переходим к написанию третьего бита, иначе записываем в al символ 0
            mov al, '0'
            jmp checkFourthBit
            writeOne3 :
            mov al, '1'
            checkFourthBit :            // аналогично, записываем третий бит в destination, проверяем четвертый бит, если получили 1 записываем в al 1, если 0 - то 0
            stosb
            mov cl, 1
            and cl, bl; 0001 and XXX?
            jnz writeOne4
            mov al, '0'
            stosb
            jmp checkNewSymbol
            writeOne4 :
            mov al, '1'
            stosb
            jmp checkNewSymbol
        writeSymbol :
            stosb                       //если встреченый символ просто буква - кладем его в destination без преобразований
        checkNewSymbol :
            mov  ecx, '\0' 
            cmp  ecx, [esi]             //проверяем является ли концом строки текущий символ, мы можем так делать, тк после каждого считывания через lodsb значение регистра esi увеличивается на 1
            je   Exit                   // выходим из цикла, если да
            jmp  next                   //если нет, цикл продолжается
    Exit:
	};
	std::cout << output_str;
	FILE* f;
	fopen_s(&f, "out.txt", "w");
	fwrite(output_str, sizeof(char), strlen(output_str), f);
	return 0;
}


