defmodule DeBrujinGraph do
  def main(args) do
    {ok, content} = File.read(Enum.at(args, 0))
    lines = String.split(content, "\n")
    lines = Enum.filter(lines, fn line -> line != "\r" end)
    lines = Enum.map(lines, fn line -> String.trim(line, "\r") end)
    k = String.to_integer(String.trim(Enum.at(lines, 0), "\r"), 10)
    reads = String.split(Enum.at(lines, 1), ",")
    #d= DateTime.utc_now
    list_of_maps = run_debrujin(reads, k, [])
    # t = DateTime.utc_now
    # final = DateTime.diff(t, d)
    #Vreme izvrsavanja
    # IO.puts final
    IO.inspect list_of_maps
    {:ok, file} = File.open("DeBrujinGraphOutput.txt", [:write, :utf8])
    whole_string = write_to_file(list_of_maps, "")
    IO.binwrite(file, whole_string)
  end

  def write_to_file([], whole_string), do: whole_string
  def write_to_file([head|tail], whole_string) do
    whole_string = whole_string <> Enum.map_join(head, "", fn {key, value} -> ~s{#{key}:#{Enum.join(value, ",")};} end) <> "\n"
    whole_string = write_to_file(tail, whole_string)
  end

  def run_debrujin([], k, list_of_maps), do: list_of_maps
  def run_debrujin([head|tail], k, list_of_maps) do
    list_of_maps = List.insert_at(list_of_maps, Kernel.length(list_of_maps), debrujin_graph(head, k))
    list_of_maps = run_debrujin(tail, k, list_of_maps)
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
    n = String.length(string)
    kmers = iterate_string(0, n - k + 1, string, [], n, k)
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
    kmers = split_kmers(string, k + 1)
    adjacency_list = %{}
    adjacency_list = iterate_kmers(kmers, adjacency_list)
    adjacency_list
  end
end

DeBrujinGraph.main(System.argv)
