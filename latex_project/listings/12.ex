iex(1)> lista = [{:a, 1}, {:b, 2}, {:c, 3}]
[a: 1, b: 2, c: 3]
iex(2)>lista ++ [d: 4]
[a: 1, b: 2, c: 3, d: 4]
iex(3)>[a: 0] ++ lista
[a: 0, a: 1, b: 2, c: 3]