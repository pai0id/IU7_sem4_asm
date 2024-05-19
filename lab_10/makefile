build:
	nasm -f elf64 -o main.o main.asm
	nasm -f elf64 -o calc.o calc.asm
	gcc `pkg-config --cflags gtk+-3.0` main.o calc.o -L/usr/lib/x86_64-linux-gnu -o main -lc `pkg-config --libs gtk+-3.0` -no-pie
	
run: build
	./main

clean:
	rm main ./*.o