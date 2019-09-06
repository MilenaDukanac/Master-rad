defmodule DSK do

  def main(args) do
    #IO.inspect(dsk(["AC", "CG", "AC", "GT", "CA", "GG", "AC", "GT"], 6, 5))
    kmers = String.split(Enum.at(args, 0), ",")
    M = String.to_float(Enum.at(args, 1))
    M = String.to_float(Enum.at(args, 2))
    IO.inspect(dsk(kmers, M, D))
  end

  def symbol_to_number(c) do
    mapa = %{"A" => "00", "T" => "01", "C" => "10", "G" => "11"}
    mapa[c]
  end

  def pattern_to_number
  (_pattern, begin_string, index, length_of_pattern) when index == length_of_pattern do
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
    n = Kernel.length(z_table)
    size_of_H = Kernel.round(Float.ceil(n/alfa))
    h_table = build_h_table(%{}, size_of_H)
    count_table = build_count_table(%{}, size_of_H)
    {h_table, count_table} = calculate(h_table, count_table, z_table, size_of_H)
  end

  def iterate_z([], n_for_iterate, n_list, n_sublist, set_of_empty_sublists), do: set_of_empty_sublists

  def iterate_z([head|tail], n_for_iterate, n_list, n_sublist, set_of_empty_sublists) do
    # IO.puts head
    # IO.puts pattern_to_number(head, "", 0, String.length(head))
    if(rem(pattern_to_number(head, "", 0, String.length(head)), n_list) == n_for_iterate) do
      j = rem(div(pattern_to_number(head, "", 0, String.length(head)), n_list), n_sublist)
      #IO.puts "j je #{j}"
      current = Enum.at(set_of_empty_sublists, j)
      #IO.inspect current
      #IO.puts head
      #current = MapSet.put(current, head)
      current = List.insert_at(current, 0, head)
      #IO.inspect current
      #IO.puts "Trenutni i j je #{j}"
      #IO.inspect current
      #set_of_empty_sublists = List.insert_at(set_of_empty_sublists, j, current)
      set_of_empty_sublists = List.update_at(set_of_empty_sublists, j, fn val -> current end)
      #IO.puts "Nakon zamene"
      #IO.inspect set_of_empty_sublists
      set_of_empty_sublists = iterate_z(tail, n_for_iterate, n_list, n_sublist, set_of_empty_sublists)
    else
      #IO.puts "Nije jednak"
      set_of_empty_sublists = iterate_z(tail, n_for_iterate, n_list, n_sublist, set_of_empty_sublists)
    end
  end

  def iterate_n_sublist(-1, set_of_empty_sublists, h_table, count_table), do: {h_table, count_table}
  def iterate_n_sublist(n_sublist, set_of_empty_sublists, h_table, count_table) do
    #IO.puts "Uslo u iterate_n_sublist"
    #IO.inspect n_sublist
    #IO.inspect Enum.at(set_of_empty_sublists, n_sublist)
    d_j = Enum.at(set_of_empty_sublists, n_sublist)
    #IO.inspect d_j
    #Pokreni jellyfish algoritam
    {h_table, count_table} = jellyfish_algorithm(d_j, 0.7)
    if Map.keys(h_table) != [] do
      #IO.puts "Izvrsen jellyfish h tabela"
      IO.inspect h_table
    end

    if Map.keys(count_table) != [] do
      #IO.puts "Izvrsen jellyfish count tabela"
      IO.inspect count_table
    end
    #IO.puts "Proslo jellyfish"
    {h_table, count_table} = iterate_n_sublist(n_sublist - 1, set_of_empty_sublists, h_table, count_table)
  end

  def check_list([], ind), do: ind
  def check_list([head|tail], ind) do
    if Enum.empty?(head) == false do
      ind = false
      tail = []
      check_list(tail, ind)
    else
      check_list(tail, ind)
    end
  end

  def iterate_n_list(z_table, -1, n_list, n_sublist, set_of_empty_sublists), do: set_of_empty_sublists
  def iterate_n_list(z_table, n_for_iterate, n_list, n_sublist, set_of_empty_sublists) do
    set_of_empty_sublists = List.duplicate([], n_sublist)
    #IO.inspect set_of_empty_sublists
    set_of_empty_sublists = iterate_z(z_table, n_for_iterate, n_list, n_sublist, set_of_empty_sublists)

    #IO.puts "Nakon zamene svih"
    #IO.inspect set_of_empty_sublists
    ind = true
    ind = check_list(set_of_empty_sublists, ind)

    if ind == false do
      IO.inspect set_of_empty_sublists
    end

    n = Kernel.length(set_of_empty_sublists)
    h_table = build_h_table(%{}, n)
    count_table = build_count_table(%{}, n)
    #IO.puts "Nakon iterate_z"
    #IO.inspect(set_of_empty_sublists)
    {h_table, count_table} = iterate_n_sublist(n_sublist - 1, set_of_empty_sublists, h_table, count_table)
    #IO.inspect h_table
    #IO.inspect count_table
    set_of_empty_sublists = iterate_n_list(z_table, n_for_iterate - 1, n_list, n_sublist, set_of_empty_sublists)
  end

  #M bitova - ciljna memorija
  #D bitova - ciljna velicina diska
  #h - hes funkcija
  def dsk(z_table, m, d) do
    k = String.length(Enum.at(z_table, 0))
    n = Kernel.length(z_table)
    n_list = div(2*k*n, d)
    n_sublist = div(d*(2*k + 32), round(0.7*(2*k)*m))
    #IO.puts n_list
    #IO.puts n_sublist
    #IO.inspect z_table
    n_for_iterate = n_list - 1
    set_of_empty_sublists = List.duplicate([], n_sublist)

    #IO.inspect set_of_empty_sublists
    set_of_empty_sublists = iterate_n_list(z_table, n_for_iterate, n_list, n_sublist, set_of_empty_sublists)
  end
end

DSK.main(System.argv)
