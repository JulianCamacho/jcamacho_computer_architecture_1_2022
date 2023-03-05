
%include "file_manager.asm" 

section .data
    output_filename     db "7.txt", 0
    input_filename      db "6.txt", 0
    buffer   times 18   db 0              ; Buffer para leer 16 bits a la vez
    input_fd            dd 0              ; File descriptor para el archivo de entrada
    output_fd           dd 0              ; File descriptor para el archivo de salida
    pixel               dw 0x12           ; Pixel desencriptado por guardar

section .text
    global _start

_start:
    call open_input_file
    call read_file
    cmp eax, 0           ; Verificar si es el final del archivo
    call print_buffer
    call close_input_file

    call open_ouput_file
    mov  ebx, [buffer]
    mov  [pixel], ebx 
    call write_file
    call close_output_file

    ; Salir
    mov eax, 1
    xor ebx, ebx        
    int 0x80            