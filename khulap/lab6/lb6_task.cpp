#include <iostream>
#include <fstream>
#include <random>

std::ofstream file;

extern "C" {void first(int* array, int len, int x_min, int x_max, int* arr_out); }
extern "C" {void second(int* array, int NInt, int x_min, int* gr, int* arr_out, int* arr_min); }
extern "C" {void second_task(int* array, int NInt, int x_min, int* gr, int* arr_min); }

void generate_array(int*& arr, int NumRamDat, int min, int max);

void receive(int& NumRamDat, int*& arr, int& min, int& max, int& NInt, int*& LGrInt) {
    std::cout << "Enter length of the array" << std::endl;
    std::cin >> NumRamDat;
    arr = new int[NumRamDat];
    std::cout << "Enter limits of random numbers:" << std::endl << "Min:";
    std::cin >> min;
    std::cout << "Max:";
    std::cin >> max;

    while (min >= max) {
        std::cout << "Invalid Xmax, enter Xmax again:";
        std::cin >> max;
    }
    
    generate_array(arr, NumRamDat, min, max);
    
    std::cout << "Enter number of intervals:";
    std::cin >> NInt;
    
    while (NInt < 0 || NInt > 24) {
        std::cout << "Invalid NInt, enter NInt again:";
        std::cin >> NInt;
    }
    
    LGrInt = new int[NInt + 1];
    std::cout << "Enter intervals:" << std::endl;
    
    for (int i = 0; i < NInt; i++)
    {
        std::cout << "Interval " << i + 1 << ": ";
        std::cin >> LGrInt[i];
        
        while (LGrInt[i] > max || LGrInt[i] < min) {
            std::cout << "Invalid interval, enter the interval again:";
            std::cin >> LGrInt[i];
        }
    }
    
    LGrInt[NInt] = max + 1;
    std::sort(LGrInt, LGrInt + NInt);
}

void generate_array(int*& arr, int NumRamDat, int min, int max) {
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> dist(min, max);
    
    for (int i = 0; i < NumRamDat; i++) {
        arr[i] = dist(gen);
    }
}

void print(int NInt, int NumRamDat, int*& arr, int*& LGrInt, int*& answer) {
    std::cout << "Generated array:" << std::endl;
    
    for (int i = 0; i < NumRamDat; i++){
        std::cout << arr[i] << " ";
    }
    
    std::cout << std::endl;
    file << std::endl;
    std::cout << "Index\t" << "Border\t" << "Count" << std::endl;
    file << "Index\t" << "Border\t" << "Count" << std::endl;
    
    for (int i = 0; i < NInt; i++) {
        std::cout << "  " << i + 1 << "\t  " << LGrInt[i] << "\t  " << answer[i] << std::endl;
        file << "  " << i + 1 << "\t  " << LGrInt[i] << "\t  " << answer[i] << std::endl;
    }
}


void task_print(int* arr, int* gr, int n) {
    std::cout << "Index\t" << "Border\t" << "Minimum" << std::endl;
    file << "Index\t" << "Border\t" << "Minumum" << std::endl;
    
    for (int i = 0; i < n; i++) {
        std::cout << " " << i + 1 << "\t " << gr[i] << "\t " << arr[i] << std::endl;
        file << " " << i + 1 << "\t " << gr[i] << "\t " << arr[i] << std::endl;
    }
}

int main()
{
    file.open("answer.txt", std::ios_base::out);
    int NumRamDat;
    int Xmin;
    int Xmax;
    int NInt;
    int* arr;
    int* LGrInt;
    
    receive(NumRamDat, arr, Xmin, Xmax, NInt, LGrInt);
    
    int* answer_arr = new int[Xmax - Xmin + 1]{ 0 };
    int* arr_out = new int[NInt] {0};
    int* arr_min = new int[NInt] {0};

    first(arr, NumRamDat, Xmin, Xmax, answer_arr);
    std::cout << std::endl;
    
    second(answer_arr, NInt, Xmin, LGrInt, arr_out, arr_min);
    std::cout << std::endl;
    print(NInt, NumRamDat, arr, LGrInt, arr_out);
    
    std::cout << std::endl;
    
    second_task(answer_arr, NInt, Xmin, LGrInt, arr_min);
    task_print(arr_min, LGrInt, NInt);
    
    delete[] arr;
    delete[] LGrInt;
    delete[] answer_arr;
    
    file.close();
}