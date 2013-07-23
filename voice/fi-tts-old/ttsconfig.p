﻿:- op('--', xfy, 500).
version(101).
language(fi).

% before each announcement (beep)
preamble - [].


%% TURNS 
turn('left', ['käänny vasemmalle ']).
turn('left_sh', ['käänny jyrkästi vasemmalle ']).
turn('left_sl', ['käänny loivasti vasemmalle ']).
turn('right', ['käänny oikealle ']).
turn('right_sh', ['käänny jyrkästi oikealle ']).
turn('right_sl', ['käänny loivasti oikealle ']).
turn('left_keep', ['pidä vasen ']).
turn('right_keep', ['pidä oikea ']).
bear_left -- ['pidä vasen '].
bear_right -- ['pidä oikea '].

prepturn('left', ['kääntymään vasemmalle ']).
prepturn('left_sh', ['kääntymään jyrkästi vasemmalle ']).
prepturn('left_sl', ['kääntymään loivasti vasemmalle ']).
prepturn('right', ['kääntymään oikealle ']).
prepturn('right_sh', ['kääntymään jyrkästi oikealle ']).
prepturn('right_sl', ['kääntymään loivasti oikealle ']).
prepturn('right_keep', ['pidä oikea ']).
prepturn('left_keep', ['pidä vasen ']).

prepare_turn(Turn, Dist) -- ['Valmistaudu ', D, ' päästä ', M] :- distance(Dist, metrin) -- D, prepturn(Turn, M).
turn(Turn, Dist) -- [D, ' päästä ', M] :- distance(Dist, metrin) -- D, turn(Turn, M).
turn(Turn) -- ['Nyt, ', M] :- turn(Turn, M).

prepare_make_ut(Dist) -- ['Valmistaudu kääntymään takaisin ', D, ' päästä'] :- distance(Dist, metrin) -- D.
make_ut(Dist) -- ['Käänny takaisin ', D, ' päästä '] :- distance(Dist, metrin) -- D.
make_ut -- ['Nyt, käänny takaisin '].
make_ut_wp -- ['Nyt, käänny takaisin '].

prepare_roundabout(Dist) -- ['Valmistaudu ajamaan liikenneympyrään ', D, ' päästä'] :- distance(Dist, metrin) -- D.
roundabout(Dist, _Angle, Exit) -- ['Aja liikenneympyrään ', D, ' päästä ja ota ', E, ' liittymä'] :- distance(Dist, metrin) -- D, nth(Exit, E).
roundabout(_Angle, Exit) -- ['Nyt, ota ', E, ' liittymä'] :- nth(Exit, E).

go_ahead -- ['Jatka suoraan '].
go_ahead(Dist) -- ['Jatka suoraan ', D]:- distance(Dist, metria) -- D.

then -- ['sitten '].
and_arrive_destination -- ['ja olet perillä '].
reached_destination -- ['olet perillä '].
and_arrive_intermediate -- ['and arrive at your via point '].
reached_intermediate -- ['you have reached your via point'].

route_new_calc(Dist) -- ['Matkan pituus on ', D] :- distance(Dist, metria) -- D.
route_recalc(Dist) -- ['Reitin uudelleenlaskenta ', D] :- distance(Dist, metria) -- D.	

location_lost -- ['g p s signal lost '].

on_street -- ['on ', X] :- next_street(X).
off_route -- ['you have deviated from the route '].
attention -- ['attention '].
speed_alarm -- ['you are exceeding the speed limit '].


%% 
nth(1, 'ensimmäinen ').
nth(2, 'toinen ').
nth(3, 'kolmas ').
nth(4, 'neljäs ').
nth(5, 'viides ').
nth(6, 'kuudes ').
nth(7, 'seitsemäs ').
nth(8, 'kahdeksas ').
nth(9, 'yhdeksäs ').
nth(10, 'kymmenes ').
nth(11, 'yhdestoista ').
nth(12, 'kahdestoista ').
nth(13, 'kolmastoista ').
nth(14, 'neljästoista ').
nth(15, 'viidestoista ').
nth(16, 'kuudestoista ').
nth(17, 'seitsemästoista ').


%%% distance measure
distance(Dist, metrin) -- [ X, ' metrin'] :- Dist < 100, D is round(Dist/10.0)*10, num_atom(D, X).
distance(Dist, metria) -- [ X, ' metriä'] :- Dist < 100, D is round(Dist/10.0)*10, num_atom(D, X).
distance(Dist, metrin) -- [ X, ' metrin'] :- Dist < 1000, D is round(2*Dist/100.0)*50, num_atom(D, X).
distance(Dist, metria) -- [ X, ' metriä'] :- Dist < 1000, D is round(2*Dist/100.0)*50, num_atom(D, X).
distance(Dist, metrin) -- ['noin 1 kilometrin '] :- Dist < 1500.
distance(Dist, metria) -- ['noin 1 kilometri '] :- Dist < 1500.
distance(Dist, metrin) -- ['noin', X, ' kilometerin '] :- Dist < 10000, D is round(Dist/1000.0), num_atom(D, X).
distance(Dist, metria) -- ['noin', X, ' kilometriä '] :- Dist < 10000, D is round(Dist/1000.0), num_atom(D, X).
distance(Dist, metrin) -- [ X, ' kilometerin '] :- D is round(Dist/1000.0), num_atom(D, X).
distance(Dist, metria) -- [ X, ' kilometriä '] :- D is round(Dist/1000.0), num_atom(D, X).
% Note: do not put space after word "noin" because for some reason the SVOX Finnish Satu Voice announces the number wrong if there is a space


%% resolve command main method
%% if you are familar with Prolog you can input specific to the whole mechanism,
%% by adding exception cases.
flatten(X, Y) :- flatten(X, [], Y), !.
flatten([], Acc, Acc).
flatten([X|Y], Acc, Res):- flatten(Y, Acc, R), flatten(X, R, Res).
flatten(X, Acc, [X|Acc]).

resolve(X, Y) :- resolve_impl(X,Z), flatten(Z, Y).
resolve_impl([],[]).
resolve_impl([X|Rest], List) :- resolve_impl(Rest, Tail), ((X -- L) -> append(L, Tail, List); List = Tail).


% handling alternatives
[X|_Y] -- T :- (X -- T),!.
[_X|Y] -- T :- (Y -- T).