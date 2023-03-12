
%include "file_manager.asm" 
%include "math.asm" 


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
    decrypted_pixel     dw 0, 0   
 


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
    mov ebx, [n_key]
    add ecx, 1                          ; Aumentar ecx 1 para ajustar cantidad de iteraciones
    get_modules:
        cmp eax, ebx                    ; Comparar si el valor anterior con el del modulo (n)
        jl save_n_continue              ; Si es menor es trivial por lo que no hay que realizar el modulo
        call my_mod                     ; Si es mayor o igual se le aplica el modulo (eax = eax % ebx)
        save_n_continue:    
            push eax                    ; Se guarda el resultado actual en el stack
            mov ebp, eax                ; Se guarda en un registro para pruebas
            imul eax, eax               ; Se eleva al cuadrado para obtener el proximo valor
            dec ecx                     ; Se resta el numero de iteraciones
            cmp ecx, 0
        _rd:
            je finish                   ; Si es cero, termina
            jmp get_modules                    

    finish:

    push ebp                        ;--> Prologo de la funcion
    mov ebp, esp

    mov esi, [d_key]
    bsr ecx, esi
    add ecx, 1                          ; Aumentar ecx 1 para ajustar posicion en el stack
    imul ecx, 4                         ; Multiplicar por 4 para ajustar posicion en el stack
    add esp, ecx                        ; Mover el puntero del stack hasta el primer modulo calculado

    bsr ecx, esi
    add ecx, 1                          ; Aumentar ecx 1 para ajustar cantidad de iteraciones
    mov eax, 1                          ; Inicializar acumulador donde se guardara el resultado
    get_result:

        mov edx, dword [esp]            ; Sacar del stack los modulos obtenidos, desde el primero al ultimo calculado
        sub esp, 4                      ; Restar al puntero de stack para apuntar al siguiente numero (sobre el)
        
        mov ebx, esi                    ; Guardar esi (d) en ebx
        and esi, 1                      ; Mascara para obtener el lsb
        cmp esi, 1                      ; Si el lsb el uno, el modulo correspondiente se debe multiplicar
        jne continue    
        imul eax, edx                   ; Multiplicar el modulo en el acumulador
        continue:
            shr ebx, 1                  ; Si no, solo correr para evaluar el siguiente bit
            mov esi, ebx
            dec ecx                     ; Se resta el numero de iteraciones
            cmp ecx, 0
            _a:
            je finish_
            jmp get_result
    finish_:
        mov ebx, [n_key]
        call my_mod                     ; Aplicar el modulo al acumulador (eax = eax % ebx)
        mov [decrypted_pixel], eax      ; Se guarda el pixel desencriptado
        mov ecx, eax                    
        mov esp, ebp                    ;--> Epilogo de la funcion
        pop ebp



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
