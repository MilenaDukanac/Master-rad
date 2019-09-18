# Master-rad

STRUKTURA PROJEKTA

Projkat se sastoji od četiri foldera:
  -data_files
  -result_files
  -source_files
  -executables

Folder data_files sadrži tekstualne fajlove u kojima se nalaze ulazni podaci na kojima je moguće testirati implementirane algoritme (JellyFishData.txt, DSKData.txt, DeBrujinGraphData.txt, AllEulerianCyclesData.txt).

Folder result_files sadrži tekstualni fajlove u kojima se nalaze rezultati izvršavanja algoritama (JellyFishOutput.txt, DSKOutput.txt, DeBrujinGraphOutput.txt, AllEulerianCyclesOutput.txt). 

Folder source_files sadrži izvorne fajlove u programskom jeziku Elixir u kojima se nalazi implementacija algoritama (jellyfish.exs, dsk.exs, debrujin_graph.exs, all_eulerian_cycles.exs). 

Folder executables sadrži izvršne verzije izvornih fajlova. 

Pored ova četiri foldera, projekat sadrži i fajl interface.py u kome se nalazi interfejs koji sjedinjuje algoritme u jedinstvenu aplikaciju.

-Preduslovi-
Da bi se aplikacija pokrenula, potrebno je imati instaliran Python interpreter u kome treba kompajlirati fajl interface.py pomoću komande "python interface.py". Nakon toga aplikacija se može pokrenuti pokretanjem izvršne verzije fajla interface.py.

Implementirani algoritmi se mogu pokretati direktno uz pomoć Elixir interpretera. Potrebno je izvršiti komandu "elixir ime_algoritma.exs" ili "iex ime_algoritma.exs" za kojom slede argumenti u zagradi. Izvršne verzije Elixir fajlova se mogu pokretati iz komandne linije i bez instaliranja Elixir-a. Python interfejs podrazumeva korišćenje izvršnih programa.

Za dobijanje izvršnih programa iz.exs fajlova potrebnoje izvršiti sledeće korake u komandnoj liniji:
  •pozicionirati se na lokaciju gde zelite da kreirate projekat
  •izvršiti komandu "mix new ime_projekta"
  •kompajlirati projekat pomoću komande "mix" ili "mix compile# u roditeljskom direktorijumu
  •u lib folderu projekta kreirati novi folder koji nosi naziv željenog algoritma i u njemu fajl cli.ex koji ima sledeći sadržaj
    defmodule ImeAlgoritma.CLI do
      def main(args) do
        options = [switches: [file: :string],aliases: [f: :file]]
        {opts,_,_}= OptionParser.parse(args, options)
        IO.inspect opts, label: "Command Line Arguments"
      end
    end
 
 Nakon izvršenih komandi, u roditeljskom direktorijumu će se pojaviti izvršna verzija izvornog fajla.
