
%include "file_manager.asm" 

section .data
    filename db "6.txt", 0
    mode     db 0x00           ; Modo de solo lectura
    buffer   times 16 db 0     ; Buffer para leer 16 bits a la vez
    fd       dd 0              ; File descriptor

section .text
    global _start

_start:
    call open_file

read_loop:
    call read_file

    cmp eax, 0           ; Verificar si es el final del archivo
    ;jle done            ; Si lo es, ir a cerrarlo

    call print_buffer
    jle done
    ;jmp read_loop

done:
    call close_file

    ; Salir
    mov eax, 1
    xor ebx, ebx        
    int 0x80            
