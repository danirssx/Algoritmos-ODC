section .data
    prompt db "Presiona una tecla: ", 0
    msg db "Tecla presionada: ", 0
    keycode db 0
    key_msg db "0", 0   ; Espacio para almacenar la tecla presionada
    newline db 10, 0    ; Nueva línea
    done_msg db "Programa finalizado.", 0

section .bss
    dummy resb 1

section .text
    global _start
    extern _print_string

_start:
    ; Mostrar mensaje de prompt
    mov eax, prompt
    call _print_string

    ; Leer una tecla del usuario
    call read_keypress

    ; Mostrar mensaje
    mov eax, msg
    call _print_string

    ; Mostrar tecla presionada
    mov eax, key_msg
    call _print_string

    ; Mostrar nueva línea
    mov eax, newline
    call _print_string

    ; Mostrar mensaje de finalización
    mov eax, done_msg
    call _print_string

    ; Salir del programa
    mov eax, 1          ; sys_exit
    xor ebx, ebx        ; exit code 0
    int 0x80            ; llamada al sistema

read_keypress:
    ; Leer un carácter del teclado
    mov eax, 3          ; Número de llamada del sistema (sys_read)
    mov ebx, 0          ; Descriptor de archivo (stdin)
    mov ecx, keycode    ; Dirección de almacenamiento
    mov edx, 1          ; Número de bytes a leer
    int 0x80            ; Llamada al sistema

    ; Convertir el código de la tecla a carácter
    mov al, [keycode]
    mov [key_msg], al
    ret

section .print_string
_print_string:
    pusha                ; Guardar todos los registros generales

    ; Obtener la longitud de la cadena
    mov ecx, 0
    .strlen_loop:
        mov al, byte [eax + ecx]
        cmp al, 0
        je .strlen_done
        inc ecx
        jmp .strlen_loop
    .strlen_done:

    ; Escribir la cadena
    mov edx, ecx         ; Longitud de la cadena
    mov ebx, 1           ; Descriptor de archivo (stdout)
    mov eax, 4           ; Número de llamada del sistema (sys_write)
    int 0x80             ; Llamada al sistema

    popa                 ; Restaurar todos los registros generales
    ret
