;;======== FUNCIONES MATEMÁTICAS ========

; Entradas:
;       eax: a
;       ebx: b
; Salidas:
;       eax: a % b

my_mod:
    push ebp
    mov ebp, esp
    
    xor edx, edx        ; Limpiar edx
    div ebx             ; Realizar la division para obtener el modulo
    mov eax, edx        ; Se guarda en edx pero se pasa a eax para retornar

    mov esp, ebp
    pop ebp
    ret


rsa:
    push ebp                        ;--> Prologo de la funcion
    mov ebp, esp

    mov ebx, [d_key] 
    bsr ecx, ebx            ;ecx --> k
    mov eax, [encrypted_pixel]
    mov ebx, [n_key]
    add ecx, 1                          ; Aumentar ecx 1 para ajustar cantidad de iteraciones
    
    get_next_module:
        cmp eax, ebx                    ; Comparar si el valor anterior con el del modulo (n)
        jl save_n_continue              ; Si es menor es trivial por lo que no hay que realizar el modulo
        call my_mod                     ; Si es mayor o igual se le aplica el modulo (eax = eax % ebx)
        save_n_continue:    
            push eax                    ; Se guarda el resultado actual en el stack
            imul eax, eax               ; Se eleva al cuadrado para obtener el proximo valor
            dec ecx                     ; Se resta el numero de iteraciones
            cmp ecx, 0
            je finish_modules           ; Si es cero, termina
            jmp get_next_module 
    
    finish_modules:                 

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
                je finish
                jmp get_result
        finish:
            mov ebx, [n_key]
            call my_mod                     ; Aplicar el modulo al acumulador (eax = eax % ebx)
            mov [decrypted_pixel], eax      ; Se guarda el pixel desencriptado
            mov esp, ebp                    ;--> Epilogo de la funcion
            pop ebp
            ret
