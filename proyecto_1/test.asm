
%include "file_manager.asm" 


section .data
    output_filename     db "7.txt", 0
    keys_filename       db "llaves.txt", 0
    input_filename      db "5.txt", 0
    input_fd            dd 0, 0              ; File descriptor para el archivo de entrada
    keys_fd             dd 0, 0              ; File descriptor para el archivo de llaves
    output_fd           dd 0, 0              ; File descriptor para el archivo de salida
    buffer              dw 0, 0              ; Buffer
    keys_buffer         dw 0, 0              ; Buffer
    pixel               dw 0, 0              ; Pixel desencriptado por guardar
    msb                 db 0, 0
    lsb                 db 0, 0
    d_key               dw 0, 0
    n_key               dw 0, 0
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
    call open_keys_file

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
    mov [encrypted_pixel], edx
    ;mov ecx, [encrypted_pixel] 
    _bp:

    call read_keys_file
    call my_atoi_keys
    mov [d_key], eax

    call read_keys_file
    call my_atoi_keys
    mov [n_key], eax

    mov ebx, [d_key] 
    bsr ecx, ebx            ;ecx --> k
    _bp3:

    mov eax, [encrypted_pixel]
    mov ebx, [d_key]
    mov edx, [n_key]
    loop:
        cmp eax, edx
        jl save_n_continue
        mod:
            call my_mod
            ; eax = 81mod50
            jmp continue
        save_n_continue:
            push eax
            mul eax, eax
            jmp loop


        








    ;call read_file
    ;call my_atoi
    ;add eax, 3
    ;mov ecx, eax
    ;_bp2:
    ;call print_pixel
    call close_keys_file
    call close_input_file

    ; Salir
    mov ebx, ecx      
    mov eax, 1 
    int 0x80            
