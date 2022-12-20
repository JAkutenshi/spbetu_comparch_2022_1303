#include <iostream>
#include <stdlib.h>


int main() {
	double x;
	std::cout << "Enter x:\n";
	std::cin >> x;

	int n;
	std::cout << "Enter number of constants:\n";
	std::cin >> n;

	double *constants = new double[n];
	std::cout << "Enter constants:\n";
	for (int i = 0; i < n; ++i) {
		std::cout << "[" << i << "]: ";
		std::cin >> constants[i];
	}

	double result = 0;
	__asm {
		fld qword ptr x
		fldz
		mov edi, n
		mov esi, constants
		test  edi, edi
		je    skip
		mov   ecx, edi
		poly_proc :
		fmul  st(0), st(1)
			fadd qword ptr[esi + ecx * 8 - 8]
			loop  poly_proc
			skip :
		fst qword ptr result

	};
	
	std::cout << "Result = " << result;
	delete[] constants;

	return 0;
}
