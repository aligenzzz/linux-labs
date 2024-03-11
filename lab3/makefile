CC=gcc
CFLAGS=-Wall -Werror
DEPS=./scripts/functions/functions.h
OBJ1=morse_encoder.o
OBJ2=morse_decoder.o
OBJ3=main.o

all: main

main: $(OBJ1) $(OBJ2) $(OBJ3)
	$(CC) $(CFLAGS) -o $@ $^
	make clean
	
morse_encoder.o: ./scripts/functions/morse_encoder.c $(DEPS)
	$(CC) $(CFLAGS) -c -o $@ $<

morse_decoder.o: ./scripts/functions/morse_decoder.c $(DEPS)
	$(CC) $(CFLAGS) -c -o $@ $<

main.o: ./scripts/main/main.c $(DEPS)
	$(CC) $(CFLAGS) -c -o $@ $<

test: all
	echo "HELPMEPLEASE" > test_input.txt
	touch encoded_output.txt
	./main -e test_input.txt encoded_output.txt
	touch decoded_output.txt
	./main -d encoded_output.txt decoded_output.txt
	diff -Z -s test_input.txt decoded_output.txt
	rm -f test_input.txt encoded_output.txt decoded_output.txt

clean:
	rm -f *.o 
