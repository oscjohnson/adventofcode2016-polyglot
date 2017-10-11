
fun readlist (infile : string) = let
  val ins = TextIO.openIn infile
  fun loop ins =
   case TextIO.inputLine ins of
      SOME line => line :: loop ins
    | NONE      => []
in
  loop ins before TextIO.closeIn ins
end


fun find_index(item, xs) =
  let
    fun index'(m, nil) = NONE
      | index'(m, x::xr) = if x = item then SOME m else index'(m + 1, xr)
  in
    index'(0, xs)
  end

fun swap_position(s, i: int, j: int) =
	let
		val a = String.sub(s, i)
		val b = String.sub(s, j)
		val foo = fn x => if x = a then b
											else if x = b then a
										else x
	in
		String.map foo s
	end


fun swap_letter(s, a_: string, b_: string) =
	let
		val a = String.sub(a_, 0)
		val b = String.sub(b_, 0)
		val foo = fn x => if x = a then b
											else if x = b then a
										else x
	in
		String.map foo s
	end


fun reverse(s, start: int, stop: int) =
	let
		val string_size = size(s)
		val left = substring(s, 0, start)
		val middle = substring(s, start, stop - start + 1)
		val right = substring(s, stop + 1, size(s) - stop - 1)
		val middle_rev = (implode (rev (explode middle)))
	in
		left ^ middle_rev ^ right
	end

fun rotate_right(s: string, 0) = s
  | rotate_right(s: string, times: int) =
	let
		val chars = (explode s)
		val tail = implode(List.take(chars, size(s) - 1))
		val last = String.str(List.last chars)
	in
		rotate_right(last ^ tail, times -1)
	end


fun rotate_left(s: string, 0) = s
  | rotate_left(s: string, times: int) =
	let
		val chars = (explode s)
		val tail = implode(List.drop(chars, 1))
		val first = String.str(List.hd chars)
	in
		rotate_left(tail ^ first, times - 1)
	end

fun rotate_complex(s:string, letter: char) =
	let
		val index = case find_index(letter, explode s) of
		  SOME(x) => x
		| NONE => 0
		val s1 = rotate_right(s, 1)
		val s2 = rotate_right(s1, index)
		val s3 = if index >= 4 then rotate_right(s2, 1) else s2

	in
		s3
	end

fun rotate_complex_reversed(s:string, letter: char) =
	let
		val index = case find_index(letter, explode s) of
		  SOME(x) => x
		| NONE => 0
		val s1 = rotate_left(s, 1)
		val translations = [7, 0, 4, 1, 5, 2, 6, 3]
		val s2 = rotate_left(s1, List.nth(translations, index))
		val s3 = if (index mod 2 = 0) then rotate_left(s2, 1) else s2
	in
		s3
	end


fun move(s: string, from: int, to: int) =
	let
		val chars = explode s
		val c = String.str(String.sub(s, from))
		val s1 = substring(s, 0, from) ^ substring(s, from + 1, size(s) - from - 1)
		val left = substring(s1, 0, to)
		val right = substring(s1, to, size(s1) - to )
	in
		left ^ c ^ right
	end

fun get_int(parts, n) =
	let
		val str = if (length(parts) < n) then "a" else List.nth(parts, n)
		val opt = Int.fromString(str)
		val value = if isSome(opt) then valOf(opt) else ~1
	in
		value
	end

fun run_line(input:string, []) = input
|   run_line(input:string, lines) =
	let
		val line = hd lines
		val parts = String.tokens (fn x => x = #" ") line
		val instruction =  List.nth(parts, 0) ^ " " ^ List.nth(parts, 1)

		val new_input = case instruction of
			"swap position" => swap_position(input, get_int(parts, 2), get_int(parts, 5))
			| "swap letter" => swap_letter(input, List.nth(parts, 2), List.nth(parts, 5))
			| "reverse positions" => reverse(input, get_int(parts, 2), get_int(parts, 4))
			| "rotate left" => rotate_left(input, get_int(parts, 2))
			| "rotate right" => rotate_right(input, get_int(parts, 2))
			| "rotate based" => rotate_complex(input, String.sub(List.nth(parts, 6), 0))
			| "move position" => move(input, get_int(parts, 2), get_int(parts, 5))
		;
	in
		run_line(new_input, tl lines)
	end

fun run_line_reversed(input:string, []) = input
|   run_line_reversed(input:string, lines) =
	let
		val line = hd lines
		val parts = String.tokens (fn x => x = #" ") line
		val instruction =  List.nth(parts, 0) ^ " " ^ List.nth(parts, 1)

		val new_input_reversed = case instruction of
			"swap position" => swap_position(input, get_int(parts, 5), get_int(parts, 2))
			| "swap letter" => swap_letter(input, List.nth(parts, 5), List.nth(parts, 2))
			| "reverse positions" => reverse(input, get_int(parts, 2), get_int(parts, 4))
			| "rotate left" => rotate_right(input, get_int(parts, 2))
			| "rotate right" => rotate_left(input, get_int(parts, 2))
			| "rotate based" => rotate_complex_reversed(input, String.sub(List.nth(parts, 6), 0)) (*TODO*)
			| "move position" => move(input, get_int(parts, 5), get_int(parts, 2))
		;
	in
		run_line_reversed(new_input_reversed, tl lines)
	end
	fun main() =
		let
			val lines = readlist("input.txt")
		in
			print(run_line("abcdefgh", lines) ^ ", " ^ run_line_reversed("fbgdceah", rev lines)  ^ "\n")
		end
