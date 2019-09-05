iex(1)>mapa = %{:a => 1, 2 => :b}
%{2 => :b, :a => 1}
iex(2)>mapa.a
1
iex(3)>mapa.c
** (KeyError) key :c not found in: %{2 => :b, :a => 1}
