import tkinter as tk
from PIL import Image, ImageTk

# Ventana de Tkinter
window = tk.Tk()
window.title('Desencriptación mediante RSA')

# Cargar imagenes
# Manejo del archivo 
with open('./test_2/input.txt', 'r') as f:
    data = f.read().split()

with open('./test_2/output.txt', 'r') as f_output:
    output = f_output.read().split()


# Convertir pixeles a enteros 
data = [int(x) for x in data]
output = [int(y) for y in output]

encrypted_img = Image.new('L', (640, 960))
encrypted_img.putdata(data)

decrypted_img = Image.new('L', (640, 480))
decrypted_img.putdata(output)

# Crear imagenes
encrypted_photo = ImageTk.PhotoImage(encrypted_img)
decrypted_photo = ImageTk.PhotoImage(decrypted_img)

# Crear labels para desplegar las imagenes lado a lado 
encrypted_label = tk.Label(window, image=encrypted_photo)
encrypted_label.pack(side="left")
decrypted_label = tk.Label(window, image=decrypted_photo)
decrypted_label.pack(side="right")

window.mainloop()


