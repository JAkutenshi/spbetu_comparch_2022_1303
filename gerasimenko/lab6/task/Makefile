all: main

main: main.o lab6.o
	gcc main.o lab6.o -o main -z noexecstack
main.o: main.c
	gcc -c main.c -o main.o
lab6.o: lab6.s
	as lab6.s -mmnemonic=intel -msyntax=intel -mnaked-reg -o lab6.o

clean:
	rm -rf *.o main
