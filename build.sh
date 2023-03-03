nasm -f elf32 src/kernel.asm -o bin/kasm.o
gcc -fno-stack-protector -m32 -c src/kernel.c -o bin/kc.o
ld -m elf_i386 -T src/link.ld -o boot/kernel bin/kasm.o bin/kc.o
kvm  -kernel boot/kernel