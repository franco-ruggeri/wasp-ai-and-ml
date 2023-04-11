%%%% Implement the following predicates.

hand(Cards,Hand).

%% Example for pair
% hand(Cards,pair(Rank)) :-
%     select(Rank,Cards,Cards2),
%     member(Rank,Cards2).


better(BetterHand,WorseHand).


%%%% Provided code

:- use_module(library(lists)).

game_outcome(Cards1,Cards2,Outcome) :-
    best_hand(Cards1,Hand1),
    best_hand(Cards2,Hand2),
    outcome(Hand1,Hand2,Outcome).

outcome(Hand1,Hand2,player1) :- better(Hand1,Hand2).
outcome(Hand1,Hand2,player2) :- better(Hand2,Hand1).
outcome(Hand1,Hand2,tie) :- \+better(Hand1,Hand2), \+better(Hand2,Hand1).

best_hand(Cards,Hand) :-
    hand(Cards,Hand),
    \+ (hand(Cards,Hand2), better(Hand2,Hand)).
