iex(1)>Map.get(%{:a => 1, 2 => :b}, :a)
1
iex(2)>Map.put(%{:a => 1, 2 => :b}, :c, 3)
%{2 => :b, :a => 1, :c => 3}
iex(3)>Map.to_list(%{:a => 1, 2 => :b})
[{2 => :b}, {:a => 1}]
