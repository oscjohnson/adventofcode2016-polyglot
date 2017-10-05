-module(day19).
-export([part1/1, main/0]).
-import(ll, [new/0, push/2]).

next(List, Index, Input) ->
	case (array:get(Index, List) > 0) of
		true -> Index;
		false -> next(List, (Index + 1) rem Input, Input )
	end.

calculateNext(Elves, Index, Input) ->
	I = next(Elves, (Index + 1) rem Input, Input),
	ElvesNew = array:set(Index, array:get(Index, Elves) + array:get(I, Elves), Elves),
	ElvesNew2 = array:set(I, 0, ElvesNew),
	{ElvesNew2, next(ElvesNew2, I, Input)}.

calcuate(Elves, Index, Input) ->
	case (next(Elves, (Index + 1) rem Input, Input) == Index) of
		true -> Index;
		false -> 	{N1, I1} = calculateNext(Elves, Index, Input),
			calcuate(N1, I1, Input)
	end.

part1(Input) ->
	Index = 0,
	Elves = array:new([{size, Input}, {fixed, true}, {default, 1}]),
	I1 = calcuate(Elves, Index, Input),
	I1 + 1. % compensate for 0 based index

part2(Input) -> "?".

main() ->
	Input = 3005290,
	io:fwrite("~p\n", [part1(Input)]).