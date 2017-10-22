
defmodule Day6 do
	def getInput do
		file = './input.txt'
		case File.read(file) do
		  {:ok, body}      -> body # do something with the `body`
		  {:error, reason} -> IO.puts "reason:" <> reason # handle the error caused by `reason`
		end
	end

	def getResult(max: max) do
		contents = Day6.getInput
		lines = String.split(contents, "\n")

		grid = Enum.map(lines, fn(line) -> 
			chars = String.split(line, "", trim: true)
			Enum.map(chars, fn(c) ->
				c
			end)
		end)

		indexes = [0,1,2,3,4,5,6,7]; # another way of doing this (more dynamically)?

		result = Enum.reduce(indexes, "", fn(index, acc) ->
			res = Enum.reduce(grid, %{}, fn(line, acc) ->
				char = Enum.at(line, index)
				Map.update(acc, char, 1, fn(value) -> value + 1 end)
			end)

			correction_method = if (max), do: &Enum.max_by/2, else: &Enum.min_by/2
			nres = correction_method.(res, fn{_, v} -> v end)
			acc <> elem(nres, 0)
		end)
		result
	end 
	def part1 do
		Day6.getResult(max: true)
	end
	def part2 do
		Day6.getResult(max: false)
	end
end

IO.puts Day6.part1 <> ", " <> Day6.part2 # tkspfjcc, xrlmbypn


