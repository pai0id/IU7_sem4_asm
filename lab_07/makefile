ASMFLAGS := -f elf64
CFLAGS := -std=c++23 -Wall -Werror -fverbose-asm
EXEC := app.exe

ASMC := nasm
CPPC := g++

all: build run clean

build:
	$(ASMC) $(ASMFLAGS) -o ass.o ass.asm
	$(CPPC) $(CFLAGS) -c main.cpp -o main.o
	$(CPPC) main.o ass.o -o $(EXEC)

run:
	./$(EXEC)

clean:
	rm -rf ./*.o ./*.exe
