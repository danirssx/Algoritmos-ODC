# Datos iniciales
pages = [4, 3, 2, 1]         # Simulación de páginas en la memoria
ref_bits = [1, 0, 1, 0]      # Bits de referencia para cada página
clock_hand = 0               # Índice del puntero del reloj

def print_state():
    """Función para imprimir el estado actual del reloj y los bits de referencia."""
    print(f"Clock hand is at index: {clock_hand}")
    print(f"Pages: {pages}")
    print(f"Reference bits: {ref_bits}")
    print('-' * 30)

def replace_page():
    """Función que implementa el algoritmo de reemplazo de páginas usando el algoritmo de reloj."""
    global clock_hand
    n = len(pages)  # Número de páginas

    while True:
        print_state()  # Imprimir el estado actual para depuración

        # Verificar el bit de referencia de la página actual
        if ref_bits[clock_hand] == 0:
            # Si el bit de referencia es 0, reemplazar esta página
            page_to_replace = pages[clock_hand]
            print(f"Page to replace: {page_to_replace}")
            return page_to_replace
        else:
            # Si el bit de referencia es 1, ponerlo a 0
            ref_bits[clock_hand] = 0
            # Mover el puntero del reloj a la siguiente página
            clock_hand = (clock_hand + 1) % n

# Llamar a la función de reemplazo de página
replace_page()
