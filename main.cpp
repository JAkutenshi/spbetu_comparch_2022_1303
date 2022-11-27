#include <iostream>
#include <fstream>
#include <random>
#include <string>

using namespace std;

extern "C" void func(int* intervals, int N_int, int N, int* numbers, int* final_answer);

int main() {
	system("chcp 1251 > nul");
	setlocale(LC_CTYPE, "rus");

	int N, X_min, X_max, N_int;
	cout << "¬ведите количество чисел:" << endl;
	cin >> N;
	cout << "¬ведите диапазон генерации:" << endl;
	cin >> X_min >> X_max;
	cout << "¬ведите количество интервалов:" << endl;
	cin >> N_int;

	if (N_int <= 0 || N_int > 24) {
		cout << " оличество интервалов должно быть от 0 до 24" << endl;
		system("Pause");
		return 0;
	}

	if (N_int < abs(X_max - X_min)) {
		cout << " оличество интервалов должно быть больше или равно Xmax - Xmin" << endl;
		system("Pause");
		return 0;
	}

	cout << "¬ведите левые границы:" << endl;
	auto intervals = new int[N_int + 1];
	for (int i = 0; i < N_int; ++i) {
		cin >> intervals[i];
	}

	for (int i = 0; i < N_int; i++) {
		for (int j = i; j < N_int; j++) {
			if (intervals[i] > intervals[j]) {
				swap(intervals[i], intervals[j]);
			}
		}
	}

	if (intervals[0] > X_min) {
		cout << "’от€ бы одна лева€ граница должна быть меньше или равна Xmin" << endl;
		system("Pause");
		return 0;
	}

	cout << "¬ведите правую границу:" << endl;
	cin >> intervals[N_int];

	if (intervals[N_int] < intervals[N_int - 1]) {
		cout << "ѕрава€ граница последнего интервала должна быть больше левой границы последего интервала" << endl;
		system("Pause");
		return 0;
	}

	if (intervals[N_int] > X_max) {
		cout << "ѕрава€ граница последнего интервала должна быть меньше или равна X_max!" << endl;
		system("Pause");
		return 0;
	}

	auto numbers = new int[N];
	random_device rd;
	mt19937 generator(rd());
	uniform_int_distribution<> dist(X_min, X_max);
	for (int i = 0; i < N; i++) {
		numbers[i] = dist(generator);
		cout << numbers[i] << " ";
	}
	cout << endl;

	auto final_answer = new int[N_int];

	for (int i = 0; i < N_int; i++) {
		final_answer[i] = 0;
	}

	func(intervals, N_int, N, numbers, final_answer);

	ofstream file("output.txt");
	auto str = "N\tBorders\tThe Amount of numbers";
	file << str << endl;
	cout << str << endl;
	for (int i = 0; i < N_int; i++) {
		auto str_res = to_string(i + 1) + "\t" + to_string(intervals[i]) + "\t\t" + to_string(final_answer[i]) + "\n";
		file << str_res;
		cout << str_res;
	}

	system("Pause");
	return 0;
}
