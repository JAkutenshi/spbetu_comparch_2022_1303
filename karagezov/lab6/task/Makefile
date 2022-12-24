all: main

main: main.o lib.o
	gcc main.o lib.o -o main -z noexecstack
main.o: main.c
	gcc -c main.c -o main.o
lib.o: lib.s
	as lib.s -mmnemonic=intel -msyntax=intel -mnaked-reg -o lib.o

clean:
	rm -rf *.o main
