ASMFLAGS := -f elf64
CFLAGS := -std=c++23 -Wall -Werror -fverbose-asm
EXEC := app.exe

ASMC := nasm
CPPC := g++

all: build run clean

build:
	# $(ASMC) $(ASMFLAGS) -o ass.o ass.s
	$(CPPC) $(CFLAGS) -c main.cpp -o main.o -lopencv_core -lopencv_imgcodecs -lopencv_imgproc
	$(CPPC) main.o -o $(EXEC) -lopencv_core -lopencv_imgcodecs -lopencv_imgproc

disassembly:
	$(CPPC) -c tmp.cpp -o diss.o
	objdump -d diss.o > disassembly_res

run:
	./$(EXEC)

clean:
	rm -rf ./*.o ./*.exe
