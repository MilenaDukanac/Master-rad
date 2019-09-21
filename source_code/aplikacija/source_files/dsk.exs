defmodule DSK do
    def main(args) do
      path = Enum.at(args, 0)
      {ok, content} = File.read(path)
      lines = String.split(content, "\n")
      lines = Enum.filter(lines, fn line -> line != "\r" end)
      available_size = String.to_integer(String.trim(Enum.at(lines, 0), "\r"), 10)
      kmers = String.split(String.trim(Enum.at(lines, 1), "\r"), ",")
      length_of_kmers = Kernel.length(kmers)

      %{size: size} = File.stat!(Enum.at(args, 0))
      number_of_lists_of_kmers = if(rem(size, available_size) == 0) do
        div(size, available_size)
      else
        div(size, available_size) + 1
      end
      number_of_kmers_in_list = div(length_of_kmers, number_of_lists_of_kmers) + 1
      lists_of_kmers = split_list(Kernel.length(kmers), kmers, [], number_of_kmers_in_list)
      #d = DateTime.utc_now
      dsk(lists_of_kmers)
      #t = DateTime.utc_now
      #final = DateTime.diff(t, d)
      #Vreme izvrsavanja
      #IO.puts final
    end

    def split_list(index, kmers, result, number_of_kmers_in_list) when index <= 0 do
      result
    end

    def split_list(index, kmers, result, number_of_kmers_in_list) do
      result = List.insert_at(result, Kernel.length(result), Enum.take(kmers, number_of_kmers_in_list))
      result = split_list(index - number_of_kmers_in_list, Enum.drop(kmers, number_of_kmers_in_list), result, number_of_kmers_in_list)
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

    def iterate_map([], list_of_new_maps), do: list_of_new_maps
    def iterate_map([head|tail], list_of_new_maps) do
      list_of_new_maps = List.insert_at(list_of_new_maps, Kernel.length(list_of_new_maps), iterate(Map.keys(elem(head, 0)), elem(head, 0), elem(head, 1), %{}))
      list_of_new_maps = iterate_map(tail, list_of_new_maps)
    end

    def iterate([], map1, map2, result), do: result
    def iterate([head|tail], map1, map2, result) do
      if(Map.get(map1, head) != "") do
        result = Map.put(result, Map.get(map1, head), Map.get(map2, head))
        result = iterate(tail, map1, map2, result)
      else
        result = iterate(tail, map1, map2, result)
      end
    end

    def take_keys([], list_of_keys), do: list_of_keys
    def take_keys([head|tail], list_of_keys) do
      list_of_keys = take_keys(tail, list_of_keys ++ Map.keys(head))
    end

    def split_list(index, kmers, result, number_of_kmers_in_list) when index <= 0 do
      result
    end

    def split_list(index, kmers, result, number_of_kmers_in_list) do
      result = List.insert_at(result, Kernel.length(result), Enum.take(kmers, number_of_kmers_in_list))
      result = split_list(index - number_of_kmers_in_list, Enum.drop(kmers, number_of_kmers_in_list), result, number_of_kmers_in_list)
    end


    #Algoritam JellyFish

    def calculate_o([], result_table), do: result_table
    def calculate_o([head|tail], result_table) do
      result_table = if(Map.get(result_table, head) == nil) do
        Map.put(result_table, head, 1)
      else
        Map.put(result_table, head, Map.get(result_table, head) + 1)
      end
      result_table = calculate_o(tail, result_table)
    end

    def jellyfish_algorithm(z_table) do
      count_table = calculate_o(z_table, %{})
    end

    #Algoritam DSK

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

    def iterate_jellyfish_paralel(lists_of_kmers, list_of_result_maps) do
      list_of_tasks = run_jellyfish(lists_of_kmers, [])
      list_of_maps = run_await(list_of_tasks, [])
    end

    def dsk(lists_of_kmers) do
      list_of_result_maps = iterate_jellyfish_paralel(lists_of_kmers, [])
      kmer_keys = take_keys(list_of_result_maps, [])
      kmer_keys = Enum.uniq(kmer_keys)
      final_result = create_final_map(kmer_keys, list_of_result_maps, %{})
      {:ok, file} = File.open("DSKOutput.txt", [:write, :utf8])
      map = Enum.map_join(final_result, "\n", fn {key, val} -> ~s{#{key} => #{val}} end)
      IO.binwrite(file, map)
    end
end

DSK.main(System.argv)
