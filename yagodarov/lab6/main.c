#include <stdio.h>
#include <stdlib.h>
#include <time.h>

extern void process_data(int *result_array, int *source_array,
                         int *borders_array, int number, int borders_number);

int main() {
  srand(time(NULL));

  int n = 0;
  int x_min = 0;
  int x_max = 0;

  int n_int = 0;

  printf("Enter: numbers' count, generation left border and right border, "
         "count of intervals\n");
  scanf("%d %d %d %d", &n, &x_min, &x_max, &n_int);

  if (n <= 0 || n > 16 * 1024) {
    printf("Invalid numbers' count\n");
    return 1;
  } else if (x_min >= x_max) {
    printf("Invalid borders of number generation\n");
    return 1;
  } else if (n_int <= 0 || n_int > 24) {
    printf("Invalid number of intervals\n");
    return 1;
  }

  int *n_arr = malloc(n * sizeof(int));
  int *int_arr = malloc(n_int * sizeof(int));

  printf("Enter left borders of intervals\n");
  char c;
  for (int i = 0; i < n_int; ++i) {
    scanf("%d%c", &int_arr[i], &c);
    if ((int_arr[i] < x_min || int_arr[i] > x_max) ||
        (i > 0 && int_arr[i] <= int_arr[i - 1])) {
      printf("Invalid left border!\n");
      goto error_free_sources;
    }
  }

  int rand_max = x_max - x_min + 1;
  for (int i = 0; i < n; ++i) {
    n_arr[i] = x_min + rand() % rand_max;
  }

  int *res_arr = calloc(n_int, sizeof(int));
  process_data(res_arr, n_arr, int_arr, n, n_int);

  FILE *f = fopen("results.txt", "w");
  if (!f) {
    printf("Cannot create file to write results");
    goto error_free_result;
  }

  // fputs("Generated numbers:\n", f);
  // for (int i = 0; i < n; ++i) {
  //   fprintf(f, "%d ", n_arr[i]);
  // }
  // fputs("\n\n", f);
  // fputs("Results:\n", f);
  for (int i = 0; i < n_int; ++i) {
    fprintf(f, "%d   %d   %d\n", i + 1, int_arr[i], res_arr[i]);
  }

  fclose(f);

  return 0;

error_free_result:
  free(res_arr);
error_free_sources:
  free(n_arr);
  free(int_arr);
  return 1;
};
