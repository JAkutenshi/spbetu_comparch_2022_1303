#include <stdio.h>
#include <stdlib.h>
#include <math.h>

extern void func(int* res, int* nums, int k, int n, int* arr);

int main() {
    printf("Введите количество чисел\n");
    int n;
    scanf("%d", &n);
    if (n <= 0 || n > 16 * 1024) {
        printf("Неверное количество чисел\n");
        return 1;
    }
    printf("Введите диапазон генерации чисел\n");
    int a, b;
    scanf("%d %d", &a, &b);
    if (a > b) {
        printf("Неверный диапазон генерации чисел\n");
        return 1;
    }
    printf("Введите количество интервалов разбиения\n");
    int k;
    scanf("%d", &k);
    if (k <= 0) {
        printf("Неверное количество интервалов разбиения\n");
        return 1;
    }
    printf("Введите массив левых границ\n");
    int* arr = malloc(sizeof(int) * k);
    for (int i = 0; i < k; i++) {
        scanf("%d", &arr[i]);
        if (arr[i] < a || arr[i] > b || i > 0 && arr[i] < arr[i - 1]) {
            printf("Некорректное значение левой границы\n");
            free(arr);
            return 1;
        }
    }
    int* nums = malloc(sizeof(int) * n);
    for (int i = 0; i < n; i++) {
        nums[i] = rand() % (b - a + 1) + a;
    }
    int* res = calloc(k, sizeof(int));

    func(res, nums, k, n, arr);

    FILE* f = fopen("result.txt", "w");
    for(int i=0;i<n;i++){
        fprintf(f, "%d ", nums[i]);
    }
    fprintf(f, "\n\n");
    for (int i = 0; i < k; i++) {
        fprintf(f, "%d\t%d\t%d\n", i + 1, arr[i], res[i]);
    }
    fclose(f);
    free(arr);
    free(nums);
    free(res);
    return 0;
}