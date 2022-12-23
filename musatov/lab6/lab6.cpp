#include <iostream>
#include <random>
#include <fstream>

using namespace std;

extern "C" {
    void func(int numRanDat, int nInt, int* nums, int* intervals, int* res);
}

int main() {
    int numRanDat, xMin, xMax, nInt;
    cin >> numRanDat;
    if (numRanDat <= 0 || numRanDat > 16000) {
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
    int* nums = new int[numRanDat];
    int* ints = new int[nInt + 1];
    for (int i = 0; i < nInt; i++) {
        cin >> ints[i];
        bool wrong = false;
        if (i > 0) {
            if (ints[i] < ints[i - 1]) {
                wrong = true;
            }
        }
        if (wrong) {
            cout << "Entered border is wrong" << endl;
            delete[] nums;
            delete[] ints;
            exit(-1);
        }
    }
    ints[nInt] = xMax + 1;
    random_device rd;
    mt19937 gen(rd());
    normal_distribution<> d(0, 1);
    int iter = 0;
    while (iter < numRanDat) {
        double value = round(d(gen));
        if (value >= xMin && value <= xMax) {
            nums[iter] = int(value);
            iter++;
        }
    }
    fstream outFile;
    outFile.open("result.txt", ios::out | ios::trunc);
    for (int i = 0; i < numRanDat; i++) {
        cout << nums[i] << ' ';
        outFile << nums[i] << ' ';
    }
    cout << endl;
    outFile << endl;
    int* res = new int[nInt] {0};
    func(numRanDat, nInt, nums, ints, res);
    for (int i = 0; i < nInt; i++) {
        cout << "Interval number: " << i + 1 << "; left border: " << ints[i] << "; numbers quantity: " << res[i] << endl;
        outFile << "Interval number: " << i + 1 << "; left border: " << ints[i] << "; numbers quantity: " << res[i] << endl;
    }
    outFile.close();
    delete[] nums;
    delete[] ints;
    delete[] res;
    return 0;
}
