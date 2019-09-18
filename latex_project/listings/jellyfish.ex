defmodule JellyFish do
  def main(args) do
    #IO.inspect(jellyfish_algorithm(["AC","CG","AC","GT","CA","GG","AC","GT"], 0.7))
    #kmers = String.split(Enum.at(args, 0), ",")
    #alpha = String.to_float(Enum.at(args, 1))
    #IO.inspect(jellyfish_algorithm(kmers, alpha))
  end

  def symbol_to_number(c) do
    map = %{"A" => "00", "T" => "01", "C" => "10", "G" => "11"}
    map[c]
  end

  def pattern_to_number(_pattern, begin_string, index, length_of_pattern) when index == length_of_pattern do
    String.to_integer(begin_string, 10)
  end

  def pattern_to_number(pattern, begin_string, index, length_of_pattern) do
    begin_string = begin_string <> symbol_to_number(String.at(pattern, index))
    pattern_to_number(pattern, begin_string, index + 1, length_of_pattern)
  end

  def calculate_i(h_table, z, i, size) do
    if Map.get(h_table, i) != z and Map.get(h_table, i) != "" do
      i = calculate_i(h_table, z, rem(i + 1, size), size)
    else
      i
    end
  end

  #h je hes funkcija i nju definisemo pre pozivanja funkcije i prosledjujemo je kao argument
  #z je neki k-mer iz velikog skupa k-mera
  #g je hes tabela
  #size je velicina hes tabele
  def hashEntry(h_table, z, size) do
    i = rem(pattern_to_number(z, "", 0, String.length(z)), size)
    calculate_i(h_table, z, i, size)
  end

  def build_h_table(h_table_empty, 0), do: h_table_empty
  def build_h_table(h_table_empty, size_of_H) do
      size_of_H = size_of_H - 1
      h_table_empty = Map.put(h_table_empty, size_of_H, "")
      build_h_table(h_table_empty, size_of_H)
  end

  def build_count_table(count_table_empty, 0), do: count_table_empty
  def build_count_table(count_table_empty, size_of_count_table) do
      size_of_count_table = size_of_count_table - 1
      count_table_empty = Map.put(count_table_empty, size_of_count_table, 0)
      build_count_table(count_table_empty, size_of_count_table)
  end

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

  def jellyfish_algorithm(z_table, alfa) do
    #z_table = ['AC','CG','AC','GT','CA','GG','AC','GT']
    #alfa = 0.7
    n = Kernel.length(z_table)
    size_of_H = Kernel.round(Float.ceil(n/alfa))
    h_table = build_h_table(%{}, size_of_H)
    count_table = build_count_table(%{}, size_of_H)
    {h_table, count_table} = calculate(h_table, count_table, z_table, size_of_H)
  end

end

JellyFish.main(System.argv)
