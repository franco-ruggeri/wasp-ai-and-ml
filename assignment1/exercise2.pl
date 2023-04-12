%%%% Implement the following predicates.

:- use_module(library(apply)).
:- use_module(library(lists)).

% Rank values
value(jack,11).
value(queen,12).
value(king,13).
value(ace,14).

% High card
hand(Cards,highcard(Rank)) :-
    maplist(value,Cards,CardValues),
    max_member(RankValue,CardValues),
    value(Rank,RankValue).

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
hand(Cards,straight) :-             % recursively check from max to min
    maplist(value,Cards,CardValues),

    % Find max
    max_member(MaxRankValue1,CardValues),

    % Remove max
    value(MaxRank,MaxRankValue1),
    select(MaxRank,Cards,CardsMinusMax),
    select(MaxRankValue1,CardValues,CardValuesMinusMax),

    % Check that the max of the remaining elements is max+1
    max_member(MaxRankValue2,CardValuesMinusMax),
    MaxRankValue2Plus1 is MaxRankValue2+1,
    MaxRankValue1 = MaxRankValue2Plus1,

    % Recursive case: check remaining elements
    hand(CardsMinusMax,straight).
hand(Cards,straight) :- length(Cards,Length), Length = 1.   % terminal case: a list of 1 card is always a straight

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

% Compare same hand category but different rank
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






