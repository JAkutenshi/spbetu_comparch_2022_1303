#include <cstdio>
#include <cstdlib>
#include <ctime>
#include <iostream>
#include <fstream>

std::ofstream file("out.txt");

extern "C" {void function(int* Digits, int len, int* LBInt, int NInt, int* result); }

int main() {
	srand(static_cast<unsigned int>(time(nullptr)));
	int NumLen = 0;
	int MinX = 0;
	int MaxX = 0;
	int NInt = 0;
	std::cout << "Enter random number array length\n";
	std::cin >> NumLen;
	if (NumLen <= 0 || NumLen > 16 * 1024) {
		std::cout << "Invalid number array length\n";
		return 1;
	}
	std::cout << "Enter min value\n";
	std::cin >> MinX;
	std::cout << "Enter max value\n";
	std::cin >> MaxX;
	if (MinX >= MaxX) {
		std::cout << "Invalid min and max values\n";
		return 1;
	}
	std::cout << "Enter number of intervals\n";
	std::cin >> NInt;
	if (NInt <= 0 || NInt > 24) {
		std::cout << "Invalid number of intervals\n";
		return 1;
	}
	int* n_arr = new int[NumLen];
	int* int_arr = new int[NInt];
	std::cout << "Enter array of left borders\n";
	for (int i = 0; i < NInt; ++i) {
		std::cout << "Left border" << i + 1 << " = ";
		std::cin >> int_arr[i];
		if ((int_arr[i] < MinX || int_arr[i] > MaxX) ||
			(i > 0 && int_arr[i] <= int_arr[i - 1])) {
			printf("Invalid left border!\n");
			delete[] n_arr;
			delete[] int_arr;
			return 1;
		}
	}
	int range = MaxX - MinX + 1;
	for (int i = 0; i < NumLen; ++i) {
		n_arr[i] = MinX + rand() % range;
	}
	int* res_arr = new int[NInt] {0};
	function(n_arr, NumLen, int_arr, NInt, res_arr);
	std::cout << "Generated numbers:\n";
	file << "Generated numbers:\n";
	for (int i = 0; i < NumLen; ++i) {
		std::cout << n_arr[i] << " ";
		file << n_arr[i] << " ";
	}
	std::cout << "\n\nResults:\n";
	file << "\n\nResults:\n";
	for (int i = 0; i < NInt; ++i) {
		std::cout << i + 1 << ". left border:" << int_arr[i] << "  amount of numbers - " << res_arr[i] << "\n";
		file << i + 1 << ". left border:" << int_arr[i] << "  amount of numbers - " << res_arr[i] << "\n";
	}
	file.close();
	delete[] n_arr;
	delete[] int_arr;
	delete[] res_arr;

	return 0;
};