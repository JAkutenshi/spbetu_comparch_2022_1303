#include <iostream>
#include <fstream>
#include <random>
#include <string>

using namespace std;

extern "C" {void function(int* Array, int len, int* LGrInt, int NInt, int* answer); }

int main() {
	int N, X_min, X_max, N_int;
	cout << "Enter array length:\n";
	cin >> N;
	if (N <= 0 || N > 16 * 1024) {
		std::cout << "Invalid array lenght\n";
		return 1;
	}
	cout << "Enter x-min and x-max:\n";
	cin >> X_min >> X_max;
	if (X_min >= X_max) {
		std::cout << "Invalid Xmin and Xmax values\n";
		return 1;
	}
	cout << "Enter number of intervals\n";
	cin >> N_int;

	if (N_int <= 0 || N_int > 24) {
		cout << "The number of intervals must be between 0 and 24\n";
		return 1;
	}


	cout << "Enter left borders:\n";
	auto intervals = new int[N_int];
	for (int i = 0; i < N_int; ++i) {
		cin >> intervals[i];
		if ((intervals[i] < X_min || intervals[i] > X_max) ||
			(i > 0 && intervals[i] <= intervals[i - 1])) {
			printf("Invalid left border!\n");
			delete[] intervals;
			return 1;
		}
	}



	auto numbers = new int[N];
	random_device rd;
	mt19937 generator(rd());
	uniform_int_distribution<> dist(X_min, X_max);
	for (int i = 0; i < N; i++) {
		numbers[i] = dist(generator);
	}

	auto result = new int[N_int];

	for (int i = 0; i < N_int; i++) {
		result[i] = 0;
	}

	function(numbers, N, intervals, N_int, result);

	ofstream file("result.txt");
	file << "Generated numbers:\n";
	for (int i = 0; i < N; ++i) {
		file << numbers[i] << " ";
	}
	file << "\n\nResults:\n";
	for (int i = 0; i < N_int-1; ++i) {
		file << "borders: " << intervals[i] << " - " << intervals[i + 1] - 1 << "  amount of numbers - " << result[i] << "\n";
	}
	file << "borders: " << intervals[N_int-1] << " - " << X_max << "  amount of numbers - " << result[N_int - 1] << "\n";
	file.close();
	delete[] intervals;
	delete[] result;
	delete[] numbers;
	return 0;
}