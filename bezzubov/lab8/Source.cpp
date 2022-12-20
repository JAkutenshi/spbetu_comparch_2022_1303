#include <math.h>
#include <iostream>

long double x;
long double e = exp(1);
long double const two = 2;
long double neg = -1;
long double flag = 1;
long double res;

int main() {

    system("chcp 1251 > nul");
    setlocale(LC_CTYPE, "rus");

    std::cout << "Введите значение х: \n";
    std::cin >> x;

    __asm {

        fld qword ptr[x]
        fldZ
        FCOMP
        jge cont
        fabs 
        fld qword ptr[neg]
        fstp qword ptr[flag]

        cont:
        fld qword ptr[e]
        FYL2X
        F2XM1
        fld1
        fadd st, st(1)
        fld st
        fld1
        fdivrp st(1), st
        fsubp st(1), st
        fdiv qword ptr[two]
        fmul qword ptr[flag]
        FSTP qword ptr[res]
    }
    printf("Вычисленное значение sinh(x): %lf\n", res);
    printf("Абсолютная погрешность вычисления: %.20lf\n", abs(res - sinh(x)));
	return 0;
}