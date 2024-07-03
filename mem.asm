section .data
    pages db 4, 3, 2, 1       ; Simulación de páginas en la memoria
    ref_bits db 1, 0, 1, 0    ; Bits de referencia para cada página
    clock_hand db 0           ; Índice del puntero del reloj
    msg db "Current page: ", 0
    page_msg db "Page to replace: ", 0
    new_line db 10, 0

section .bss
    page_to_replace resb 1    ; Espacio para la página que será reemplazada

section .text
    global _start

_start:
    ; Llamar a la función de reemplazo de página
    call replace_page

    ; Salir del programa
    mov eax, 1                ; sys_exit
    xor ebx, ebx              ; exit code 0
    int 0x80                  ; llamada al sistema

replace_page:
    ; Iniciar bucle del reloj
    mov ecx, 4                ; Número de páginas
clock_loop:
    ; Imprimir el estado actual del puntero del reloj
    call print_clock_hand
    
    ; Obtener el bit de referencia actual
    movzx esi, byte [clock_hand] ; Cargar el índice del puntero del reloj
    mov al, [ref_bits + esi]     ; Acceder al bit de referencia actual
    
    ; Verificar si el bit de referencia es 0
    test al, al
    jnz ref_bit_set

    ; Si el bit de referencia es 0, reemplazar esta página
    mov al, [pages + esi]
    mov [page_to_replace], al ; Mover el valor de la página a reemplazar
    ; Imprimir la página que será reemplazada
    call print_page_to_replace
    ; Devolver 0
    ret

ref_bit_set:
    ; Si el bit de referencia es 1, ponerlo a 0
    mov byte [ref_bits + esi], 0

    ; Mover el puntero del reloj a la siguiente página
    inc byte [clock_hand]
    cmp byte [clock_hand], 4  ; Verificar si el puntero sobrepasa el número de páginas
    jne clock_loop
    mov byte [clock_hand], 0  ; Reiniciar el puntero del reloj a 0

    ; Repetir el bucle del reloj
    jmp clock_loop

print_clock_hand:
    ; Escribir "Current page: "
    mov eax, 4                ; sys_write
    mov ebx, 1                ; file descriptor (stdout)
    mov ecx, msg              ; mensaje
    mov edx, 14               ; longitud del mensaje
    int 0x80

    ; Escribir el valor de clock_hand
    mov al, [clock_hand]
    add al, '0'
    mov [clock_hand + 1], al  ; almacenar el valor como un carácter
    mov eax, 4                ; sys_write
    mov ebx, 1                ; file descriptor (stdout)
    mov ecx, clock_hand + 1   ; valor del puntero del reloj
    mov edx, 1                ; longitud del mensaje
    int 0x80

    ; Escribir nueva línea
    mov eax, 4                ; sys_write
    mov ebx, 1                ; file descriptor (stdout)
    mov ecx, new_line         ; nueva línea
    mov edx, 1                ; longitud del mensaje
    int 0x80
    ret

print_page_to_replace:
    ; Escribir "Page to replace: "
    mov eax, 4                ; sys_write
    mov ebx, 1                ; file descriptor (stdout)
    mov ecx, page_msg         ; mensaje
    mov edx, 18               ; longitud del mensaje
    int 0x80

    ; Escribir el valor de page_to_replace
    mov al, [page_to_replace]
    add al, '0'
    mov [page_to_replace + 1], al ; almacenar el valor como un carácter
    mov eax, 4                ; sys_write
    mov ebx, 1                ; file descriptor (stdout)
    mov ecx, page_to_replace + 1 ; valor de la página a reemplazar
    mov edx, 1                ; longitud del mensaje
    int 0x80

    ; Escribir nueva línea
    mov eax, 4                ; sys_write
    mov ebx, 1                ; file descriptor (stdout)
    mov ecx, new_line         ; nueva línea
    mov edx, 1                ; longitud del mensaje
    int 0x80
    ret
