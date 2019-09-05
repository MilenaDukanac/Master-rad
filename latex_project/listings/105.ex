def hashEntry(h_table, z, size) do
  i = rem(pattern_to_number(z, "", 0, String.length(z)), size)
  calculate_i(h_table, z, i, size)
end
