#include <iostream>
#include <fstream>
#include <ctime>
#include <string>

using namespace std;

extern "C" void f(int* inter, int* num, int* answer, int N_int, int N, int* max_arr);

int main() {

    srand(static_cast<unsigned int>(time(NULL)));

    int N, N_int, X_min, X_max;

    cout << "Enter the amount of numbers:\n";
    cin >> N;

    if (N <= 0) {
        cout << "Incorrect amount of numbers!\n";
        return 0;
    }

    cout << "Enter min value of numbers:\n";
    cin >> X_min;

    cout << "Enter max value of numbers:\n";
    cin >> X_max;

    if (X_min >= X_max) {
        cout << "Incorrect X_min and X_max values!\n";
        return 0;
    }

    cout << "Enter the amount of intervals:\n";
    cin >> N_int;

    if (N_int <= 0 || N_int > 24) {
        cout << "Incorrect amount of intervals!\n";
        return 0;
    }

    cout << "Enter left borders:" << endl;

    auto inter = new int[N_int + 1];

    for (int i = 0; i < N_int; i++) {
        cin >> inter[i];

        if (inter[i] < X_min || inter[i] > X_max) {
            cout << "The border should be in the [X_min, X_max] interval!\n";
            return 0;
        }
    }



    auto num = new int[N];

    int rand_val = X_max - X_min + 1;
    for (int i = 0; i < N; i++) {
        num[i] = X_min + rand() % rand_val;
    }

    cout << "The pseudo-random array is:\n";

    for (int j = 0; j < N; j++) {
        cout << num[j] << ' ';
    }

    cout << endl;

    auto answer = new int[N_int];

    for (int i = 0; i < N_int; i++) {
        answer[i] = 0;
    }

    int min = inter[0] - 1;
    auto max = new int[N_int];
    for (int i = 0; i < N_int; i++) {
        max[i] = min;
    }

    f(inter, num, answer, N_int, N, max);

    ofstream file("out.txt");
    auto str = "N\tBorders\tNumbers amount\tMax value";
    file << str << endl;
    cout << str << endl;
    for (int i = 0; i < N_int; i++) {
        auto str_res = to_string(i + 1) + "\t" + to_string(inter[i]) + "\t\t" + to_string(answer[i]) + "\t\t" + to_string(max[i]) + "\n";
        file << str_res;
        cout << str_res;
    }

    return 0;
}