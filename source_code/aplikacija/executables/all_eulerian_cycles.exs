defmodule Ojler do

  def main(args) do
    #IO.inspect(all_eulerian_cycles(%{"AT" => ["TC"], "TC" => ["CG"], "CG" => ["GA", "GG"], "GA" => ["AT", "AC"], "AC" => ["CG"], "GG" => ["GA"]}))
    content = Enum.at(args, 0)
    #IO.puts content
    edges = String.split(content, ";")
    graph = build_graph(edges, %{})
    #IO.inspect graph
    IO.inspect(all_eulerian_cycles(graph))
  end

  def build_graph([], graph), do: graph
  def build_graph([head|tail], graph) do
    nodes = String.split(head, ":")
    left = Enum.at(nodes, 0)
    right = Enum.at(nodes, 1)
    edges = String.split(right, ",")
    graph = Map.put(graph, left, edges)
    graph = build_graph(tail, graph)
  end

  def iterate1([], g_graph, v_node, in_degree) do
    in_degree
  end

  def iterate1([head|tail], g_graph, v_node, in_degree) do
    if Enum.member?(Map.get(g_graph, head), v_node) == true do
      in_degree = in_degree + 1
      in_degree = iterate1(tail, g_graph, v_node, in_degree)
    else
      in_degree = iterate1(tail, g_graph, v_node, in_degree)
    end
  end

  def degree(g_graph, v_node) do
    out_degree = Kernel.length(Map.get(g_graph, v_node))
    in_degree = 0

    in_degree = iterate1(Map.keys(g_graph), g_graph, v_node, in_degree)

    {in_degree, out_degree}
  end

  def iterate_ij(g_graph, v_node, 1, 1, cycle, index) do
    u = Enum.at(Map.get(g_graph, v_node), 0)
    cycle = List.insert_at(cycle, index, [v_node, u])
    if Enum.at(Enum.at(cycle, 0), 0) == Enum.at(Enum.at(cycle, Kernel.length(cycle) - 1), 1) do
      cycle
    else
      v_node = u
      {in_degree, out_degree} = degree(g_graph, v_node)
      cycle = iterate_ij(g_graph, v_node, in_degree, out_degree, cycle, index + 1)
    end
  end

  def iterate_ij(g_graph, v_node, in_degree, out_degree, cycle, index) do
    None
  end

  def isolated_cycle(g_graph, v_node) do
    cycle = []
    {in_degree, out_degree} = degree(g_graph, v_node)

    cycle = iterate_ij(g_graph, v_node, in_degree, out_degree, cycle, 0)
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
      index = index + 1
      in_list = iterate_incoming(tail, in_list, v_node, index)
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
      #:break
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
  # IO.puts 'G_p'
  # IO.inspect g_p_map
  # IO.puts node
  # IO.puts v_p
  # IO.puts head
  if v_p != head do
    new_graph = bypass(g_p_map, node, v_p, head)
    #IO.puts "Novi graf je"
    #IO.inspect new_graph
    #IO.puts is_connected(new_graph)
    if is_connected(new_graph) == true do
      all_graphs = List.insert_at(all_graphs, Kernel.length(all_graphs), new_graph)
      all_graphs = iterate_w(tail, node, g_p_map, v_p, all_graphs)
    else
      all_graphs = iterate_w(tail, node, g_p_map, v_p, all_graphs)
    end
  else
    all_graphs = iterate_w(tail, node, g_p_map, v_p, all_graphs)

  end

  #all_graphs = iterate_w(tail, node, g_p_map, v_p, all_graphs)

end

def iterate_u([], outgoing_list, g_p_map, v_p, all_graphs) do
  all_graphs
end

def iterate_u([head|tail], outgoing_list, g_p_map, v_p, all_graphs) do
  all_graphs = iterate_w(outgoing_list, head, g_p_map, v_p, all_graphs)
  all_graphs = iterate_u(tail, outgoing_list, g_p_map, v_p, all_graphs)
end

def iterate_k([], g_p_map, cycles) do
  cycles
end

def iterate_k([head|tail], g_p_map, cycles) do
  #IO.puts 'íterate_k'
  # IO.inspect(g_p_map)
  # IO.puts head
  cycle = isolated_cycle(g_p_map, head)
  #IO.puts 'Cycle je'
  #IO.inspect(cycle)
  if cycle != None do
    path = create_string_from_path(cycle)
    #IO.puts 'Path je'
    #IO.puts path
    if Enum.member?(cycles, path) == false do
      #IO.puts 'Path nije u cycles, dodaj ga'
      cycles = List.insert_at(cycles, Kernel.length(cycles), path)
      cycles = iterate_k(tail, g_p_map, cycles)
    else
      cycles = iterate_k(tail, g_p_map, cycles)
    end
  else
    cycles = iterate_k(tail, g_p_map, cycles)
  end
end

def iterate_again(in_degree, [head|tail], g_graph, v_p) when in_degree > 1 do
  head
end

def iterate_again(in_degree, [head|tail], g_graph, v_p) do
  v_p = iterate_degree(tail, g_graph, v_p)
end

def iterate_degree([], g_graph, v_p) do
  v_p
end

def iterate_degree([head|tail], g_graph, v_p) do
  {in_degree, out_degree} = degree(g_graph, head)

  v_p = iterate_again(in_degree, [head|tail], g_graph, v_p)
end

def iterate_maps([], cycles, i) do
  cycles
end

def iterate_maps([head|tail], cycles, i) do
  g_p = head
  #IO.puts i
  #IO.inspect head
  #IO.puts 'Duzina all_graphs je'
  #IO.puts Kernel.length([head|tail])
  all_graphs = tail
  v_p = None
  v_p = iterate_degree(Map.keys(g_p), g_p, v_p)
  #IO.puts v_p
  if v_p != None do
    incoming_list = incoming(g_p, v_p)
    outgoing_list = outgoing(g_p, v_p)
    # IO.puts 'CAo cao'
    # IO.puts v_p
    # IO.inspect incoming_list
    # IO.inspect outgoing_list
    all_graphs = iterate_u(incoming_list, outgoing_list, g_p, v_p, all_graphs)
    cycles = iterate_maps(all_graphs, cycles, i + 1)
  else
    cycles = iterate_k(Map.keys(g_p), g_p, cycles)
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

Ojler.main(System.argv)
