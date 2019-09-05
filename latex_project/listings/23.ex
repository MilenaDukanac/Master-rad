iex(3)> users = put_in users[:john].age, 31
[
  john:%{age:31,languages:["Erlang","Ruby","Elixir"],name:"John"},
  mary:%{age:29,languages:["Elixir","F#","Clojure"],name:"Mary"}
]
