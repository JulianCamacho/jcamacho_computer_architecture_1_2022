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