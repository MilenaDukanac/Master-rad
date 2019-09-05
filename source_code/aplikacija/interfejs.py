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


#adresa za listu dostupnih boja  http://www.science.smith.edu/dftwiki/index.php/Color_Charts_for_TKinter

root = Tk()
root.title("Sekvencioniranje genoma")
root.configure(background="cornsilk2")
# Add a grid
mainframe = Frame(root, background="cornsilk2")
mainframe.grid(column=0, row=0, sticky=(N,W,E,S))
mainframe.columnconfigure(0, weight = 1)
mainframe.rowconfigure(0, weight = 1)
mainframe.pack(pady = 50, padx = 50)

# Create a Tkinter variable
tkvar1 = StringVar(root)
tkvar2 = StringVar(root)

# Dictionary with options
choices1 = {'JellyFish','DSK','De Brujin graph','All Eulerian cycles'}
popupMenu1Width = len(max(choices1, key=len))

popupMenu1 = OptionMenu(mainframe, tkvar1, *choices1)
popupMenu1.config(width=popupMenu1Width, bg="LightSkyBlue2")
label = Label(mainframe, text="Izaberite algoritam", bg="cornsilk2", fg="black")
label.config(width=30)
label.grid(row = 0, column = 0, sticky="W", padx=5, pady=5)
popupMenu1.grid(row = 0, column = 1, sticky="W", padx=5, pady=5)
tkvar1.set('JellyFish')

filename = ''

def getFileName():
    global filename
    filename = askopenfilename()
    print(filename)
    entry.insert(0, filename)

openBtn: Button = Button(mainframe, text = 'Izaberite fajl...', bg="LightSkyBlue3", fg="black", width=30, command = getFileName)
openBtn.grid(row = 2, column = 0, sticky="W", padx=5, pady=5)

entry: Entry = Entry(mainframe, width=40)
entry.grid(row = 2, column = 1, padx=5, pady=5)

dictionary: Dict[str, List[str]] = {}
dictionary['JellyFish'] = 'jellyfish.exs'
dictionary['DSK'] = 'dsk.exs'
dictionary['De Brujin graph'] = 'debrujin_graph.exs'
dictionary['All Eulerian cycles'] = 'all_eulerian_cycles.exs'

def executeAlgorithm():
    print('Execute algoritam')

    f = open(filename, 'r')
    value = filename.split("/")
    file = value[len(value) - 1]
    if f.mode == "r" and tkvar1.get() == "JellyFish" and file == "JellyFishData.txt":
        f.seek(0)
        lines: List[str] = f.readlines()
        nucleotides: List[str] = lines[0].rstrip().split(",")
        print(lines[0])
        print(nucleotides)
        alfa = float(lines[1])
        print(str(alfa))
        print("Izvrsavanje algoritma...")
        print(file)
        algorithm_name = dictionary[tkvar1.get()]
        print(algorithm_name)
        result_file = algorithm_name.split(".")[0] + ".txt"

        cmd = "elixir" + " " + algorithm_name + " " + lines[0] + " " + str(alfa) + ">" + result_file
        print(cmd)
        os.system(cmd)
        messagebox.showinfo("Information", "Algoritam je uspešno izvršen. Rezultati izvršavanja se nalaze u fajlu " + result_file)
    elif f.mode == "r" and tkvar1.get() == "DSK" and file == "DSKData.txt":
        f.seek(0)
        lines: List[str] = f.readlines()
        nucleotides: List[str] = lines[0].rstrip().split(",")
        print(nucleotides)
        M = float(lines[1])
        print(str(M))
        D = float(lines[2])
        print(str(D))

        print("Izvrsavanje algoritma...")

        print(file)
        algorithm_name = dictionary[tkvar1.get()]
        print(algorithm_name)
        result_file = algorithm_name.split(".")[0] + ".txt"

        cmd = "elixir" + " " + algorithm_name + " " + lines[0] + " " + str(M) + " " + str(D)+ ">" + result_file
        os.system(cmd)
        messagebox.showinfo("Information","Algoritam je uspešno izvršen. Rezultati izvršavanja se nalaze u fajlu " + result_file)
    elif f.mode == "r" and tkvar1.get() == "De Brujin graph" and file == "DeBrujinData.txt":
        f.seek(0)
        lines: List[str] = f.readlines()
        nucleotides: List[str] = lines[0].rstrip().split(",")
        print(nucleotides)

        k = float(lines[1])
        print(str(k))
        print("Izvrsavanje algoritma...")
        print(file)
        algorithm_name = dictionary[tkvar1.get()]
        print(algorithm_name)
        result_file = algorithm_name.split(".")[0] + ".txt"

        cmd = "elixir" + " " + algorithm_name + " " + lines[0] + " " + str(k) + ">" + result_file
        os.system(cmd)
        messagebox.showinfo("Information","Algoritam je uspešno izvršen. Rezultati izvršavanja se nalaze u fajlu " + result_file)
    elif f.mode == "r" and tkvar1.get() == "All Eulerian cycles" and file == "EulerData.txt":
        f.seek(0)
        lines: List[str] = f.readlines()

        print("Izvrsavanje algoritma...")
        print(file)
        algorithm_name = dictionary[tkvar1.get()]
        print(algorithm_name)
        result_file = algorithm_name.split(".")[0] + ".txt"

        cmd = "elixir" + " " + algorithm_name + " " + lines[0] + ">" + result_file
        os.system(cmd)
        messagebox.showinfo("Information", "Algoritam je uspešno izvršen. Rezultati izvršavanja se nalaze u fajlu " + result_file)
    else:
        messagebox.showwarning("Warning", "Izaberite odgovarajući algoritam i odgovarajići fajl!")

executeBtn: Button = Button(mainframe, text = 'Pokrenite algoritam', bg="LightSkyBlue3", fg="black", width=30, command = executeAlgorithm)
executeBtn.grid(row = 3, columnspan=2, sticky=W+E, padx=5, pady=5)

# on change dropdown value
def change_dropdown(*args):
    tkvar1.set(tkvar1.get())

# link function to change dropdown
tkvar1.trace('w', change_dropdown)

root = mainloop()

#root.withdraw() # we don't want a full GUI, so keep the root window from appearing
#filename = askopenfilename() # show an "Open" dialog box and return the path to the selected file
#print(filename)
