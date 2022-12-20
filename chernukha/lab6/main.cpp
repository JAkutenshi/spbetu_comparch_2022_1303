
#include <ctime>
#include <iostream>
#include <random>
#include <fstream>
extern "C" {void numcount(int* arr, int  NumsRat, int* arrLGrInt, int NInt, int* res); }
int main()
{
    srand(time(NULL));
    int NumRatDat;
    int Xmin;
    int Xmax;
    int NInt;
    std::cout << "Enter NumRatDat:\n";
    std::cin >> NumRatDat;
    while (NumRatDat >= 16 * 1024) {
        std::cout << "Incorrect value, try again:\n";
        std::cin >> NumRatDat;
    }
    std::cout << "Enter Xmin:\n";
    std::cin >> Xmin;
    std::cout << "Enter Xmax:\n";
    std::cin >> Xmax;
    std::cout << "Enter NInt:\n";
    std::cin >> NInt;
    while (NInt >= 24) {
        std::cout << "Incorrect value, try again:\n";
        std::cin >> NInt;
    }
    int* borders = new int[NInt];
    for (int i = 0; i < NInt; i++) {
        std::cout << "Enter left border#" << i + 1 << ":\n";
        std::cin >> borders[i];
        while ((borders[i] < Xmin || borders[i] > Xmax) || (i > 0 && borders[i] <= borders[i - 1])) {
            std::cout << "Incorrect value, try again:\n";
            std::cin >> borders[i];
        }
    }
    int* gennumbers = new int[NumRatDat];
    for (int i = 0; i < NumRatDat; i++) {
        gennumbers[i] = Xmin + rand() % (Xmax - Xmin + 1);
    }
    for (int i = 0; i < NumRatDat; i++) {
        std::cout << gennumbers[i] << " ";
    }
    std::cout << "\n";
    int* res = new int[NInt] {0};
    numcount(gennumbers, NumRatDat, borders, NInt, res);
    std::ofstream fl("res.txt");
    for (int i = 0; i < NInt; i++) {
        std::cout <<"left border "<< borders[i] << " have " << res[i] <<" numbers" << "\n";
        fl << "left border#"<<i+1 << ": " << borders[i] << " -- have " << res[i] << " numbers" << "\n";
    }
}



