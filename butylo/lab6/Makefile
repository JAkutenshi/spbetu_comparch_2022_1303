all: main

main: main.o source.o
    gcc main.o source.o -o main -z noexecstack

main.o: main.c
    gcc -c main.c

source.o: source.s
    as source.s -msyntax=intel -mnaked-reg -mmnemonic=intel -o source.o

clean:
    rm -f *.o main
