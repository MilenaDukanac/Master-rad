defmodule JellyFish do
  def symbol_to_number(c) do
  	map = %{"A" => "00", "T" => "01", "C" => "10", "G" => "11"}
  	map[c]
  end

  def pattern_to_number(pattern) do
   	chars = String.graphemes(pattern)
  	mapped_chars = Enum.map(chars, fn char -> symbol_to_number(char) end)
  	new_pattern = Enum.join(mapped_chars, "")
  	String.to_integer(new_pattern, 10)
  end

  def calculate_i(h_table, z, i, size) do
    if Map.get(h_table, i) != "" and Map.get(h_table, i) != z  do
      i = calculate_i(h_table, z, rem(i + 1, size), size)
    else
      i
    end
  end

  def hashEntry(h_table, z, size) do
    i = rem(pattern_to_number(z), size)
    calculate_i(h_table, z, i, size)
  end

  def build_h_table(h_table_empty, 0), do: h_table_empty
  def build_h_table(h_table_empty, size_of_H) do
      h_table_empty = Map.put(h_table_empty, size_of_H - 1, "")
      build_h_table(h_table_empty, size_of_H - 1)
  end

  def build_count_table(count_table_empty, 0), do: count_table_empty
  def build_count_table(count_table_empty, size_of_count_table) do
      count_table_empty = Map.put(count_table_empty, size_of_count_table - 1, 0)
      build_count_table(count_table_empty, size_of_count_table - 1)
  end

  def calculate(h_table, count_table, [], _), do: {h_table, count_table}
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

  def jellyfish_algorithm(z_table, alfa) do
    n = Kernel.length(z_table)
    size_of_H = Kernel.round(Float.ceil(n/alfa))
    h_table = build_h_table(%{}, size_of_H)
    count_table = build_count_table(%{}, size_of_H)
    {h_table, count_table} = calculate(h_table, count_table, z_table, size_of_H)
  end

end
