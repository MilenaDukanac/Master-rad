defmodule Euler do
  def main(args) do
    {ok, content} = File.read(Enum.at(args, 0))
    graphs = String.split(content, "\n")
    graphs = Enum.map(graphs, fn graph -> String.trim(graph, "\r") end)
    graphs = run_build_graph(graphs, [])
    #d = DateTime.utc_now
    list_of_contigs = run_euler(graphs, [])
    # t = DateTime.utc_now
    # final = DateTime.diff(t, d)
    #Vreme izvrsavanja
    # IO.puts final
    {:ok, file} = File.open("AllEulerianCyclesOutput.txt", [:write, :utf8])
    list_of_contigs = Enum.filter(list_of_contigs, fn x -> Kernel.length(x) != 0 end)
    contigs_to_string = Enum.map_join(list_of_contigs, "\n", fn elem -> ~s{[#{Enum.join(elem, ",")}]} end)
    IO.binwrite(file, contigs_to_string)
  end

  def run_build_graph([], list_of_graphs), do: list_of_graphs
  def run_build_graph([head|tail], list_of_graphs) do
    elements = String.split(head, ";")
    elements = Enum.filter(elements, fn x -> x != "" end)
    list_of_graphs = List.insert_at(list_of_graphs, Kernel.length(list_of_graphs), build_graph(elements, %{}))
    list_of_graphs = run_build_graph(tail, list_of_graphs)
  end

  def build_graph([], graph), do: graph
  def build_graph([head|tail], graph) do
    if(head != "") do
      nodes = String.split(head, ":")
      left = Enum.at(nodes, 0)
      right = Enum.at(nodes, 1)
      edges = if(right == "" or right == nil) do
        []
      else
        String.split(right, ",")
      end
      graph = Map.put(graph, left, edges)
      graph = build_graph(tail, graph)
    else
      graph = build_graph(tail, graph)
    end
  end

  def run_euler([], list_of_contigs), do: list_of_contigs

  def run_euler([head|tail], list_of_contigs) do
    list_of_contigs = List.insert_at(list_of_contigs, Kernel.length(list_of_contigs), all_eulerian_cycles(head))
    list_of_contigs = run_euler(tail, list_of_contigs)
  end

  #Algoritam AllEulerCycles

  def iterate_values([], all_degrees), do: all_degrees
  def iterate_values([head|tail], all_degrees) do
    all_degrees = Map.put(all_degrees, head, {elem(Map.get(all_degrees, head), 0) + 1, elem(Map.get(all_degrees, head), 1)})
    all_degrees = iterate_values(tail, all_degrees)
  end

  def iterate_keys([], graph, all_degrees), do: all_degrees
  def iterate_keys([head|tail], graph, all_degrees) do
    all_degrees = Map.put(all_degrees, head, {elem(Map.get(all_degrees, head), 0), 0 + Kernel.length(Map.get(graph, head))})
    all_degrees = iterate_values(Map.get(graph, head), all_degrees)
    all_degrees = iterate_keys(tail, graph, all_degrees)
  end

  def initialize([], all_degrees), do: all_degrees
  def initialize([head|tail], all_degrees) do
    all_degrees = Map.put(all_degrees, head, {0, 0})
    all_degrees = initialize(tail, all_degrees)
  end

  def calculate_degrees(graph) do
    all_degrees = initialize(Map.keys(graph), %{})
    all_degrees = iterate_keys(Map.keys(graph), graph, all_degrees)
  end



  def iterate_ij(g_graph, v_node, 1, 1, cycle, index, all_degrees) do
    u = Enum.at(Map.get(g_graph, v_node), 0)
    cycle = List.insert_at(cycle, index, [v_node, u])
    if Enum.at(Enum.at(cycle, 0), 0) == Enum.at(Enum.at(cycle, Kernel.length(cycle) - 1), 1) do
      cycle
    else
      v_node = u
      cycle = iterate_ij(g_graph, v_node, elem(Map.get(all_degrees, v_node), 0), elem(Map.get(all_degrees, v_node), 1), cycle, index + 1, all_degrees)
    end
  end

  def iterate_ij(g_graph, v_node, in_degree, out_degree, cycle, index, all_degrees) do
    None
  end

  def isolated_cycle(g_graph, v_node, all_degrees) do
    cycle = []
    cycle = iterate_ij(g_graph, v_node, elem(Map.get(all_degrees, v_node), 0), elem(Map.get(all_degrees, v_node), 1), cycle, 0, all_degrees)
    if cycle != None do
      cycle
    else
      None
    end
  end

  def iterate_path(i, path_length, path, dna_string) when i == path_length do
    dna_string
  end

  def iterate_path(i, path_length, path, dna_string) do
    for_change = String.replace(Enum.at(Enum.at(path, i), 1), "'", "")
    dna_string = dna_string <> String.at(for_change, String.length(for_change) - 1)
    dna_string = iterate_path(i + 1, path_length, path, dna_string)
  end

  def create_string_from_path(path) do
    dna_string = String.replace(Enum.at(Enum.at(path, 0), 0), "'", "")
    dna_string = iterate_path(0, Kernel.length(path), path, dna_string)
    dna_string
  end

  def iterate_incoming([], in_list, v_node, index) do
    in_list
  end

  def iterate_incoming([head|tail], in_list, v_node, index) do
    if Enum.member?(elem(head, 1), v_node) do
      in_list = List.insert_at(in_list, index, elem(head, 0))
      in_list = iterate_incoming(tail, in_list, v_node, index + 1)
    else
      in_list = iterate_incoming(tail, in_list, v_node, index)
    end
  end

  def incoming(g_graph, v_node) do
    in_list = []
    index = 0
    new_graph = Map.to_list(g_graph)

    in_list = iterate_incoming(new_graph, in_list, v_node, index)
  end

  def outgoing(g_graph, v_node) do
    Map.get(g_graph, v_node)
  end

  def bypass(g_graph, u, v, w) do
    g_p = g_graph
    changed_item_u = List.delete(Map.get(g_p, u), v)
    g_p = Map.put(g_p, u, changed_item_u)
    changed_item_v = List.delete(Map.get(g_p, v), w)
    g_p = Map.put(g_p, v, changed_item_v)
    changed_u = List.insert_at(Map.get(g_p, u), Kernel.length(Map.get(g_p, u)), v <> "'")
    g_p = Map.put(g_p, u, changed_u)
    g_p = Map.put_new(g_p, v <> "'", [w])
    g_p
  end

  def iterate_array([], visited, v_node, g_graph) do
    visited
  end

  def iterate_array([head|tail], visited, v_node, g_graph) do
    if Enum.member?(Map.keys(visited), head) == false do
      visited = dfs(g_graph, head, visited)
    else
      visited = iterate_array(tail, visited, v_node, g_graph)
    end
  end


  def dfs(g_graph, v_node, visited) do
    visited = Map.put(visited, v_node, true)
    new_graph = Map.get(g_graph, v_node)

    visited = iterate_array(new_graph, visited, v_node, g_graph)
  end

  def iterate_v([], visited) do
    true
  end

  def iterate_v([head|tail], visited) do
    if Enum.member?(Map.keys(visited), head) == false do
      false
    else
      iterate_v(tail, visited)
    end
  end

  def is_connected(g_graph) do
    visited = %{}

    visited = dfs(g_graph, Enum.at(Map.keys(g_graph), 0), visited)

    iterate_v(Map.keys(g_graph), visited)
  end

  def iterate_w([], node, g_p_map, v_p, all_graphs) do
    all_graphs
  end

  def iterate_w([head|tail], node, g_p_map, v_p, all_graphs) do
    if v_p != head do
      new_graph = bypass(g_p_map, node, v_p, head)
      if is_connected(new_graph) == true do
        all_graphs = List.insert_at(all_graphs, Kernel.length(all_graphs), new_graph)
        all_graphs = iterate_w(tail, node, g_p_map, v_p, all_graphs)
      else
        all_graphs = iterate_w(tail, node, g_p_map, v_p, all_graphs)
      end
    else
      all_graphs = iterate_w(tail, node, g_p_map, v_p, all_graphs)
    end
  end

  def iterate_u([], outgoing_list, g_p_map, v_p, all_graphs) do
    all_graphs
  end

  def iterate_u([head|tail], outgoing_list, g_p_map, v_p, all_graphs) do
    all_graphs = iterate_w(outgoing_list, head, g_p_map, v_p, all_graphs)
    all_graphs = iterate_u(tail, outgoing_list, g_p_map, v_p, all_graphs)
  end

  def iterate_k([], g_p_map, cycles, all_degrees) do
    cycles
  end

  def iterate_k([head|tail], g_p_map, cycles, all_degrees) do
    cycle = isolated_cycle(g_p_map, head, all_degrees)
    if cycle != None do
      path = create_string_from_path(cycle)
      if Enum.member?(cycles, path) == false do
        cycles = List.insert_at(cycles, Kernel.length(cycles), path)
        cycles = iterate_k(tail, g_p_map, cycles, all_degrees)
      else
        cycles = iterate_k(tail, g_p_map, cycles, all_degrees)
      end
    else
      cycles = iterate_k(tail, g_p_map, cycles, all_degrees)
    end
  end

  def iterate_again(in_degree, [head|tail], g_graph, v_p, all_degrees) when in_degree > 1 do
    head
  end

  def iterate_again(in_degree, [head|tail], g_graph, v_p, all_degrees) do
    v_p = iterate_degree(tail, g_graph, v_p, all_degrees)
  end

  def iterate_degree([], g_graph, v_p, all_degrees) do
    v_p
  end

  def iterate_degree([head|tail], g_graph, v_p, all_degrees) do
    v_p = iterate_again(elem(Map.get(all_degrees, head), 0), [head|tail], g_graph, v_p, all_degrees)
  end

  def iterate_maps([], cycles, i) do
    cycles
  end

  def iterate_maps([head|tail], cycles, i) do
    g_p = head
    all_graphs = tail
    all_degrees = calculate_degrees(g_p)
    v_p = None
    v_p = iterate_degree(Map.keys(g_p), g_p, v_p, all_degrees)
    if v_p != None do
      incoming_list = incoming(g_p, v_p)
      outgoing_list = outgoing(g_p, v_p)
      all_graphs = iterate_u(incoming_list, outgoing_list, g_p, v_p, all_graphs)
      cycles = iterate_maps(all_graphs, cycles, i + 1)
    else
      cycles = iterate_k(Map.keys(g_p), g_p, cycles, all_degrees)
      cycles = iterate_maps(all_graphs, cycles, i + 1)
    end
  end

  def all_eulerian_cycles(g_graph) do
    all_graphs = [g_graph]
    cycles = []
    i = 1
    cycles = iterate_maps(all_graphs, cycles, i)
  end
end

Euler.main(System.argv)
