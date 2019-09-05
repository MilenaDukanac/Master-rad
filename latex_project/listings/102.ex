def jellyfish_algorithm(z_table, alpha) do
  n = Kernel.length(z_table)
  size_of_H = Kernel.round(Float.ceil(n/alpha))
  h_table = build_h_table(%{}, size_of_H)
  count_table = build_count_table(%{}, size_of_H)
  {h_table, count_table} = calculate(h_table, count_table, z_table, size_of_H)
end
