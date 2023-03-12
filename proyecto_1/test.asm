
%include "file_manager.asm" 


section .data
    output_filename     db "7.txt", 0
    input_filename      db "5.txt", 0
    buffer              dw 0, 0              ; Buffer
    pixel               dw 0, 0              ; Pixel desencriptado por guardar
    input_fd            dd 0, 0              ; File descriptor para el archivo de entrada
    output_fd           dd 0, 0              ; File descriptor para el archivo de salida
    msb                 db 0, 0
    lsb                 db 0, 0
    encrypted_pixel     dw 0, 0   


section .bss
    current_byte resb 1

section .text
    extern atoi
    extern printf
    global _start


_start:
    ;Abrir archivo
    call open_input_file

    call read_file
    call my_atoi
    shl eax, 8
    _bf:
    mov [encrypted_pixel], eax
    
    ;call print_pixel

    call read_file
    call my_atoi
    mov edx, [encrypted_pixel]
    add edx, eax 
    _bp:
    mov [encrypted_pixel], edx
    mov ecx, [encrypted_pixel] 
    ;_bp:

    ;call read_file
    ;call my_atoi
    ;add eax, 3
    ;mov ecx, eax
    ;_bp2:
    ;call print_pixel

    call close_input_file

    ; Salir
    mov ebx, ecx      
    mov eax, 1 
    int 0x80            
