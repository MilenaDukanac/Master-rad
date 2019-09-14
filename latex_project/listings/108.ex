def calculate([], count_table), do: count_table
def calculate([head|tail], count_table) do
  count_table = if(Map.get(count_table, head) == nil) do
    Map.put(count_table, head, 1)
  else
    Map.put(count_table, head, Map.get(count_table, head) + 1)
  end
  count_table = calculate(tail, count_table)
end
