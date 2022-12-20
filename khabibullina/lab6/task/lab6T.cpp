#include <iostream>
#include <fstream>

extern "C" {void function(int* Array, int len, int* LGrInt, int NInt, int* answer, int* ENum); }

std::ofstream file("result.txt");

int main()
{
    setlocale(LC_ALL, "Russian");
    int NumRamDat;
    int Xmin;
    int Xmax;
    int NInt;
    int* Array;
    int* LGrInt;
    srand(time(NULL));

    std::cout << "Введите количество элементов массива: ";
    std::cin >> NumRamDat;
    Array = new int[NumRamDat];

    std::cout << "Введите минимальное значение: ";
    std::cin >> Xmin;
    std::cout << "Введите максимальное значение: ";
    std::cin >> Xmax;

    if (Xmin >= Xmax) {
        std::cout << "Некорректные данные ;(";
        return 0;
    }

    for (int i = 0; i < NumRamDat; i++)
        Array[i] = Xmin + rand() % (Xmax - Xmin + 1);


    std::cout << "Введите количество интервалов: ";
    std::cin >> NInt;

    if (NInt < 0 || NInt > 24) {
        std::cout << "Некорректные данные ;(";
        return 0;
    }

    LGrInt = new int[NInt];

    std::cout << "Введите интервал\n";
    for (int i = 0; i < NInt; i++)
    {
        std::cout << "Интервал" << " " << i + 1 << ": ";
        std::cin >> LGrInt[i];
        if (LGrInt[i] > Xmax || LGrInt[i] < Xmin) {
            std::cout << "Некорректные данные";
            return 0;
        }
    }

    for (int i = 0; i < NInt; i++)
        for (int j = i; j < NInt; j++)
            if (LGrInt[i] > LGrInt[j])
                std::swap(LGrInt[i], LGrInt[j]);

    file << "Массив псевдослучайных чисел: ";
    std::cout << "Массив псевдослучайных чисел: ";
    for (int i = 0; i < NumRamDat; i++) {
        file << Array[i] << " ";
        std::cout << Array[i] << " ";
    }

    for (int i = 0; i < NumRamDat; i++)
        for (int j = i; j < NumRamDat; j++)
            if (Array[i] > Array[j])
                std::swap(Array[i], Array[j]);

    int* answer = new int[NInt] {0};
    int* ENum = new int[NInt] {0};
    function(Array, NumRamDat, LGrInt, NInt, answer, ENum);

    std::cout << "\n";
    std::cout << "Распределение псевдослучайных чисел по интервалам:\n";



    int j = 0;
    int split = answer[j];
    if (NInt != 0) std::cout << "| ";
    for (int i = 0; i < NumRamDat; i++) {
        if (i + 1 < split || NInt == 0) std::cout << Array[i] << " ";
        else {
            j++;
            split += answer[j];
            std::cout << Array[i] << " | ";
            file << Array[i] << " | ";
        }
    }


    std::cout << "\n\n";
    std::cout << "Индекс " << "Интервал " << "Количество" << "\tКоличество четных чисел" << std::endl;
    file << "\n\n";
    file << "Индекс " << "Интервал " << "Количество" << "\tКоличество четных чисел" << std::endl;

    for (int i = 0; i < NInt; i++) {
        std::cout << "  " << i + 1 << "\t  " << LGrInt[i] << "\t  " << answer[i] << "\t\t " << ENum[i] << '\n';
        file << "  " << i + 1 << "\t  " << LGrInt[i] << "\t  " << answer[i] << '\n';
    }

    file.close();
    return 0;

}