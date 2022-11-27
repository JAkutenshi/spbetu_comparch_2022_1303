#include <stdio.h>
#include <stdlib.h>
#include <time.h>

extern void processing_intervals(int *result_array, int *source_array,
                                 int *borders_array, int number, int borders_number);

int main() {
    srand(time(NULL));

    int numbers = 0;
    int min_border = 0;
    int max_border = 0;
    int intervals = 0;

    printf("Enter the data: count of numbers, max and min borders, count of intervals\n");
    scanf("%d %d %d %d", &numbers, &min_border, &max_border, &intervals);

    if (numbers <= 0 || numbers > 16 * 1024) {
        printf("Invalid count of numbers\n");
        return 1;
    } else if (min_border >= max_border) {
        printf("Invalid max or min border\n");
        return 1;
    } else if (intervals <= 0 || intervals > 24) {
        printf("Invalid count of intervals\n");
        return 1;
    }

    int *numbers_array = malloc(numbers * sizeof(int));
    int *intervals_array = malloc(intervals * sizeof(int));

    printf("Enter left borders of intervals\n");
    char c;
    for (int i = 0; i < intervals; ++i) {
        scanf("%d%c", &intervals_array[i], &c);
        if ((intervals_array[i] < min_border || intervals_array[i] > max_border) ||
            (i > 0 && intervals_array[i] <= intervals_array[i - 1])) {
            printf("Invalid left border!\n");
            goto error_free_sources;
        }
    }

    int rand_max = max_border - min_border + 1;
    for (int i = 0; i < numbers; ++i) {
        numbers_array[i] = min_border + rand() % rand_max;
    }

    int *resultArray = calloc(intervals, sizeof(int));
    processing_intervals(resultArray, numbers_array, intervals_array, numbers, intervals);

    FILE *f = fopen("results.txt", "w");
    if (!f) {
        printf("Error creating file");
        goto error_free_result;
    }

    fputs("Generated numbers:\n", f);
    for (int i = 0; i < numbers; ++i) {
        fprintf(f, "%d ", numbers_array[i]);
    }

    fputs("\n\n", f);
    fputs("Results:\n", f);
    for (int i = 0; i < intervals; ++i) {
        fprintf(f, "%d   %d   %d\n", i + 1, intervals_array[i], resultArray[i]);
    }

    fclose(f);

    return 0;

    error_free_result:
    free(resultArray);
    error_free_sources:
    free(numbers_array);
    free(intervals_array);
    return 1;
};