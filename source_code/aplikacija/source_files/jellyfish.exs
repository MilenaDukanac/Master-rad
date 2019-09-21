defmodule JellyFish do
  def main(args) do
    {ok, content} = File.read(Enum.at(args, 0))
    kmers = String.split(String.trim(content, "\r\n"), ",")
    length_of_kmers = Kernel.length(kmers)
    #number_of_kmers_in_list = div(length_of_kmers, 4) + 1
    number_of_kmers_in_list = if(rem(length_of_kmers, 4) == 0) do
		div(length_of_kmers, 4)
	else
		div(length_of_kmers, 4) + 1
	end
    list_of_kmers = split_list(Kernel.length(kmers), kmers, [], number_of_kmers_in_list)

    #paralelno
    #d = DateTime.utc_now
    list_of_tasks = run_jellyfish(list_of_kmers, [])
    list_of_maps = run_await(list_of_tasks, [])
    #t = DateTime.utc_now
    #final = DateTime.diff(t, d)
    #Vreme izvrsavanja
    #IO.puts final

    #sekvencijalno
    # d = DateTime.utc_now
    # h_map = jellyfish_algorithm(kmers)
    # t = DateTime.utc_now
    # final = DateTime.diff(t, d)
    # IO.puts final
    # list_of_maps = [h_map]

    kmer_keys = take_keys(list_of_maps, [])
    kmer_keys = Enum.uniq(kmer_keys)
    final_result = create_final_map(kmer_keys, list_of_maps, %{})
    {:ok, file} = File.open("JellyFishOutput.txt", [:write, :utf8])
    map = Enum.map_join(final_result, "\n", fn {key, val} -> ~s{#{key} => #{val}} end)
    IO.binwrite(file, map)
  end

  def create_final_map([], list_of_new_maps, result), do: result
  def create_final_map([head|tail], list_of_new_maps, result) do
    value = iterate_new_maps(list_of_new_maps, head, 0)
    result = Map.put(result, head, value)
    result = create_final_map(tail, list_of_new_maps, result)
  end

  def iterate_new_maps([], key, value), do: value
  def iterate_new_maps([head|tail], key, value) do
    tmp = if(Map.get(head, key) != nil) do
      Map.get(head, key)
     else
       0
     end
    value = iterate_new_maps(tail, key, value + tmp)
  end

  def take_keys([], list_of_keys), do: list_of_keys
  def take_keys([head|tail], list_of_keys) do
    list_of_keys = take_keys(tail, list_of_keys ++ Map.keys(head))
  end

  def run_await([], list_of_maps), do: list_of_maps
  def run_await([head|tail], list_of_maps) do
    res = Task.await(head, 100000000)
    list_of_maps = List.insert_at(list_of_maps, Kernel.length(list_of_maps), res)
    list_of_maps = run_await(tail, list_of_maps)
  end

  def run_jellyfish([], list_of_tasks), do: list_of_tasks
  def run_jellyfish([head|tail], list_of_tasks) do
    task = Task.async(fn -> jellyfish_algorithm(head) end)
    list_of_tasks = List.insert_at(list_of_tasks, Kernel.length(list_of_tasks), task)
    list_of_tasks = run_jellyfish(tail, list_of_tasks)
  end

  def split_list(index, kmers, result, number_of_kmers_in_list) when index <= 0 do
    result
  end

  def split_list(index, kmers, result, number_of_kmers_in_list) do
    result = List.insert_at(result, Kernel.length(result), Enum.take(kmers, number_of_kmers_in_list))
    result = split_list(index - number_of_kmers_in_list, Enum.drop(kmers, number_of_kmers_in_list), result, number_of_kmers_in_list)
  end

  def calculate([], z_table), do: z_table
  def calculate([head|tail], z_table) do
    z_table = if(Map.get(z_table, head) == nil) do
      Map.put(z_table, head, 1)
    else
      Map.put(z_table, head, Map.get(z_table, head) + 1)
    end
    z_table = calculate(tail, z_table)
  end

  def jellyfish_algorithm(z_table) do
    count_table = calculate(z_table, %{})
  end
end

JellyFish.main(System.argv)
