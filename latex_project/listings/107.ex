def iterate_values([], g_graph, v_node, in_degree) do
  in_degree
end

def iterate_values([head|tail], g_graph, v_node, in_degree) do
  if Enum.member?(Map.get(g_graph, head), v_node) == true do
    in_degree = iterate_values(tail, g_graph, v_node, in_degree + 1)
  else
    in_degree = iterate_values(tail, g_graph, v_node, in_degree)
  end
end

def degree(g_graph, v_node) do
  out_degree = Kernel.length(Map.get(g_graph, v_node))
  in_degree = iterate_values(Map.keys(g_graph), g_graph, v_node, 0)
  {in_degree, out_degree}
end
