all: main

main: main.o lib.o
	gcc main.o lib.o -o main -z noexecstack -lm

main.o: main.c
	gcc -c main.c

lib.o: lib.s
	as lib.s -msyntax=intel -mnaked-reg -mmnemonic=intel -o lib.o

clean:
	rm -f *.o main
