iex(4)> users = update_in users[:mary].languages,
fn languages -> List.delete(languages, "Clojure") end
[
  john:%{age:31,languages:["Erlang","Ruby","Elixir"],name:"John"},
  mary:%{age:29,languages:["Elixir","F#"],name:"Mary"}
]
