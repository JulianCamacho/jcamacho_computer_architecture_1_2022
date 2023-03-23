
%include "file_manager.asm" 
%include "math.asm" 


section .data
    output_filename     db "./test_2/output.txt", 0
    keys_filename       db "./test_2/llaves.txt", 0
    input_filename      db "./test_2/input.txt", 0
    input_fd            dd 0, 0              ; File descriptor para el archivo de entrada
    keys_fd             dd 0, 0              ; File descriptor para el archivo de llaves
    output_fd           dd 0, 0              ; File descriptor para el archivo de salida
    buffer              dw 0, 0              ; Buffer para leer del archivo de entrada
    output_buffer       dw 0, 0              ; Buffer para escribir al archivo de salida
    keys_buffer         dw 0, 0              ; Buffer para leer llaves
    pixel               dw 0, 0              ; Pixel desencriptado por guardar
    d_key               dw 0, 0              ; Valor d de la llave privada (exponente)
    n_key               dw 0, 0              ; Valor n de la llave privada (modulo)
    shifted_d_key       dw 0, 0              ; Valor n de la llave privada (modulo)
    encrypted_pixel     dw 0, 0              ; Valor de pixel encriptado
    decrypted_pixel     db 0, 0              ; Valor de pixel desencriptado
    digits_aux2         db 0, 0              ; Cantidad de digitos de un numero
    partial_result      dd 1, 0              ; Variable para guardar resultado parcial
    digits              db 0, 0              ; Cantidad de digitos de un numero
    linebreak_counter   dw 0, 0              ; Contador para determinar salto de linea
    digits_aux          db 0, 0              ; Cantidad de digitos de un numero
    aux                 dw 0, 0              ; Variable auxiliar
    lut_integers        dd 256 dup(0)        ; Inicializar lookup table de pixeles encriptados
    lut_results         dd 256 dup(0)        ; Inicializar lookup table de resultados
    lut_index           db 0, 0              ; Posicion para agregar valores en las lookup tables

    half_file_length    equ 307199           ; Cantidad de pixeles por desencriptar     
    ;half_file_length    equ 102399



section .bss
    current_byte resb 1

section .text
    global _start


_start:

    ;;;========= Lectura de llaves =========;;;

    call open_keys_file                 ; Abrir archivo de llaves

    call read_keys_file                 ; Leer llave privada d (exponente)
    call my_atoi_keys                   ; Convertirla a entero
    mov [d_key], eax                    ; Guardarla en d_key

    call read_keys_file                 ; Leer llave privada n (modulo)
    call my_atoi_keys                   ; Convertirla a entero
    mov [n_key], eax                    ; Guardarla en n_key

    call close_keys_file                ; Cerrar el archivo de llaves


    ;;;========= Desencriptacion de pixeles =========;;;

    call open_input_file                ; Abrir archivo de entrada
    call open_ouput_file                ; Abrir archivo de salida

    mov ecx, half_file_length           ; Cargar el numero de iteraciones
    mov esi, [linebreak_counter]        ; Cargar contador de cambio de linea
    push ecx                            ; Guardar ambos contadores en el stack
    push esi

    main_loop:

        call read_file                      ; Leer MSB
        call my_atoi                        ; Convertirlo a entero
        shl eax, 8                          ; Correrlo un byte para colocar el lsb
        mov [encrypted_pixel], eax          ; Guardar en memoria

        call read_file                      ; Leer LSB
        call my_atoi                        ; Convertirlo a entero
        mov edx, [encrypted_pixel]          ; Cargar el MSB
        add edx, eax                        ; Sumar para colocar el LSB
        mov [encrypted_pixel], edx          ; Guardar en memoria


        ;;=== Optimizacion ===;;

        mov ecx, 0 
        xor eax, eax
        mov esi, lut_integers               ; Puntero al inicio del lut
        search_in_lut:
            mov ebx, [esi + ecx*4]          ; Cargar valor del array en la posicion cx
            cmp edx, ebx                    ; Verificar si es igual al elemento
            je value_found
            cmp ebx, 0                      ; Verificar si se encontro un cero 
            je zero_found     
            jne next
            zero_found:
                inc eax                     ; Si se encontro un cero aumentar contador
                jmp next

            next:
            cmp eax, 2                      ; Si ya se encontraron dos ceros, no esta en el lut
            je not_in_lut
            inc ecx                         ; Incrementar posicion y contador del loop
            cmp ecx, 256                    ; Verificar si ya se llego al final del lut
            jl search_in_lut

        not_in_lut:                         ; Si el pixel no esta en el lut
        call rsa                            ; Calcular pixel desencriptado por medio de RSA
        add dword [lut_index], 1            ; Aumentar posicion donde guardar
        jmp go_on                           ; Y continuar normalmente

        value_found:
            mov esi, lut_results            ; Cargar puntero al lut de resultados
            mov eax, [esi+ecx*4]            ; Si se encontro, cargar la misma posicion de lut_res
            mov [decrypted_pixel], eax      ; Mover ese resultado a decrypted pixel y seguir

        go_on:
        call my_itoa                    ; Pasar ese pixel a ASCII
        call write_file                 ; Escribirlo en el archivo de salida

        pop esi                         ; Sacar el contador de linea del stack
        inc esi                         ; Incrementar contador de linea
        cmp esi, 640                    ; Comparar con 640 (pixeles en una linea)
        je place_linebreak              ; Si es igual a 640 se agrega el linebreak
        jl cont                         ; Sino se sigue escribiendo normalmente

        place_linebreak:
            mov word [output_buffer], 0x0D      ; Caracter de nueva línea
            mov byte [digits], 1                ; Para escribir un byte
            call write_file                     ; Escribir en el archivo de salida
            xor esi, esi                        ; Reiniciar el contador de línea
        
        cont:
        pop ecx                         ; Sacar contador del stack
        dec ecx                         ; Decrementar contador
        cmp ecx, 0                      ; Si no es cero se repite el loop
        push ecx                        ; Volver a guardarlo actualizado
        push esi                        ; Volver a guardar contador de linea
        jnz main_loop

    call close_output_file              ; Cerrar archivo de salida
    call close_input_file               ; Cerrar archivo de entrada

    
    ;;;========= Salida del programa =========;;;

    mov ebx, ecx     
    mov eax, 1 
    int 0x80            
