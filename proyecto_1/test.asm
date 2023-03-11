
%include "file_manager.asm" 

section .data
    output_filename     db "7.txt", 0
    input_filename      db "5.txt", 0
    ;buffer   times 8   db 0, 0              ; Buffer para leer 16 bits a la vez
    pixel               dw 0, 0              ; Pixel desencriptado por guardar
    input_fd            dd 0, 0              ; File descriptor para el archivo de entrada
    output_fd           dd 0, 0              ; File descriptor para el archivo de salida
    msb                 db 0, 0
    lsb                 db 0, 0   
    buf_size equ 1024
    buffer db buf_size dup(0)
    format db "%d", 0


section .text
    global _start

_start:
    ;Abrir archivo
    call open_input_file

    call read_file
    cmp eax, 0                  ; Verificar si es el final del archivo

    call read_next_number

    call print_buffer



    ;mov esi, buffer             
    ;mov edi, pixel            
    ;mov ecx, 18                 ; Definir cantidad de ciclos
    ;cld                         ; Limpiar la direction flag
    ;rep movsb                   ; Copiar n veces esi en edi
        
    ;call print_pixel
    ;;Escribir en el archivo y cerrar
    ;call open_ouput_file
    ;call write_file
;
    ;call close_output_file
    call close_input_file


    ;mov eax, buffer     ; mueve la dirección del búfer en eax
    ;sub eax, '0'
    ;add eax, 5

    ;mov eax, buffer
    ;call atoi          ; Utilizar la función "atoi" para convertir el número

    ; Almacenar el valor numérico en el registro EAX
    ;mov eax, ebx

    ; Salir
    mov ebx, eax      
    mov eax, 1 
    int 0x80            
