#include <stdio.h>
#include <stdlib.h>
#include <time.h>

extern void func(int* res_arr, int* nums_arr, int k_inter, int count_N, int* left_arr, int *sum_gr);

int main() {
    srand(time(NULL));
    puts("Сколько чисел будет?");
    int count_N;
    scanf("%d", &count_N);
    if (count_N <= 0 || count_N > 16 * 1024) {
        puts("Что то не так ввели");
        return 1;
    }
    puts("введите Диапазон");
    int d_l, d_r;
    scanf("%d %d", &d_l, &d_r);
    if (d_l > d_r) {
        puts("что то пошло не так");
        return 1;
    }
    puts("Сколько будет интервалов разбиения?");
    int k_inter;
    scanf("%d", &k_inter);
    if (k_inter <= 0) {
        puts("Нужно больше *Золота* интервалов");
        return 1;
    }
    puts("Введите массив левых границ");
    int* arr = malloc(sizeof(int) * k_inter);
    for (int i = 0; i < k_inter; i++) {
        scanf("%d", &arr[i]);
        if (arr[i] < d_l || arr[i] > d_r || i > 0 && arr[i] < arr[i - 1]) {
            puts("Некорректное значение левой границы");
            free(arr);
            return 1;
        }
    }
    int* nums = malloc(sizeof(int) * count_N);
    for (int i = 0; i < count_N; i++) {
        nums[i] = rand() % (d_r - d_l + 1) + d_l;
    }
    int *res = calloc(k_inter, sizeof(int));
    int *sum_gr = calloc(k_inter, sizeof(int));

    func(res, nums, k_inter, count_N, arr, sum_gr);

    FILE* f = fopen("result.txt", "w");
    for(int i=0; i < count_N; i++){
        fprintf(f, "%d ", nums[i]);
    }
    fprintf(f, "\n\n");
    printf("Массив: ");
    for (int i = 0; i < count_N; i++) {
        fprintf(f,"%d ",nums[i]);
    }
    fprintf(f, "\n\n");
    for (int i = 0; i < k_inter; i++) {
        fprintf(f, "%d\t%d\t%d\t%d\n", i + 1, arr[i], res[i], sum_gr[i]);
    }
    for (int i = 0; i < k_inter; i++) {
        printf("%d\t%d\t%d\t%d\n", i + 1, arr[i], res[i], sum_gr[i]);
    }
    fclose(f);
    return 0;
}
