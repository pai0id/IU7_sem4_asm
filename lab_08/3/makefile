build_partial:
	g++ ./partial/main.cpp -mfpmath=387 -mhard-float -o app_partial.exe

run_partial:
	./app_partial.exe

disassembly:
	g++ -c ./partial/main.cpp -mfpmath=387 -mhard-float -o diss.o
	objdump -d diss.o > disassembly_res

build_full:
	g++ ./full/main.cpp -mfpmath=387 -mhard-float -o app_full.exe

run_full:
	./app_full.exe

all: build_partial run_partial build_full run_full clean

clean: 
	rm -rf ./*.exe ./*.o
