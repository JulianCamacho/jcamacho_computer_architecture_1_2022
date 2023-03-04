import tkinter as tk
from PIL import Image, ImageTk

# Ventana de Tkinter
window = tk.Tk()

# Cargar imagenes
# Manejo del archivo 
with open('5.txt', 'r') as f:
    data = f.read().split()

# Convertir pixeles a enteros 
data = [int(x) for x in data]
encrypted_img = Image.new('L', (640, 960))
encrypted_img.putdata(data)
decrypted_img = Image.open("test.png")

# Crear imagenes
encrypted_photo = ImageTk.PhotoImage(encrypted_img)
decrypted_photo = ImageTk.PhotoImage(decrypted_img)

# Crear labels para desplegar las imagenes lado a lado 
encrypted_label = tk.Label(window, image=encrypted_photo)
encrypted_label.pack(side="left")
decrypted_label = tk.Label(window, image=decrypted_photo)
decrypted_label.pack(side="right")

window.mainloop()


