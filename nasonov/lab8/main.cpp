#include <iostream>
#include <stdlib.h>

using namespace std;

int main() {
	double x;
	cout << "Enter x:\n";
	cin >> x;

	int amount;
	cout << "Enter amount of coefficients:\n";
	cin >> amount;

	double* coefficients = new double[amount];
	cout << "Enter coefficients:\n";
	for (int i = 0; i < amount; ++i) {
		cout << i + 1 << ") ";
		cin >> coefficients[i];
	}

	double result = 0;

	__asm {
		fld qword ptr x  ; load a real number into the stack FPU
		fldz  ; load the +0.0 into the stack FPU
		mov edi, amount
		mov esi, coefficients
		test edi, edi
		je skip  ; amount = 0
		mov ecx, edi
		poly:
			fmul st(0), st(1)
			fadd qword ptr[esi + ecx * 8 - 8]
			loop  poly
		skip:
			fst qword ptr result
	};

	cout << "Result: " << result;
	delete[] coefficients;

	return 0;
}