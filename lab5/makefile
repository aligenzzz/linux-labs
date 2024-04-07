CC=gcc
CFLAGS=-Wall -Werror

all: main

main: main.o
	$(CC) $(CFLAGS) -o $@ $^
	make clean

main.o: main.c 
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm -f *.o