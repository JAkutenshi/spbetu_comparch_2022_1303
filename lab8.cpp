#include <math.h>
#include <iostream>

long double x;
long double two = 2;
long double e = exp(1);
long double res;

int main() {
    system("chcp 1251 > nul");
    setlocale(LC_CTYPE, "rus");

    std::cout << "Введите значение х...\n";
    std::cin >> x;

	__asm{

        ; Возведение e^x
        fld qword ptr[x]
        fld qword ptr[e]
        fyl2x
        fld st
        frndint
        fsub st(1), st
        fxch st(1)
        f2xm1
        fld1
        faddp st(1), st
        fscale
        fstp st(1)
        fst qword ptr[res]

        ; Деление 1 / e^x
        fld1
        fdiv qword ptr[res]

        ; Получение e^x + 1 / (e^x)
        fadd st, st(1)

        ; Получение cosh(x)
        fdiv qword ptr[two]

        ; Запись ответа
        fstp qword ptr[res]
	}
    printf("Вычисленное значение cosh(x): %lf\n", res);
    printf("Абсолютная погрешность вычисления: %.20lf\n", abs(res - cosh(x)));
	return 0;
}