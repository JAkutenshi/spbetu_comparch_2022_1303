#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <limits.h>

extern void f(int *result_array, int *source_array, int *borders_array,
              int number, int borders_number, int *min_arr);

int main() {
  srand(time(NULL));

  int n = 0;
  int x_min = 0;
  int x_max = 0;

  int n_int = 0;

  printf("Введите количество чисел, левую границу, правую границу и число "
         "левых границ\n");
  scanf("%d %d %d %d", &n, &x_min, &x_max, &n_int);

  if (n <= 0 || n > 16 * 1024) {
    printf("Некорректное количество чисел\n");
    return 1;
  } else if (x_min >= x_max) {
    printf("Некорректные границы\n");
    return 1;
  } else if (n_int <= 0 || n_int > 24) {
    printf("Некорректные границы\n");
    return 1;
  }

  int *n_arr = malloc(n * sizeof(int));
  int *int_arr = malloc(n_int * sizeof(int));

  printf("Введите левые границы\n");
  char c;
  for (int i = 0; i < n_int; ++i) {
    scanf("%d%c", &int_arr[i], &c);
    if ((int_arr[i] < x_min || int_arr[i] > x_max) ||
        (i > 0 && int_arr[i] <= int_arr[i - 1])) {
      printf("Некорректная левая граница\n");
      free(n_arr);
      free(int_arr);
      return 1;
    }
  }

  int rand_max = x_max - x_min + 1;
  for (int i = 0; i < n; ++i) {
    n_arr[i] = x_min + rand() % rand_max;
  }

  int *res_arr = calloc(n_int, sizeof(int));
  int *min_arr = calloc(n_int, sizeof(int));
  for (int i = 0; i < n_int; ++i) {
    min_arr[i] = INT_MAX;
  }
  f(res_arr, n_arr, int_arr, n, n_int, min_arr);

  FILE *f = fopen("results.txt", "w");
  for (int i = 0; i < n; ++i) {
    fprintf(f, "%d ", n_arr[i]);
  }
  fputs("\n\n", f);
  for (int i = 0; i < n_int; ++i) {
    fprintf(f, "%d   %d   %d   %d\n", i + 1, int_arr[i], res_arr[i], min_arr[i]);
  }

  fclose(f);

  free(res_arr);
  free(n_arr);
  free(int_arr);
  free(min_arr);
  return 0;
};
