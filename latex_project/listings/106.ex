def symbol_to_number(c) do
	map = %{"A" => "00", "T" => "01", "C" => "10", "G" => "11"}
	map[c]
end

def pattern_to_number(pattern) do
 	chars = String.graphemes(pattern)
	mapped_chars = Enum.map(chars, fn char -> symbol_to_number(char) end)
	new_pattern = Enum.join(mapped_chars, "")
	String.to_integer(new_pattern, 10)
end
