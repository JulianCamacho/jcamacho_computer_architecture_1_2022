import tkinter as tk
from PIL import Image, ImageTk

# Ventana de Tkinter
window = tk.Tk()
window.geometry("640x960")

# Cargar imagenes
encrypted_img = Image.open("test.png")
decrypted_img = Image.open("test.png")
encrypted_photo = ImageTk.PhotoImage(encrypted_img)
decrypted_photo = ImageTk.PhotoImage(decrypted_img)

# Crear labels
encrypted_label = tk.Label(window, image=encrypted_photo)
encrypted_label.pack(side="left")
decrypted_label = tk.Label(window, image=decrypted_photo)
decrypted_label.pack(side="right")

window.mainloop()