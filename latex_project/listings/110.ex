def iterate_values([], all_degrees), do: all_degrees
def iterate_values([head|tail], all_degrees) do
  all_degrees = Map.put(all_degrees, head, Map.get(all_degrees, head) + 1)
  all_degrees = iterate_values(tail, all_degrees)
end

def iterate_keys([], graph, all_degrees), do: all_degrees
def iterate_keys([head|tail], graph, all_degrees) do
  all_degrees = iterate_values(Map.get(graph, head), all_degrees)
  all_degrees = iterate_keys(tail, graph, all_degrees)
end

def initialize([], all_degrees), do: all_degrees
def initialize([head|tail], all_degrees) do
  all_degrees = Map.put(all_degrees, head, 0)
  all_degrees = initialize(tail, all_degrees)
end

def calculate_in_degree(graph) do
  all_degrees = initialize(Map.keys(graph), %{})
  all_degrees = iterate_keys(Map.keys(graph), graph, all_degrees)
end
