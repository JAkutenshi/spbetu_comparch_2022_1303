#include <cstdio>
#include <cstdlib>
#include <ctime>
#include <iostream>
#include <fstream>


std::ofstream file("out.txt");

extern "C" {void function(int* Array, int len, int* LGrInt, int NInt, int* answer); }


int main() {
	srand(static_cast<unsigned int>(time(nullptr)));

	int NumRanDat = 0;
	int x_min = 0;
	int x_max = 0;

	int NInt = 0;

	std::cout << "Enter random number array lenght\n";
	std::cin >> NumRanDat;
	if (NumRanDat <= 0 || NumRanDat > 16 * 1024) {
		std::cout << "Invalid random number array lenght\n";
		return 1;
	}

	std::cout << "Enter Xmin value\n";
	std::cin >> x_min;
	std::cout << "Enter Xmax value\n";
	std::cin >> x_max;
	if (x_min >= x_max) {
		std::cout << "Invalid Xmin and Xmax values\n";
		return 1;
	}

	std::cout << "Enter number of intervals\n";
	std::cin >> NInt;
	if (NInt <= 0 || NInt > 24) {
		std::cout << "Invalid number of intervals\n";
		return 1;
	}


	int *n_arr = new int[NumRanDat];
	int *int_arr = new int[NInt];

	std::cout << "Enter left borders of intervals\n";
	for (int i = 0; i < NInt; ++i) {
		std::cout << "Left border" << i + 1 << " = ";
		std::cin >> int_arr[i];
		if ((int_arr[i] < x_min || int_arr[i] > x_max) ||
			(i > 0 && int_arr[i] <= int_arr[i - 1])) {
			printf("Invalid left border!\n");
			delete[] n_arr;
			delete[] int_arr;
			return 1;
		}
	}



	int rand_max = x_max - x_min + 1;
	for (int i = 0; i < NumRanDat; ++i) {
		n_arr[i] = x_min + rand() % rand_max;
	}

	int *res_arr = new int[NInt] {0};
	function(n_arr, NumRanDat, int_arr, NInt, res_arr);


	file << "Generated numbers:\n";
	for (int i = 0; i < NumRanDat; ++i) {
		file << n_arr[i] << " ";
	}
	file << "\n\nResults:\n";
	for (int i = 0; i < NInt; ++i) {
		file << i + 1 << ". left border:" << int_arr[i] << "  numbers - " << res_arr[i] << "\n";
	}

	file.close();
	delete[] n_arr;
	delete[] int_arr;
	delete[] res_arr;

	return 0;
};