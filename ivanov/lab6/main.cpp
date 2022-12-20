#include <iostream>
#include <fstream>
#include <random>
#include <string>

using namespace std;

extern "C" {void handleNumbers(int* Array, int len, int* LGrInt, int NInt, int* answer); }

int main() {
	int NumRamDat, minX, maxX, NInt;
	cout << "Enter array length\n";
	cin >> NumRamDat;
	if (NumRamDat <= 0 || NumRamDat >= 16 * 1024) {
		std::cout << "Incorrect NumRamDat\n";
		return 1;
	}
	cout << "Enter minX and maxX\n";
	cin >> minX;
	cin >> maxX;
	if (minX >= maxX) {
		std::cout << "Invalid Xmin and Xmax values\n";
		return 1;
	}
	cout << "Enter number of intervals\n";
	cin >> NInt;

	if (NInt <= 0 || NInt > 24) {
		cout << "The number of intervals must be in [0; 24)\n";
		return 1;
	}


	cout << "Enter left borders\n";
	auto intervals = new int[NInt];
	for (int i = 0; i < NInt; ++i) {
		cin >> intervals[i];
		if ((intervals[i] < minX || intervals[i] > maxX) ||
			(i > 0 && intervals[i] <= intervals[i - 1])) {
			printf("Incorrect left border\n");
			return 1;
		}
	}



	auto numbers = new int[NumRamDat];
	random_device rd;
	mt19937 generator(rd());
	uniform_int_distribution<> dist(minX, maxX);
	for (int i = 0; i < NumRamDat; i++) {
		numbers[i] = dist(generator);
	}

	auto result = new int[NInt];

	for (int i = 0; i < NInt; i++) {
		result[i] = 0;
	}

	handleNumbers(numbers, NumRamDat, intervals, NInt, result);

	ofstream file("result.txt");
	file << "Numbers:\n";
	for (int i = 0; i < NumRamDat; ++i) {
		file << numbers[i] << " ";
	}
	file << "\nResult:\n";
	for (int i = 0; i < NInt; ++i) {
		file << "Border - " << "'" << intervals[i] << "'" << " has amount of numbers " << result[i] << "\n";
	}
	file.close();
	return 0;
}