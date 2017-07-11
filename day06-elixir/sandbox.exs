map = %{}
Enum.each [1, 2, 3], fn x ->
  map = Map.put(map, x, x)
end
IO.inspect map


map = %{}
map = Enum.reduce [1, 2, 3], %{}, fn x, acc ->
  Map.put(acc, x, x)
end
IO.inspect map