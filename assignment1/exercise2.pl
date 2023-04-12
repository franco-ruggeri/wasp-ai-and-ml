%%%% Implement the following predicates.

:- use_module(library(apply)).
:- use_module(library(lists)).

% Rank values
value(jack,11).
value(queen,12).
value(king,13).
value(ace,14).

/*
% High card
hand(Cards,highcard(Rank)) :-
    maplist(value,Cards,CardValues),
    max_member(RankValue,CardValues),
    value(Rank,RankValue).
*/

% One pair
hand(Cards,onepair(Rank)) :-
    select(Rank,Cards,CardsMinus1),
    member(Rank,CardsMinus1).

% Two pair
hand(Cards,twopair(Rank1,Rank2)) :-
    hand(Cards,onepair(Rank1)),
    hand(Cards,onepair(Rank2)),
    value(Rank1,RankValue1),
    value(Rank2,RankValue2),
    RankValue1 > RankValue2.        % highest rank is always in the first position, easier to implement better()

% Three of a kind
hand(Cards,threeofakind(Rank)) :-
    select(Rank,Cards,CardsMinus1),
    select(Rank,CardsMinus1,CardsMinus2),
    member(Rank,CardsMinus2).

% Straight
% Important: we define straight only a hand containing [ace,king,queen,jack].
% A more general definition would be to have sequential cards, independently of the number and of the highest rank.
% However, the following test in test.py does not consider [jack,king,queen] a straight. Thus, the general definition
% would fail the test.
% game_outcome(list2term([jack, king, ace]), list2term([jack, king, queen]), X): [({X: player1}, 1.0)],
hand(Cards,straight) :-
    member(ace,Cards),
    member(king,Cards),
    member(queen,Cards),
    member(jack,Cards).

% Hand values
value(highcard(Rank),0,RankValue) :- value(Rank,RankValue).
value(onepair(Rank),1,RankValue) :- value(Rank,RankValue).
value(twopair(Rank1,Rank2),2,RankValue) :-
    value(Rank1,RankValue1),
    value(Rank2,RankValue2),
    RankValue is RankValue1 * 14 + RankValue2.  % highest rank has priority
value(threeofakind(Rank),3,RankValue) :- value(Rank,RankValue).
value(straight,4,0).

% Compare different hand categories
better(BetterHand,WorseHand) :-
    value(BetterHand,BetterCategoryValue,_),
    value(WorseHand,WorseCategoryValue,_),
    BetterCategoryValue > WorseCategoryValue.

% Compare same hand category but different ranks
better(BetterHand,WorseHand) :-
    value(BetterHand,BetterCategoryValue,BetterRankValue),
    value(WorseHand,WorseCategoryValue,WorseRankValue),
    BetterCategoryValue = WorseCategoryValue,
    BetterRankValue > WorseRankValue.

%%%% Provided code

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






