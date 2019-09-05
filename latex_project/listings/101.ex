def pattern_to_number(_pattern, begin_string, index, length_of_pattern) when index == length_of_pattern do
  String.to_integer(begin_string, 10)
end

def pattern_to_number(pattern, begin_string, index, length_of_pattern) do
  begin_string = begin_string <> symbol_to_number(String.at(pattern, index))
  pattern_to_number(pattern, begin_string, index + 1, length_of_pattern)
end
