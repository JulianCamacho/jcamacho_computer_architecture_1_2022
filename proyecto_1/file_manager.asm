;;======== FUNCIONES DE MANEJO DE ARCHIVOS ========


open_input_file:
    push ebp                        ;--> Prologo de la funcion
    mov ebp, esp                    ;-|

    mov eax, 5                      ; Codigo de llamada al sistema open() para abrir el archivo
    mov ebx, input_filename         ; edi: nombre del archivo
    mov ecx, 0                      ; Modo solo lectura
    int 0x80                        ; Ejecutar llamada al sistema
    mov [input_fd], eax             ; Guardar el file descriptor en memoria

    mov esp, ebp                    ;--> Epilogo de la funcion
    pop ebp                         ;-|
    ret

open_ouput_file:
    mov eax, 5                      ; Codigo de llamada al sistema open() para abrir el archivo
    mov ebx, output_filename        ; edi: nombre del archivo
    mov ecx, 0x42                   ; O_CREAT | O_RDWR | O_TRUNC
    mov edx, 0x1C0                  ; Modo para usuarios    
    int 0x80                        ; Ejecutar llamada al sistema
    mov [output_fd], eax            ; Guardar el file descriptor en memoria



; Entradas:
;       buffer: almacena lo que se lee

read_file:
    push ebp
    mov ebp, esp

    mov eax, 3                      ; Codigo de llamada al sistema read() para leer el archivo
    mov ebx, [input_fd]             ; File descriptor
    mov ecx, buffer                 ; Buffer para almacenar lo que se lee
    mov edx, buf_size               ; Cantidad de bytes por leer
    int 0x80                        ; Ejecutar llamada al sistema

    mov esp, ebp
    pop ebp
    ret


read_next_number:
    mov esi, buffer                 ; Esi apunta al buffer
    mov edi, esi                    ; Edi también
    next_number:
        mov ah, [esi]               ; Guardar en ah lo que se encuentra en el buffer
        cmp ah, 0                   ; Verificar si es el final del buffer
        je read_done                     ; Terminar lectura
        cmp ah, ' '                 ; Verificar si hay un espacio
        jne next_byte               ; Si no lo hay leer siguiente caracter
        mov byte [esi], 0           ; Colocar null al final (necesario para atoi)
        mov eax, format             ; Formato del string para atoi
        mov ecx, edi                ; Colocarse en el inicio del buffer

        jmp my_atoi                 ; Convertir a entero

        inc esi
        mov edi, esi                ; Empezar siguiente numero

        jmp next_number
        
    next_byte:
        inc esi
        jmp next_number

    my_atoi:
        mov eax, ecx                ; Cargar string en eax
        xor ebx, ebx                
        mov edx, 10                 ; Base de la conversion
        convert_loop:
            cmp byte [eax], 0       ; Verificar final del string
            je done
            movzx edi, byte [eax]   ; Cargar un digito
            sub edi, '0'            ; Conversion ASCII - decimal
            mul edx                 ; Multiplicar por la base
            add ebx, edi            ; Sumar en el acumulador
            inc eax                 ; Moverse a siguiente caracter
            loop convert_loop       
        done:
            mov [pixel], ebx
            call print_pixel

    read_done:
        xor ebx, ebx






; Entradas:
;       ecx: valor por escribir

write_file:
    mov eax, 4                  ; Codigo de llamada al sistema write() para escribir en el archivo
    mov ebx, [output_fd]        ; File descriptor
    mov ecx, pixel              ; Valor por escribir
    mov edx, 18                 ; Cantidad de bytes por escribir
    int 0x80                    ; Ejecutar llamada al sistema
    ret


close_input_file:
    push ebp
    mov ebp, esp

    mov eax, 6                  ; Codigo de llamada al sistema read() para leer el archivo
    mov ebx, [input_fd]         ; File descriptor
    int 0x80                    ; Ejecutar llamada al sistema

    mov esp, ebp
    pop ebp
    ret


close_output_file:
    mov eax, 6                  ; Codigo de llamada al sistema read() para leer el archivo
    mov ebx, [output_fd]        ; File descriptor
    int 0x80                    ; Ejecutar llamada al sistema
    ret

print_buffer:
    push ebp
    mov ebp, esp

    mov eax, 4                  ; Codigo de llamada al sistema write()
    mov ebx, 1                  ; File descriptor para stdout
    mov ecx, buffer             ; Buffer que contiene lo que se va a imprimir
    mov edx, 8                 ; Cantidad de bytes por imprimir
    int 0x80                    ; Ejecutar llamada al sistema

    mov esp, ebp
    pop ebp
    ret

print_pixel:
    push ebp
    mov ebp, esp

    mov eax, 4                  ; Codigo de llamada al sistema write()
    mov ebx, 1                  ; File descriptor para stdout
    mov ecx, pixel              ; Buffer que contiene lo que se va a imprimir
    mov edx, 8                 ; Cantidad de bytes por imprimir
    int 0x80                    ; Ejecutar llamada al sistema

    mov esp, ebp
    pop ebp
    ret


