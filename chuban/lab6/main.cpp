#include <iostream>
#include <fstream>
#include <random>
#include <string>

using namespace std;

extern "C" void func(int* intervals, int N_int, int N, int* numbers, int* final_answer);

int main() {

    int N, X_min, X_max, N_int;

    cout << "Input count of numbers:\n";
    cin >> N;
    cout << "Input min value of numbers:\n";
    cin >> X_min;
    cout << "Input max value of numbers:\n";
    cin >> X_max;
    cout << "Input count of intervals:\n";
    cin >> N_int;

    if (N <= 0) {
        cout << "incorrect count of numbers\n";
        return 0;
    }

    if (X_min >= X_max) {
        cout << "incorrect X_min and X_max values\n";
        return 0;
    }

    if (N_int <= 0 || N_int > 24) {
        cout << "incorrect count of intervals\n";
        return 0;
    }

    cout << "Input left borders:" << endl;

    auto intervals = new int[N_int + 1];

    for (int i = 0; i < N_int; ++i) {
        cin >> intervals[i];

        if (intervals[i] < X_min || intervals[i] > X_max) {
            cout << "border should be in the [X_min, X_max] interval\n";
            delete[]intervals;
            return 0;
        }
    }

    cout << "input right border:\n";
    cin >> intervals[N_int];

    for (int i = 0; i < N_int-1; i++) {
        for (int j = i+1; j < N_int; j++) {
            if (intervals[j] < intervals[i]) {
                cout << "incorrect borders\n";
                return 0;
            }
        }
    }

    auto numbers = new int[N];
    random_device rd;
    mt19937 generator(rd());
    normal_distribution<> dist((X_max+X_min)/2);
    int i = 0;

    while(i < N){
        double curr = dist(generator);
        if (curr >= X_min && curr <= X_max) {
            numbers[i] = int(curr);
            i++;
        }
            
    }

    /*for (int j = 0; j < N; j++) {
        cout << numbers[j] << ' ';
    }*/

    cout << endl;

    auto final_answer = new int[N_int];

    for (int i = 0; i < N_int; i++) {
        final_answer[i] = 0;
    }
    func(intervals, N_int, N, numbers, final_answer);

    ofstream file("output.txt");
    auto str = "N\tBorders\tNumbers` count";
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