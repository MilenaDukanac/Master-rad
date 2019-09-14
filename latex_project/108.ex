def calculate([], z_table), do: z_table
def calculate([head|tail], z_table) do
  z_table = if(Map.get(z_table, head) == nil) do
    Map.put(z_table, head, 1)
  else
    Map.put(z_table, head, Map.get(z_table, head) + 1)
  end
  z_table = calculate(tail, z_table)
end
