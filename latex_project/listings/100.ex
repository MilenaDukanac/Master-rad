def symbol_to_number(c) do
  map = %{"A" => "00", "T" => "01", "C" => "10", "G" => "11"}
  map[c]
end
