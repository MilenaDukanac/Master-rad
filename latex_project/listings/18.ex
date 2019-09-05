iex(1)>mapa = %{:a => 1, 2 => :b}
%{2 => :b, :a => 1}
iex(2)>%{mapa | 2 => "dva"}
%{2 => "dva", :a => 1}
iex(3)>%{mapa | :c => 3}
** (KeyError) key :c not found in: %{2 => :b, :a => 1}
    (stdlib) :maps.update(:c, 3, %{2 => :b, :a => 1})
    (stdlib)  erl_eval.erl:259: anonymous fn/2 in :erl_eval.expr/5
    (stdlib) lists.erl:1263: :lists.foldl/3
