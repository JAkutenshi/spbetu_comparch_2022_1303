#include <stdio.h>
#include <stdlib.h>

double ldexp(double value, int exp);

int main() {
    printf("Enter value for composition(<double> * ...), value: ");
    double val;
    scanf("%lf", &val);

    printf("Enter exp for pow(2, <int>), exp: ");
    int exp;
    scanf("%d", &exp);

    double result = ldexp(val, exp);

    printf("Result of expression(value * 2^exp):\t%.9lf\n", result);

    return 0;
}