
%include "file_manager.asm" 

section .data
    output_filename     db "7.txt", 0
    input_filename      db "6.txt", 0
    buffer   times 18   db 0, 0              ; Buffer para leer 16 bits a la vez
    pixel    times 18   db 0, 0              ; Pixel desencriptado por guardar
    input_fd            dd 0, 0              ; File descriptor para el archivo de entrada
    output_fd           dd 0, 0              ; File descriptor para el archivo de salida

section .text
    global _start

_start:
    ;Abrir archivo
    call open_input_file

    call read_file
    cmp eax, 0                  ; Verificar si es el final del archivo
    call print_buffer

    mov esi, buffer             
    mov edi, pixel            
    mov ecx, 18                 ; Definir cantidad de ciclos
    cld                         ; Limpiar la direction flag
    rep movsb                   ; Copiar n veces esi en edi

    call print_pixel
    ;Escribir en el archivo y cerrar
    call open_ouput_file
    call write_file

    call close_output_file
    call close_input_file


    ; Salir
    mov eax, 1
    xor ebx, ebx        
    int 0x80            
