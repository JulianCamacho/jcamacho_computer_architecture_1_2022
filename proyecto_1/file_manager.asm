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

    ;mov eax, 3                      ; Codigo de llamada al sistema read() para leer el archivo
    ;mov ebx, [input_fd]             ; File descriptor
    ;mov ecx, buffer                 ; Buffer para almacenar lo que se lee
    ;mov edx, buf_size               ; Cantidad de bytes por leer
    ;int 0x80                        ; Ejecutar llamada al sistema

    ; read from file
    mov edi, buffer                     ; Guardar puntero al buffer
    mov ecx, 1                          ; Para leer un byte a la vez
    mov ebx, [input_fd]                 ; File descriptor
    read_next_byte:
        mov eax, 3                      ; Codigo de llamada al sistema read() para leer el archivo
        mov ecx, current_byte           ; Leer y guardar el byte actual
        mov edx, 1                      ; Cantidad de bytes por leer
        int 0x80                        ; Ejecutar llamada al sistema
        cmp byte [current_byte], 0      ; Verificar final del archivo
        je done                         
        cmp byte [current_byte], ' '    ; Verificar si el byte es un espacio
        je done                         
        mov eax, [current_byte]
        mov [edi], eax                  ; Copiar el byte a su destino
        inc edi                         ; Incrementar puntero de lectura
        jmp read_next_byte              
    done:
        mov byte [edi], 0               ; Colocar terminacion del string
        call print_buffer
        mov esp, ebp
        pop ebp
        ret


my_atoi:
    mov esi, buffer             ; Cargar string en eax
    xor eax, eax                
    convert_loop:
        mov edx, 10             ; Base de la conversion
        cmp byte [esi], 0       ; Verificar final del string
        je done_
        movzx edi, byte [esi]   ; Cargar un digito
        sub edi, '0'            ; Conversion ASCII - decimal
        cmp eax, 0              ; Verificar si el resultado parcial es 0 (pasa solo la primera iteracion)
        jz no_mult              
        mul edx                 ; Si no es, no es necesario ajustar la decena por lo que se multiplica por 10
        no_mult:                
        add eax, edi            ; Se suma el nuevo digito al resultado parcial para colocarlo en el msb
        inc esi                 ; Moverse a siguiente caracter
        jmp convert_loop       
    done_:
        ;mov [pixel], ebx
        ret


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


