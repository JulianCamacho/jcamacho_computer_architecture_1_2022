all:
	if [ -e output.txt ]; then rm output.txt; fi
	nasm -f elf32 -o main.o main.asm
	ld -m elf_i386 -o main main.o 
	./main
	python3 display.py