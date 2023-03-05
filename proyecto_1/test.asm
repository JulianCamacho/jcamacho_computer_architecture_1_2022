
%include "file_manager.asm" 

section .data
    output_filename db "7.txt", 0
    input_filename db "6.txt", 0
    mode     db 0x00           ; Modo de solo lectura
    buffer   times 16 db 0     ; Buffer para leer 16 bits a la vez
    input_fd dd 0              ; File descriptor para el archivo de entrada
    output_fd dd 0              ; File descriptor para el archivo de salida
 
section .text
    global _start

_start:
    mov edi, input_filename
    call open_file
    mov dword [input_fd], eax  ; Guardar el fd del valor de retorno

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
