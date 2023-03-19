
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
    d_key               dw 0, 0              ; Valor d de la llave privada (exponente)
    n_key               dw 0, 0              ; Valor n de la llave privada (modulo)
    encrypted_pixel     dw 0, 0              ; Valor de pixel encriptado
    decrypted_pixel     db 0, 0              ; Valor de pixel desencriptado
    digits              db 0, 0              ; Cantidad de digitos de un numero
    counter             dw 5, 0
    partial_result      dq 0, 0              ; Variable de 64 bits para guardar resultado parcial
    linebreak_counter   dw 0, 0
   ;half_file_length    equ 102400
    half_file_length    equ 102400
    output_len          equ $-output_buffer  ; Largo del buffer de salida                



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
    mov esi, [linebreak_counter]
    push ecx                        ; Guardar el contador en el stack
    push esi
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

        call rsa                    ; Calcular pixel desencriptado por medio de RSA
        call my_itoa                ; Pasar ese pixel a ASCII
        call write_file             ; Escribirlo en el archivo de salida

        pop esi                     ; Sacar el contador de linea del stack
        inc esi                     ; Incrementar contador de linea
        cmp esi, 640                ; Comparar con 640 (pixeles en una linea)
        je place_linebreak          ; Si es igual a 640 se agrega el linebreak
        jl cont                     ; Sino se sigue escribiendo normalmente

        place_linebreak:
            mov word [output_buffer], 0x0D      ; Caracter de nueva línea
            mov byte [digits], 1                ; Para escribir un byte
            call write_file                     ; Escribir en el archivo de salida
            xor esi, esi                        ; Reiniciar el contador de línea
        
        cont:
        pop ecx                     ; Sacar contador del stack
        dec ecx                     ; Decrementar contador
        cmp ecx, 0                  ; Si no es cero se repite el loop
        push ecx                    ; Volver a guardarlo actualizado
        push esi                    ; Volver a guardar contador de linea
        jnz main_loop
    call close_output_file
    call close_input_file


    ; Salir
    mov ebx, ecx     
    mov eax, 1 
    int 0x80            
