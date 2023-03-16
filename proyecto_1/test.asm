
%include "file_manager.asm" 
%include "math.asm" 


section .data
    output_filename     db "7.txt", 0
    keys_filename       db "llaves.txt", 0
    input_filename      db "5.txt", 0
    input_fd            dd 0, 0              ; File descriptor para el archivo de entrada
    keys_fd             dd 0, 0              ; File descriptor para el archivo de llaves
    output_fd           dd 0, 0              ; File descriptor para el archivo de salida
    buffer              dw 0, 0              ; Buffer para leer del archivo de entrada
    output_buffer       dw 0, 0              ; Buffer para escribir al archivo de salida
    keys_buffer         dw 0, 0              ; Buffer para leer llaves
    pixel               dw 0, 0              ; Pixel desencriptado por guardar
    d_key               dw 0, 0
    n_key               dw 0, 0
    encrypted_pixel     dw 0, 0   
    decrypted_pixel     dw 0, 0
    digits              db 0, 0
    output_len          equ $-output_buffer  ; Largo del buffer de salida                
    counter             dw 5, 0
    ;half_file_length    equ 102400
    half_file_length     equ 102399


section .bss
    current_byte resb 1

section .text
    extern atoi
    extern printf
    global _start


_start:
    ;call open_ouput_file
    ;mov byte [decrypted_pixel], 36
    ;call my_itoa
    ;call write_file
;
    ;mov byte [decrypted_pixel], 189
    ;call my_itoa
    ;call write_file
;
    ;mov byte [decrypted_pixel], 7
    ;call my_itoa   
    ;call write_file
;
    ;call close_output_file
   ; Abrir archivos
    call open_keys_file

    ; Leer llave privada d (exponente)
    call read_keys_file
    call my_atoi_keys
    mov [d_key], eax

    ; Leer llave privada n (modulo)
    call read_keys_file
    call my_atoi_keys
    mov [n_key], eax

    call close_keys_file

    call open_input_file
    call open_ouput_file

    mov ecx, half_file_length
    push ecx                        ; Guardar el contador en el stack
    main_loop:

        ; Leer MSB
        call read_file
        call my_atoi
        shl eax, 8
        mov [encrypted_pixel], eax

        ; Leer LSB y unir [MSB LSB] en encryted_pixel
        call read_file
        call my_atoi
        mov edx, [encrypted_pixel]
        add edx, eax 
        mov [encrypted_pixel], edx

        call rsa
        call my_itoa
        call write_file

        pop ecx                     ; Sacar contador del stack
        dec ecx                     ; Decrementar contador
        cmp ecx, 0                  ; Si no es cero se repite el loop
        push ecx                    ; Volver a guardarlo actualizado
        jnz main_loop
    call close_output_file
    call close_input_file


    ; Salir
    mov ebx, ecx     
    mov eax, 1 
    int 0x80            
