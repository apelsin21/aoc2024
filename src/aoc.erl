-module(aoc).

%% API exports
-compile(export_all).

%%====================================================================
%% API functions
%%====================================================================

%% escript Entry point
main() ->
    io:format("1: ~p~n", [day1()]),
    erlang:halt(0).

%%====================================================================
%% Internal functions
%%====================================================================

dist(X, Y) -> abs(X-Y).

qsort([]) -> [];
qsort([Pivot|T]) ->
	qsort([X || X <- T, X < Pivot])
	++ [Pivot] ++
	qsort([X || X <- T, X >= Pivot]).

% Is not a clause but a separate function!
zip(A, B) ->
	zip(A, B, []).

% Gives back the elements reversed
% 1 [ {1,3} | [] ]
% 2 [ {2,3} | [{1,3}] ]
% 3 [ {3,3} | [{2,3}, {0,3}] ]
% 4 [ {3,4} | [{3,3}, {2,3}, {0,3}] ]
% 5 [ {3,5} | [{3,4}, {2,3}, {2,3}, {0,3}] ]
% 6 [ {4,9} | [{3,5}, {3,4}, {2,3}, {2,3}, {0,3}] ]
% After this it hits zip([], _, ^) -> ^
zip([], _, Result) ->
	Result;
zip(_, [], Result) ->
	Result;
zip([LH|LT], [RH|RT], Result) ->
	zip(LT, RT, Result ++ [{LH,RH}]).
%zip([LH|LT], [RH|RT], Result) ->
%	zip(LT, RT, [{LH,RH} | Result]).

reverse(L) -> reverse(L, []).

reverse([], Acc) ->
	Acc;
reverse([H|T], Acc) ->
	reverse(T, [H|Acc]).

sum([H|T]) ->
	H + sum(T);
sum([]) ->
	0.

day1() ->
	Input = [
	{3, 4},
	{4, 3},
	{2, 5},
	{1, 3},
	{3, 9},
	{3, 3}
	],

	Left = qsort([L || {L,_} <- Input]),
	Right = qsort([R || {_,R} <- Input]),
	Zipped = zip(Left, Right),
	%Reversed = reverse(Zipped),
	Distances = [abs(L-R) || {L,R} <- Zipped],

	io:format("Left: ~p~n", [Left]),
	io:format("Right: ~p~n", [Right]),
	io:format("Zip: ~p~n", [Zipped]),
	%io:format("Reversed: ~p~n", [Reversed]),
	io:format("Distances: ~p~n", [Distances]),
	io:format("Sum: ~p~n", [sum(Distances)]).

is_magic_square({NW,NC,NE,W,C,E,SW,SC,SE}, V) ->
	(NW+NC+NE =:= V) % top row
	and (W+C+E =:= V) % middle row
	and (SW+SC+SE =:= V) % bottom row
	and (NW+W+SW =:= V) % left column
	and (NC+C+SC =:= V) % middle column
	and (NE+E+SE =:= V) % right column
	and (NW+C+SE =:= V) % diagonal top left bottom right
	and (NE+C+SW =:= V) % diagonal top right bottom left
	and all_uniq(tuple_to_list({NW,NC,NE,W,C,E,SW,SC,SE})).

uniq(Elem, [H|T]) ->
	case Elem =:= H of
		false -> uniq(Elem, T);
		true -> false
	end;
uniq(_, []) ->
	true.

all_uniq([H|T]) ->
	case uniq(H, T) of
		true -> all_uniq(T);
		false -> false
	end;
all_uniq([]) ->
	true.

% ----------------
% | NW | NC | NE |
% |  W |  C |  E |
% | SW | SC | SE |
% ----------------
magic_squares(L, V) ->
	[{NW,NC,NE,W,C,E,SW,SC,SE} ||
	NW <- L, NC <- L, NE <- L,
	W <- L, C <- L, E <- L,
	SW <- L, SC <- L, SE <- L,
	is_magic_square({NW,NC,NE,W,C,E,SW,SC,SE}, V)
	].

print_square({NW,NC,NE,W,C,E,SW,SC,SE}) ->
	io:format("----------~n"),
	io:format("|~2.. B|~2.. B|~2.. B|~n", [NW,NC,NE]),
	io:format("|~2.. B|~2.. B|~2.. B|~n", [W,C,E]), 
	io:format("|~2.. B|~2.. B|~2.. B|~n", [SW,SC,SE]), 
	io:format("----------~n").

print_squares(Squares) -> lists:foreach(fun(X) -> print_square(X) end, Squares).
