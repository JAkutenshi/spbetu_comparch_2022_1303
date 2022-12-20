#include <iostream>
#include <fstream>
#include <random>
#include <string>

using namespace std;

extern "C" void func(int* intervals, int interval_count, int number_count, int* numbers, int* result, int *maxs);

int main() {
	system("chcp 1251 > nul");
	setlocale(LC_CTYPE, "rus");

	int number_count, min_value, max_value, interval_count;

	cout << "\nВведите количество чисел:" << endl;
	cin >> number_count;

	cout << "\nВведите диапазон генерации:" << endl;
	cin >> min_value >> max_value;

	cout << "\nВведите количество интервалов:" << endl;
	cin >> interval_count;

	if (interval_count <= 0 || interval_count > 24) {
		cout << "\nКоличество интервалов должно быть от 0 до 24" << endl;
		return 0;
	}

	if (interval_count < abs(max_value - min_value)) {
		cout << "\nКоличество интервалов должно быть >= Xmax - Xmin" << endl;
		return 0;
	}

	cout << "\nВведите левые границы:" << endl;
	int *intervals = new int[interval_count + 1];
	for (int i = 0; i < interval_count; ++i) {
		cin >> intervals[i];
	}

	for (int i = 0; i < interval_count; i++) {
		for (int j = i; j < interval_count; j++) {
			if (intervals[i] > intervals[j]) {
				swap(intervals[i], intervals[j]);
			}
		}
	}

	if (intervals[0] > min_value) {
		cout << "\nХотя бы одна левая граница должна быть <= Xmin" << endl;
		return 0;
	}

	cout << "\nВведите правую границу:" << endl;
	cin >> intervals[interval_count];

	if (intervals[interval_count] < intervals[interval_count - 1]) {
		cout << "\nПравая граница последнего интервала должна быть > левой границы последего интервала" << endl;
		return 0;
	}

	if (intervals[interval_count] > max_value) {
		cout << "\nПравая граница последнего интервала должна быть <= max_value!" << endl;
		return 0;
	}

	int *numbers = new int[number_count];
	random_device rd;
	mt19937 generator(rd());

	uniform_int_distribution<> dist(min_value, max_value);
	cout << "\nСгенерированные числа:" << endl;
	for (int i = 0; i < number_count; i++) {
		numbers[i] = dist(generator);
		cout << numbers[i] << " ";
	}
	cout << endl;

	int *result = new int[interval_count];

	int* maxs = new int[interval_count];

	int minimum = intervals[0] - 1;

	for (int i = 0; i < interval_count; i++) {
		result[i] = 0;
		maxs[i] = minimum;
	}

	func(intervals, interval_count, number_count, numbers, result, maxs);

	ofstream file("output.txt");
	string info = "\n#\tГраницы\tКол-во чисел\tМаксимумы";
	file << info << endl;
	cout << info << endl;
	for (int i = 0; i < interval_count; i++) {
		string str = to_string(i + 1) + "\t" + to_string(intervals[i]) + "\t" + to_string(result[i]);
		if (result[i] > 0)
			str += "\t\t" + to_string(maxs[i]);
		str += "\n";
		file << str;
		cout << str;
	}
	return 0;
}