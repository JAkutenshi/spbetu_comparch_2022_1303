#include <stdio.h>
#include <stdlib.h>

extern double poly(double x, int n, double *c);

int main() {
  double x;
  printf("Enter x: ");
  scanf("%lf", &x);

  int n;
  printf("Enter number of constants: ");
  scanf("%d", &n);

  double *constants = malloc(n * sizeof(double));
  char c;
  printf("Enter constants: ");
  for (int i = 0; i < n; ++i) {
    scanf("%lf%c", &constants[i], &c);
  }

  double result = poly(x, n, constants);

  printf("(asm) Result is:\n\t%lf\n", result);
  free(constants);

  return 0;
}
