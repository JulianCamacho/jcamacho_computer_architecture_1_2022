# Funcion para convertir cada valor decimal en un archivo a su valor en binario

# Abrir archivos
input_file = open('5.txt', 'r')
output_file = open('6.txt', 'w')

for line in input_file:
    numbers = line.split()
    binary_numbers = []
    for number in numbers:
        # Convertir
        binary_number = bin(int(number))[2:].zfill(8)
        binary_numbers.append(binary_number)

    output_file.write(' '.join(binary_numbers) + '\n')

# Cerrar archivos
input_file.close()
output_file.close()
