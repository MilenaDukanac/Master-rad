def build_h_table(h_table_empty, 0), do: h_table_empty
def build_h_table(h_table_empty, size_of_H) do
    h_table_empty = Map.put(h_table_empty, size_of_H - 1, "")
    build_h_table(h_table_empty, size_of_H - 1)
end

def build_count_table(count_table_empty, 0), do: count_table_empty
def build_count_table(count_table_empty, size_of_count_table) do
    count_table_empty = Map.put(count_table_empty, size_of_count_table - 1, 0)
    build_count_table(count_table_empty, size_of_count_table - 1)
end
