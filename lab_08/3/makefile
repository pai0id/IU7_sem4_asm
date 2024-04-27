build:
	g++ main.cpp -mfpmath=387 -mhard-float -o app.exe

run:
	./app.exe

all: build run all

disassembly:
	g++ -c main.cpp -mfpmath=387 -mhard-float -o main.o
	objdump -d main.o > tmp

clean: 
	rm -rf ./*.exe ./*.o
