iex(1)>mapa = %{a => :jedan}
%{a => :jedan}
iex(2)>mapa[a]
:jedan
iex(3)>%{^a => :jedan} = %{1 => :jedan, 2 => :dva, 3 => :tri}
%{1 => :jedan, 2 => :dva, 3 => :tri}
