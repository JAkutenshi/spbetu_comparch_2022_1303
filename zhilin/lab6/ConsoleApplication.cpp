#include <iostream>
#include <random>
#include <fstream>

using namespace std;

extern "C" {
    void func(int n, int nInt, int* nums, int* intervals, int* res);
}

int main() {
    int n, xMin, xMax, nInt;
    cin >> n;
    if (n <= 0 || n > 16000) {
        cout << "Entered array length is wrong" << endl;
        exit(-1);
    }
    cin >> xMin >> xMax;
    if (xMin >= xMax) {
        cout << "Entered limits are wrong" << endl;
        exit(-1);
    }
    cin >> nInt;
    if (nInt <= 0 || nInt > 24) {
        cout << "Entered number of intervals is wrong" << endl;
        exit(-1);
    }
    int *nums = new int[n];
    int* intervals = new int[nInt + 1];
    for (int i = 0; i < nInt; i++) {
        cin >> intervals[i];
        bool wrongValue = false;
        if (intervals[i] <= xMin || intervals[i] >= xMax) {
            wrongValue = true;
        }
        if (i > 0) {
            if (intervals[i] < intervals[i - 1]) {
                wrongValue = true;
            }
        }
        if (wrongValue) {
            cout << "Entered border is wrong" << endl;
            delete[] nums;
            delete[] intervals;
            exit(-1);
        }
    }
    cin >> intervals[nInt];
    if (intervals[nInt] > xMax) {
        cout << "Entered border is wrong" << endl;
        delete[] nums;
        delete[] intervals;
        exit(-1);
    }
    random_device rd;
    mt19937 gen(rd());
    normal_distribution<> d(0, 2);
    int it = 0;
    while (it < n) {
        double value = round(d(gen));
        if (value >= xMin && value <= xMax) {
            nums[it] = int(value);
            it++;
        }
    }
    fstream outFile;
    outFile.open("res.txt", ios::out | ios::trunc);
    for (int i = 0; i < n; i++) {
        cout << nums[i] << ' ';
        outFile << nums[i] << ' ';
    }
    cout << endl;
    outFile << endl;
    int* res = new int[nInt]{0};
    func(n, nInt, nums, intervals, res);
    for (int i = 0; i < nInt; i++) {
        if (i < nInt - 1) {
            cout << "Interval number: " << i + 1 << "; left border: " << intervals[i] << "; numbers quantity: " << res[i] << endl;
            outFile << "Interval number: " << i + 1 << "; left border: " << intervals[i] << "; numbers quantity: " << res[i] << endl;
        } else {
            cout << "Interval number: " << i + 1 << "; left border: " << intervals[i] << "; last right border: " << intervals[nInt] << "; numbers quantity: " << res[i] << endl;
            outFile << "Interval number: " << i + 1 << "; left border: " << intervals[i] << "; last right border: " << intervals[nInt] << "; numbers quantity: " << res[i] << endl;
        }
    }
    outFile.close();
    delete[] nums;
    delete[] intervals;
    delete[] res;
    return 0;
}
