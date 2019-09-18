iex(4)> korisnici = update_in korisnici[:marija].jezici,
fn jezici -> List.delete(jezici, "Clojure") end
[
  john:%{godine:31,jezici:["Erlang","Ruby","Elixir"],ime:"Dzoni"},
  marija:%{godine:29,jezici:["Elixir","F#"],ime:"Marija"}
]
