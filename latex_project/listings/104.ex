def calculate(h_table, count_table, [], _size_of_H), do: {h_table, count_table}
def calculate(h_table, count_table, [head|tail], size_of_H) do
  i = hashEntry(h_table, head, size_of_H)
  if Map.get(h_table, i) == "" do
    h_table = Map.put(h_table, i, head)
    count_table = Map.put(count_table, i, 1)
    {h_table, count_table} = calculate(h_table, count_table, tail, size_of_H)
  else
    count_table = Map.put(count_table, i, Map.get(count_table, i) + 1)
    {h_table, count_table} = calculate(h_table, count_table, tail, size_of_H)
  end
end
