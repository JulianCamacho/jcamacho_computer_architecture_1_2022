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

my_complex_mod:
    push ebp
    mov ebp, esp
    
    idiv ebx
    mov eax, edx     

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
        ;add ecx, 1                         ; Aumentar ecx 1 para ajustar posicion en el stack
        imul ecx, 4                         ; Multiplicar por 4 para ajustar posicion en el stack
        add esp, ecx                        ; Mover el puntero del stack hasta el primer modulo calculado

        bsr ecx, esi
        add ecx, 1                          ; Aumentar ecx 1 para ajustar cantidad de iteraciones
        mov eax, 1                          ; Inicializar acumulador donde se guardara el resultado
        mov ebx, [n_key]
        mov dword [partial_result], 1
        get_result:

            mov edi, dword [esp]            ; Sacar del stack los modulos obtenidos, desde el primero al ultimo calculado
            sub esp, 4                      ; Restar al puntero de stack para apuntar al siguiente numero (sobre el)
            
            mov [shifted_d_key], esi        ; Guardar esi (d) en memoria
            and esi, 1                      ; Mascara para obtener el lsb
            cmp esi, 1                      ; Si el lsb es uno, el modulo correspondiente se debe multiplicar
            jne continue    
            mul edi                         ; Multiplicar el modulo en el acumulador (resultados grandes quedan en edx:eax)
            _res:
            cmp edx, 0                      ; Si el resultado ya casi llena edx (resultados de más de 48 bits para que no haya desborde previo)
            jg get_partial_result
            jle continue

            get_partial_result:
                div ebx                               ; Realizar la division (edx:eax)/ebx para obtener el modulo
                mov eax, edx                          ; Hacer modulo del resultado parcial
                mov edx, dword [partial_result]       ; Cargar resultado parcial previo en edx
                mul edx                               ; Guardar en eax el resultado de eax (modulo parcial) y el resultado parcial hasta ahora
                mov dword [partial_result], eax       ; Volver a guardarlo en memoria
                mov eax, 1                            ; Reiniciar eax para obtener otro resultado parcial
                xor edx, edx

            continue:
                mov esi, [shifted_d_key]
                shr esi, 1                  ; Si no, solo correr para evaluar el siguiente bit
                dec ecx                     ; Se resta el numero de iteraciones
                cmp ecx, 0
                je finish
                jmp get_result 

        finish:
            div ebx
            mov eax, edx 
            mov esi, dword [partial_result]      ; Cargar resultado parcial previo en edx
            mul esi                              ; Guardar en eax el resultado de eax (modulo parcial) y el resultado parcial hasta ahora
            div ebx
            mov eax, edx

            mov [decrypted_pixel], eax      ; Se guarda el pixel desencriptado
            _aqui:
            mov esp, ebp                    ;--> Epilogo de la funcion
            pop ebp
            ret
