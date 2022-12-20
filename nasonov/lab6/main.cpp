#include <iostream>
#include <fstream>
#include <random>
#include <string>

using namespace std;

extern "C" void func(int* intervals, int interval_count, int number_count, int* numbers, int* result);

int main() {
	system("chcp 1251 > nul");
	setlocale(LC_CTYPE, "rus");

	int number_count, min_value, max_value, interval_count;

	cout << "������� ���������� �����:" << endl;
	cin >> number_count;

	cout << "������� �������� ���������:" << endl;
	cin >> min_value >> max_value;

	int max_intervals = max_value - min_value - 1;
	cout << "������� ���������� ���������� ( �� 1 �� " << max_intervals << " ):" << endl;
	cin >> interval_count;

	if (interval_count <= 0 || interval_count > abs(max_intervals)) {
		cout << "���������� ���������� ������ ���� ( �� 1 �� " << max_intervals << " )." << endl;
		return 0;
	}

	cout << "������� ����� ������� ( �� " << min_value + 1 << " ):" << endl;
	int* intervals = new int[interval_count + 1];
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

	if (intervals[0] <= min_value) {
		cout << "��� ������� ������ ���� > ���. ����." << endl;
		return 0;
	}

	cout << "������� ������ ������� (�� " << max_value + 1 << " ):" << endl;
	cin >> intervals[interval_count];

	if (intervals[interval_count] < intervals[interval_count - 1]) {
		cout << "������ ������� ����. ��������� ������ ���� >= ����� ������� ����. ���������." << endl;
		return 0;
	}

	if (intervals[interval_count] <= max_value) {
		cout << "������ ������� ���������� ��������� ������ ���� > ����. ����." << endl;
		return 0;
	}

	int *numbers = new int[number_count];
	random_device rd;
	mt19937 generator(rd());
	
	uniform_int_distribution<> dist(min_value, max_value);
	for (int i = 0; i < number_count; i++) {
		numbers[i] = dist(generator);
		cout << numbers[i] << ", ";
	}
	cout << endl;

	int* result = new int[interval_count];

	for (int i = 0; i < number_count; i++) {
		result[i] = 0;
	}

	func(intervals, interval_count, number_count, numbers, result);

	ofstream file("output.txt");
	string info = "#\t�������\t���-�� �����";
	file << info << endl;
	cout << info << endl;
	for (int i = 0; i < interval_count; i++) {
		string row = to_string(i + 1) + "\t" + to_string(intervals[i]) + "\t\t" + to_string(result[i]) + "\n";
		file << row;
		cout << row;
	}
	return 0;
}