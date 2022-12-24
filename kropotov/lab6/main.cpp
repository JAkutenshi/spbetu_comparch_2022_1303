#include <iostream>
#include <random>
#include <fstream>

using namespace std;

extern "C" {
    void firstFunc(int numCount, int tempResSize, int* numbers, int* tempIntervals, int* tempRes);

    void secondFunc(int tempResSize, int intCount, int* tempRes, int* tempIntervals, int* intervals, int* res);
}

int main() {
    int numCount, xMin, xMax, intCount;
    cin >> numCount;
    cin >> xMin >> xMax;
    if (xMin > xMax) {
        cout << "xMin is larger than xMax" << endl;
        exit(-1);
    }
    cin >> intCount;

    int* numbers = new int[numCount];
    int* intervals = new int[intCount + 1];
    for (int i = 0; i < intCount; i++) {
        cin >> intervals[i];
    }
    intervals[intCount] = xMax + 1;

    random_device rd;
    mt19937 gen(rd());
    uniform_int_distribution<> d(xMin, xMax);
    for (int i = 0; i < numCount; i++) {
        numbers[i] = d(gen);
    }

    fstream resFile;
    resFile.open("res.txt", ios::out | ios::trunc);
    for (int i = 0; i < numCount; i++) {
        cout << numbers[i] << ' ';
        resFile << numbers[i] << ' ';
    }
    cout << endl;
    resFile << endl;

    int tempResSize = xMax + 1 - intervals[0];
    int* tempIntervals = new int[tempResSize + 1];
    int* tempRes = new int[tempResSize] {0};
    for (int i = 0; i < tempResSize; i++) {
        tempIntervals[i] = intervals[0] + i;
    }
    tempIntervals[tempResSize] = xMax + 1;

    firstFunc(numCount, tempResSize, numbers, tempIntervals, tempRes);
    for (int i = 0; i < tempResSize; i++) {
        cout << "Temp interval number: " << i + 1 << "; left border: " << tempIntervals[i] << "; numbers quantity: " << tempRes[i] << endl;
        resFile << "Temp interval number: " << i + 1 << "; left border: " << tempIntervals[i] << "; numbers quantity: " << tempRes[i] << endl;
    }
    cout << endl;
    resFile << endl;

    int* res = new int[intCount] {0};
    secondFunc(tempResSize, intCount, tempRes, tempIntervals, intervals, res);
    for (int i = 0; i < intCount; i++) {
        cout << "Interval number: " << i + 1 << "; left border: " << intervals[i] << "; numbers quantity: " << res[i] << endl;
        resFile << "Interval number: " << i + 1 << "; left border: " << intervals[i] << "; numbers quantity: " << res[i] << endl;
    }

    resFile.close();
    delete[] numbers;
    delete[] intervals;
    delete[] res;
    return 0;
}

/*
20
-10 10
3
-8 1 5
*/
