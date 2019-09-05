iex(1)>tuple = {:ok, "hello", 1}
{:ok, "hello", 1}
iex(2)>put_elem(tuple, 1, "world")
{:ok, "world", 1}
iex(3)>tuple
{:ok, "hello", 1}
