def in_degree([], graph, node, in_degree), do: in_degree
def in_degree([head|tail], graph, node, in_degree) do
  if(Enum.member?(Map.get(graph, head), node) == true) do
    in_degree = in_degree(tail, graph, node, in_degree + 1)
  else
    in_degree = in_degree(tail, graph, node, in_degree)
  end
end
