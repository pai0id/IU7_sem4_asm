build:
	g++ main.cpp -mfpmath=387 -mhard-float -o app.exe

run:
	./app.exe

all: build run clean

disassembly:
	g++ -c diss.cpp -mfpmath=387 -mhard-float -o diss.o
	objdump -d diss.o > disassembly_res

clean: 
	rm -rf ./*.exe ./*.o