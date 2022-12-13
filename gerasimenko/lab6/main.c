#include <stdio.h>
#include <stdlib.h>

extern void function(int* res_arr, int* nums_arr
                 , int k_inter, int count_N, int* left_arr);

int main() {


    puts("Сколько чисел будет?");
    int countN;
    scanf("%d", &countN);
    if (countN <= 0 || countN > 16 * 1024) {
        puts("Что то не так ввели");
        return 1;
    }


    puts("диапазон генерации чисел: ");
    int d_l, d_r;
    scanf("%d %d", &d_l, &d_r);
    if (d_l > d_r) {
        puts("Что то не так с диапозоном");
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
        if (arr[i] < d_l || arr[i] > d_r ||
        i > 0 && arr[i] < arr[i - 1]) {
            puts("Некорректное значение левой границы");
            free(arr);
            return 1;
        }
    }
    int* nums = malloc(sizeof(int) * countN);

    for (int i = 0; i < countN; i++) {
        nums[i] = rand() % (d_r - d_l + 1) + d_l;
    }
    int* res = calloc(k_inter, sizeof(int));

    function(res, nums, k_inter, countN, arr);

    FILE* f = fopen("res.txt", "w");
    for(int i=0; i < countN; i++){
        fprintf(f, "%d ", nums[i]);
    }
    fprintf(f, "\n\n");
    for (int i = 0; i < k_inter; i++) {
        fprintf(f, "%d\t%d\t%d\n", i + 1, arr[i], res[i]);
    }
    for (int i = 0; i < k_inter; i++) {
        printf("%d\t%d\t%d\n", i + 1, arr[i], res[i]);
    }
    fclose(f);
    return 0;
}

