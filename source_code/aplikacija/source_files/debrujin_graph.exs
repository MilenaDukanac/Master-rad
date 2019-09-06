defmodule DeBrujin do
  def main(args) do
    IO.inspect debrujin_graph(Enum.at(args, 0), Enum.at(args, 1))
    # result = debrujin_graph(Enum.at(args, 0), Enum.at(args, 1))
    # text = Enum.map_join(result, fn{key, val} -> key <> "=>" <> inspect(val) <> "\n" end)
    # {:ok, file} = File.open("debrujin_results.txt", [:write, :utf8])
    # IO.binwrite(file, text)
  end


  def iterate_string(start_index, end_index, string, kmers, n, k) when start_index == end_index do
    kmers
  end

  def iterate_string(start_index, end_index, string, kmers, n, k) do
    kmer = String.slice(string, start_index, k)
    kmers = List.insert_at(kmers, start_index, kmer)
    kmers = iterate_string(start_index + 1, end_index, string, kmers, n, k)
  end

  def split_kmers(string, k) do
    kmers = []
    n = String.length(string)
    end_index = n - k + 1
    kmers = iterate_string(0, end_index, string, kmers, n, k)
  end

  def iterate_kmers([], adjacency_list) do
    adjacency_list
  end

  def iterate_kmers([head|tail], adjacency_list) do
    u = String.slice(head, 0, String.length(head) - 1)
    v = String.slice(head, 1, String.length(head) - 1)

    adjacency_list = if Enum.member?(Map.keys(adjacency_list), u) == false do
      adjacency_list = Map.put(adjacency_list, u, [])
    else
      adjacency_list
    end

    adjacency_list = if Enum.member?(Map.keys(adjacency_list), v) == false do
      adjacency_list = Map.put(adjacency_list, v, [])
    else
      adjacency_list
    end

    adjacency_list_u = List.insert_at(Map.get(adjacency_list, u), Kernel.length(Map.get(adjacency_list, u)), v)
    adjacency_list = Map.put(adjacency_list, u, adjacency_list_u)
    adjacency_list = iterate_kmers(tail, adjacency_list)
  end

  def debrujin_graph(string, k) do
    kmers = split_kmers(string, k)
    adjacency_list = %{}
    adjacency_list = iterate_kmers(kmers, adjacency_list)
    adjacency_list
  end
end

DeBrujin.main(System.argv)
