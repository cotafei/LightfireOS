bits 32
section .text
        ;multiboot spec
        align 4
        dd 0x1BADB002              ;magic
        dd 0x00                    ;flags
        dd - (0x1BADB002 + 0x00)   ;checksum. m+f+c should be zero

global start
global keyboard_handler
global read_port
global write_port
global load_idt
global page_directory

extern kmain 		;this is defined in the c file
extern keyboard_handler_main

read_port:
	mov edx, [esp + 4]
			;al is the lower 8 bits of eax
	in al, dx	;dx is the lower 16 bits of edx
	ret

write_port:
	mov   edx, [esp + 4]    
	mov   al, [esp + 4 + 4]  
	out   dx, al  
	ret

load_idt:
	mov edx, [esp + 4]
	lidt [edx]
	sti 				;turn on interrupts
	ret

page_directory:
    mov eax, page_directory
    mov cr3, eax
 
    mov eax, cr4
    or eax, 0x00000010
    mov cr4, eax

keyboard_handler:                 
	call    keyboard_handler_main
	iretd


start:
	cli 				;block interrupts
	mov esp, stack_space
	call kmain
	hlt 				;halt the CPU
	mov edi, 0xB8000
    mov esi, string
    mov ah, 0x0F
   .displaying:
    lodsb
    stosw
    or al, al
    jnz .displaying
    jmp short $

section .bss
resb 8192; 8KB for stack
stack_space: