all:
	#nasm -f elf64 -o test.o test.asm
	#ld -s -o test test.o
	#./test

	nasm -f elf32 -o test.o test.asm
	ld -m elf_i386 -o test test.o 
	./test