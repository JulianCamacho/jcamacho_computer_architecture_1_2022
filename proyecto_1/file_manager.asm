;;======== FUNCIONES DE MANEJO DE ARCHIVOS ========

; Entradas:
;       edi: nombre del archivo
;       mode: definir modo de acceso

open_file:
    push ebp            ;--> Prologo de la funcion
    mov ebp, esp        ;-|

    mov eax, 5          ; Codigo de llamada al sistema open() para abrir el archivo
    mov ebx, edi        ; edi: nombre del archivo
    mov ecx, mode       ; Definir modo de acceso
    int 0x80            ; Ejecutar llamada al sistema
    mov edi, eax        ; Guardar el file descriptor en memoria

    mov esp, ebp        ;--> Epilogo de la funcion
    pop ebp             ;-|
    ret


; Entradas:
;       edi: nombre del archivo
;       buffer: almacena lo que se lee

read_file:
    push ebp
    mov ebp, esp

    mov eax, 3          ; Codigo de llamada al sistema read() para leer el archivo
    mov ebx, edi        ; File descriptor
    mov ecx, buffer     ; Buffer para almacenar lo que se lee
    mov edx, 16         ; Cantidad de bytes por leer
    int 0x80            ; Ejecutar llamada al sistema

    mov esp, ebp
    pop ebp
    ret



; Entradas:
;       edi: nombre del archivo

write_file:
    mov eax, 4          ; Codigo de llamada al sistema write() para escribir en el archivo
    mov ebx, edi        ; File descriptor
    mov ecx, edx        ; 
    mov edx, 1          ; Cantidad de bytes por escribir
    int 0x80            ; call kernel
    ret



; Entradas:
;       edi: nombre del archivo

close_file:
    push ebp
    mov ebp, esp

    mov eax, 6          ; Codigo de llamada al sistema read() para leer el archivo
    mov ebx, edi        ; File descriptor
    int 0x80            ; Ejecutar llamada al sistema

    mov esp, ebp
    pop ebp
    ret



print_buffer:
    push ebp
    mov ebp, esp

    mov eax, 4          ; Codigo de llamada al sistema write()
    mov ebx, 1          ; File descriptor para stdout
    mov ecx, buffer     ; Buffer que contiene lo que se va a imprimir
    mov edx, 16         ; Cantidad de bytes por imprimir
    int 0x80            ; Ejecutar llamada al sistema

    mov esp, ebp
    pop ebp
    ret