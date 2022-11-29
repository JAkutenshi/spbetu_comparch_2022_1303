#include <iostream>
#include <fstream>
#include <random>


std::ofstream fileRandom;


extern "C" {void countNumbers(int* array, int totalNumbers, int* arrayLGrInt, int totalNInt, int* result); }

void randomArray(int*& array, int length, int min, int max) {
    std::random_device seed;
    std::mt19937 gen(seed());
    std::uniform_int_distribution<int> dist{ min, max };
    for (int i = 0; i < length; ++i) {
        array[i] = dist(gen);
    }
    fileRandom << "\n";
}

void printData(int length, int* array, int totalNInt, int* arrayLGrInt, int* result) {
    std::cout << "Random array: ";
    fileRandom << "Random array: ";
    for (int i = 0; i < length; ++i) {
        std::cout << array[i] << ' ';
        fileRandom << array[i] << ' ';
    }
    std::cout << '\n';
    fileRandom << '\n';
    std::cout << "Interval\t" << "Left border\t" << "Total inside\n";
    fileRandom << "Interval\t" << "Left border\t" << "Total inside\n";
    for (int i = 0; i < totalNInt; ++i) {
        std::cout << "    " << i + 1 << "\t        \t" << arrayLGrInt[i] << "\t" << result[i] << '\n';
        fileRandom << "    " << i + 1 << "\t        \t" << arrayLGrInt[i] << "\t" << result[i] << '\n';
    }
}



int main() {
    fileRandom.open("result.txt", std::ios_base::out);

    int totalNumbers;
    std::cout << "Total random numbers: ";
    std::cin >> totalNumbers;
    int* array = new int[totalNumbers];

    int left;
    std::cout << "Left border random numbers: ";
    std::cin >> left;

    int right;
    std::cout << "Right border random numbers: ";
    std::cin >> right;


    randomArray(array, totalNumbers, left, right);

    int totalNInt;
    std::cout << "Total left border: ";
    std::cin >> totalNInt;

    int* arrayLGrInt = new int[totalNInt];
    int tmp;
    for (int i = 0; i < totalNInt; ++i) {
        std::cin >> tmp;
        arrayLGrInt[i] = tmp;
    }
    
    std::sort(arrayLGrInt, arrayLGrInt + totalNInt);

    int* result = new int[totalNInt] {0};
    countNumbers(array, totalNumbers, arrayLGrInt, totalNInt, result);

    printData(totalNumbers, array, totalNInt, arrayLGrInt, result);


    delete[] array;
    delete[] arrayLGrInt;
    delete[] result;
    fileRandom.close();
    return 0;
}
