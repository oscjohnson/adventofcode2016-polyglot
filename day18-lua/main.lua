function is_trap(str)
	traps = {"^^.", ".^^", "^..", "..^"}
	for i = 1, #traps do
		if str == traps[i] then
			return true
		end
	end

	return false 
end

function run(first_row, row_count)
	board = {}
	board[1] = first_row
	count = 0

	for r = 2, row_count do
		local prev_row = r == 1 and first_row or board[r-1]
		row = ""
		for i = 1, #prev_row do
		    local c = prev_row:sub(i,i)
		    local left = i == 1 and "." or prev_row:sub(i - 1, i -1)
		    local center = prev_row:sub(i, i)
		    local right = i == #prev_row and "." or prev_row:sub(i + 1, i + 1)

				if is_trap(left..center..right) then
					row = row.."^"
				else
					row = row.."."
				end
		end
		board[r] = row
	end

	for r = 1, row_count do
		local row = board[r]
		for i = 1, #row do
				if row:sub(i, i) == "." then
					count = count + 1
				end
		end
	end

	return count
end

local input = io.open("input.txt", "rb"):read "*a"

print(run(input, 40)..", "..run(input, 400000))

