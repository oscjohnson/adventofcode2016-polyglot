% Answers: 19449262, 119
outside([A, B | _], X) :-
	(X < A) ; (B < X).

strings_to_lists([], Old, Return) :-
	Return = Old.

strings_to_lists(Strs, Old, Return) :-
	[H | Rest] = Strs,
	string_to_list(H, L),
	append(Old, [L], New),
	strings_to_lists(Rest, New, Return).

string_to_list(Str, L) :-
	split_string(Str, "-", " ", L1),
	[A,B | _] = L1,
	atom_number(A,X),
	atom_number(B,Y),
	L = [X,Y].

iterate(I, [], _, _) :- format('~w, ', [I]).

iterate(I, [H | Rest], All, Results) :-
	(I >= 4294967295) ->
		iterate(I, [], All, Results)
	;
		outside(H, I) ->
			(all_valid(I, All) ->
				iterate(I, [], All, [])
			;
				Y is I + 1,
				iterate(Y, Rest, All, [])
			)
		;
			[_, B] = H,
			Y is B + 1,
			iterate(Y, All, All, Results).


iterate2(_, [], _, Results) :- length(Results, X), format('~w ~n', [X]).

iterate2(I, [H | Rest], All, Results) :-
	(I >= 4294967295) ->
		iterate2(I, [], All, Results)
	;
		outside(H, I) ->
			valid_and_add(I, All, Results, New_results),
			Y is I + 1,
			iterate2(Y, Rest, All, New_results)
		;
			[_, B] = H,
			Y is B + 1,
			iterate2(Y, All, All, Results).

read_input(Filename, S) :-
	open(Filename, read, Stream),
	read_string(Stream, _, S),
	close(Stream).

process_steam(end_of_file, _) :- !.

process_steam(Char, Stream) :-
	write(Char),
	get_char(Stream, Char2),
	process_steam(Char2, Stream).

all_valid(_, []) :- true.

all_valid(I, Ranges) :-
	[Range|Rest] = Ranges,
	outside(Range, I),
	all_valid(I, Rest).

valid_and_add(I, Ranges, Old, New) :-
	all_valid(I, Ranges) ->
		append(Old, [I], New)
	;
		New = Old.

get_ranges(F, Ranges) :-
	read_input(F, S),
	split_string(S, "\n", " ", L),
	strings_to_lists(L, [], Ranges_unsorted),
	sort(Ranges_unsorted, Ranges).

part1() :-
	get_ranges('input.txt', Inputs),
	iterate(0, Inputs, Inputs, _).

part2() :-
	get_ranges('input.txt', Inputs),
	iterate2(0, Inputs, Inputs, _).

main() :-
	part1(),
	part2().
