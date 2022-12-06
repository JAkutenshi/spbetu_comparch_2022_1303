#include <iostream>
#include <fstream>
#include <cstdlib>
#include <ctime>
#include <cstdio>


extern "C" {void process_hits(int* Array, int len, int* LGrInt, int NInt, int* hits, int* maximums); }
std::ofstream file("result.txt");

int main() {
	srand(static_cast <unsigned int> (time(nullptr)));

	int NumRanDat = 0;
	int x_min = 0;
	int x_max = 0;
	int NInt = 0;

	std::cout << "Enter pseudo-random number array length..\n";
	std::cin >> NumRanDat;

	if (NumRanDat > 16 * 1024 || NumRanDat <= 0) {
		std::cout << "Wrong number array lenght!\n";
		return 1;
	}

	std::cout << "Enter Xmin value..\n";
	std::cin >> x_min;
	std::cout << "Enter Xmax value..\n";
	std::cin >> x_max;

	if (x_min >= x_max) {
		std::cout << "Xmin can't be more than Xmax!\n";
		return 1;
	}

	std::cout << "Enter number of split intervals..\n";
	std::cin >> NInt;

	if (NInt > 24 || NInt <= 0) {
		std::cout << "Invalid number of intervals\n";
		return 1;
	}

	int* n_arr = new int[NumRanDat];
	int* int_arr = new int[NInt];
	

	std::cout << "Enter left borders of intervals..\n";
	for (int i = 0; i < NInt; i++) {
		std::cout << "Left border #" << i + 1 << " = ";
		std::cin >> int_arr[i];
		if ((i > 0 && int_arr[i] <= int_arr[i - 1]) || (int_arr[i] < x_min || int_arr[i] > x_max)) {
			printf("Some border is wrong!\n");
			delete[] n_arr;
			delete[] int_arr;
			return 1;
		}
	}

	int rand_val = x_max - x_min + 1;
	for (int i = 0; i < NumRanDat; i++) {
		n_arr[i] = x_min + rand() % rand_val;
	}

	int* hits_arr = new int[NInt] {0};
	int* maximums = new int[NInt];
	for (int g = 0; g != NInt; g++)
	{
		maximums[g] = x_min;
	}
	process_hits(n_arr, NumRanDat, int_arr, NInt, hits_arr, maximums);

	std::cout << "Generated numbers:\n";
	file << "Generated numbers:\n";
	for (int i = 0; i < NumRanDat; ++i) {
		std::cout << n_arr[i] << " ";
		file << n_arr[i] << " ";
	}
	std::cout << "\nResults:\n";
	file << "\nResults:\n";

	for (int i = 0; i < NInt; i++) {
		if (maximums[i] != x_min)
		{
			std::cout << i + 1 << ") Left border:" << int_arr[i] << "; hits: " << hits_arr[i] << "; max in this interval = " << maximums
				[i] << '\n';
			file << i + 1 << ") Left border:" << int_arr[i] << "; hits: " << hits_arr[i] << "; max in this interval = " << maximums
				[i] << '\n';
		}
		else {
			std::cout << i + 1 << ") Left border:" << int_arr[i] << "; hits: " << hits_arr[i] << "; max in this interval not defined\n";
			file << i + 1 << ") Left border:" << int_arr[i] << "; hits: " << hits_arr[i] << "; max in this interval not defined\n";
		}
		}

	file.close();
	delete[] n_arr;
	delete[] int_arr;
	delete[] hits_arr;
	delete[] maximums;

	return 0;
};