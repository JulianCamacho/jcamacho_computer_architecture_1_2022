;;======== FUNCIONES DE MANEJO DE ARCHIVOS ========

; Entradas:
;       edi: nombre del archivo

open_input_file:
    push ebp            ;--> Prologo de la funcion
    mov ebp, esp        ;-|

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
    mov edx, 18                     ; Cantidad de bytes por leer
    int 0x80                        ; Ejecutar llamada al sistema

    mov esp, ebp
    pop ebp
    ret



; Entradas:
;       edx: valor por escribir

write_file:
    mov eax, 4                  ; Codigo de llamada al sistema write() para escribir en el archivo
    mov ebx, [output_fd]        ; File descriptor
    mov ecx, pixel              ; Valor por escribir
    mov edx, 1                  ; Cantidad de bytes por escribir
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
    mov edx, 18                 ; Cantidad de bytes por imprimir
    int 0x80                    ; Ejecutar llamada al sistema

    mov esp, ebp
    pop ebp
    ret