#include <iostream>
#include <fstream>
#include <random>
#include <string>

using namespace std;

extern "C" void func(int* intervals, int N_int, int N, int* numbers, int* final_answer, int* sum, int* average_answer);

int main() {
	system("chcp 1251 > nul");
	setlocale(LC_CTYPE, "rus");

	int N, X_min, X_max, N_int;
	cout << "Введите количество чисел:" << endl;
	cin >> N;
	cout << "Введите диапазон генерации:" << endl;
	cin >> X_min >> X_max;
	cout << "Введите количество интервалов:" << endl;
	cin >> N_int;

	if (N_int <= 0 || N_int > 24) {
		cout << "Количество интервалов должно быть от 0 до 24" << endl;
		system("Pause");
		return 0;
	}

	if (N_int < abs(X_max - X_min)) {
		cout << "Количество интервалов должно быть больше или равно Xmax - Xmin" << endl;
		system("Pause");
		return 0;
	}

	cout << "Введите левые границы:" << endl;
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
		cout << "Хотя бы одна левая граница должна быть меньше или равна Xmin" << endl;
		system("Pause");
		return 0;
	}

	cout << "Введите правую границу:" << endl;
	cin >> intervals[N_int];

	if (intervals[N_int] < intervals[N_int - 1]) {
		cout << "Правая граница последнего интервала должна быть больше левой границы последего интервала" << endl;
		system("Pause");
		return 0;
	}

	if (intervals[N_int] > X_max) {
		cout << "Правая граница последнего интервала должна быть меньше или равна X_max!" << endl;
		system("Pause");
		return 0;
	}

	auto numbers = new int[N];
	random_device rd;
	mt19937 generator(rd());
	/*
	normal_distribution<> dist(0.05,1.3);
	for (int i = 0; i < N; i++) {
		int a = dist(generator);
		if (a >= X_min && a <= intervals[N_int])
			numbers[i] = int(a);
		//cout << numbers[i] << " ";
	}*/

	uniform_int_distribution<> dist(X_min, X_max);
	for (int i = 0; i < N; i++) {
		numbers[i] = dist(generator);
		cout << numbers[i] << " ";
	}
	cout << endl;

	auto final_answer = new int[N_int];
	auto sum = new int[N_int];
	auto average_answer = new int[N_int];

	for (int i = 0; i < N_int; i++) {
		final_answer[i] = 0;
		sum[i] = 0;
		average_answer[i] = 0;
	}
	func(intervals, N_int, N, numbers, final_answer, sum, average_answer);
	
	for (int i = 0; i < N_int; i++) {
		cout << sum[i] << " ";
	}

	cout << endl;

	for (int i = 0; i < N_int; i++) {
		cout << average_answer[i] << " ";
	}

	cout << endl;

	ofstream file("output.txt");
	auto str = "N\tГраницы\tКоличество чисел\tСреднее значение";
	file << str << endl;
	cout << str << endl;
	for (int i = 0; i < N_int; i++) {
		auto str_res = to_string(i + 1) + "\t" + to_string(intervals[i]) + "\t\t" + to_string(final_answer[i]) + "\t\t" + to_string(average_answer[i]) + "\n";
		file << str_res;
		cout << str_res;
	}
	system("Pause");
	return 0;
}
