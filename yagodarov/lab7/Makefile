all: main

main: main.o
	ld main.o -o main

main.o: main.s
	as main.s -msyntax=intel -mmnemonic=intel -mnaked-reg -o main.o

clean:
	rm -f *.o main
