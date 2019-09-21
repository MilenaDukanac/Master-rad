from tkinter import *
from tkinter import Button, Entry
from tkinter.filedialog import askopenfilename
from typing import Dict, List
from functools import partial
import subprocess
import os
from subprocess import Popen, PIPE, STDOUT
from tkinter import messagebox
from optparse import OptionParser

root = Tk()
root.title("Sekvencioniranje genoma")
root.configure(background="cornsilk2")

# Add a grid
mainframe = Frame(root, background="cornsilk2")
mainframe.grid(column=0, row=0, sticky=(N, W, E, S))
mainframe.columnconfigure(0, weight=1)
mainframe.rowconfigure(0, weight=1)
mainframe.pack(pady=50, padx=50)

# Create a Tkinter variable
tkvar1 = StringVar(root)

# Dictionary with options
choices1 = {'JellyFish','DSK','DeBrujinGraph','AllEulerianCycles'}
popupMenu1Width = len(max(choices1, key=len))
popupMenu1 = OptionMenu(mainframe, tkvar1, *choices1)
popupMenu1.config(width=popupMenu1Width, bg="LightSkyBlue2")
label = Label(mainframe, text="Izaberite algoritam", bg="cornsilk2", fg="black")
label.config(width=30)
label.grid(row=0, column=0, sticky="W", padx=5, pady=5)
popupMenu1.grid(row=0, column=1, sticky="W", padx=5, pady=5)
tkvar1.set('JellyFish')

filename = ''

def getFileName():
    global filename
    filename = askopenfilename()
    print(filename)
    entry.insert(0, filename)

openBtn: Button = Button(mainframe, text = 'Izaberite fajl...', bg="LightSkyBlue3", fg="black", width=30, command=getFileName)
openBtn.grid(row=2, column=0, sticky="W", padx=5, pady=5)

entry: Entry = Entry(mainframe, width=40)
entry.grid(row=2, column=1, padx=5, pady=5)

dictionary: Dict[str, List[str]] = {}
dictionary['JellyFish'] = 'jellyfish.exs'
dictionary['DSK'] = 'dsk.exs'
dictionary['DeBrujinGraph'] = 'debrujin_graph.exs'
dictionary['AllEulerianCycles'] = 'all_eulerian_cycles.exs'

def executeAlgorithm():
    f = open(filename, 'r')
    value = filename.split("/")
    file = value[len(value) - 1]
    if f.mode == "r" and tkvar1.get() == "JellyFish" and file == "JellyFishData.txt":
        algorithm_name = dictionary[tkvar1.get()]
        cmd = "elixir" + " " + algorithm_name + " " + file
        os.system(cmd)
        messagebox.showinfo("Information", "Algoritam je uspešno izvršen. Rezultati izvršavanja se nalaze u fajlu " + " JellyFishOutput.txt")
    elif f.mode == "r" and tkvar1.get() == "DSK" and file == "DSKData.txt":
        algorithm_name = dictionary[tkvar1.get()]
        cmd = "elixir" + " " + algorithm_name + " " + file
        os.system(cmd)
        messagebox.showinfo("Information","Algoritam je uspešno izvršen. Rezultati izvršavanja se nalaze u fajlu " + " DSKOutput.txt")
    elif f.mode == "r" and tkvar1.get() == "DeBrujinGraph" and file == "DeBrujinData.txt":
        algorithm_name = dictionary[tkvar1.get()]
        cmd = "elixir" + " " + algorithm_name + " " + file
        os.system(cmd)
        messagebox.showinfo("Information","Algoritam je uspešno izvršen. Rezultati izvršavanja se nalaze u fajlu " + " DeBrujinGraphOutput.txt")
    elif f.mode == "r" and tkvar1.get() == "AllEulerianCycles" and file == "AllEulerianCyclesData.txt":
        algorithm_name = dictionary[tkvar1.get()]
        cmd = "elixir" + " " + algorithm_name + " " + file
        os.system(cmd)
        messagebox.showinfo("Information", "Algoritam je uspešno izvršen. Rezultati izvršavanja se nalaze u fajlu " + " AllEulerianCyclesOutput.txt")
    else:
        messagebox.showwarning("Warning", "Izaberite odgovarajući algoritam i odgovarajići fajl.")

executeBtn: Button = Button(mainframe, text = 'Pokrenite algoritam', bg="LightSkyBlue3", fg="black", width=30, command=executeAlgorithm)
executeBtn.grid(row = 3, columnspan=2, sticky=W+E, padx=5, pady=5)

# on change dropdown value
def change_dropdown(*args):
    tkvar1.set(tkvar1.get())

# link function to change dropdown
tkvar1.trace('w', change_dropdown)

root = mainloop()
