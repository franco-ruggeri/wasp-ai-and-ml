%%%% Insert and modify the ProbLog code from Exercise 1 here

% Encode the different cards as follows: card(Player,N,Rank)
% This means that the N-th card drawn by Player is of the given Rank.

% Card values
value(jack,11).
value(queen,12).
value(king,13).
value(ace,14).

% Game probabilities
1/5::cheater(player2).
1/2::coin(heads) :- \+cheater(player2).     % not cheater => probability of head is 0, no need to specify
1/4::card(player1,N,jack); 1/4::card(player1,N,queen); 1/4::card(player1,N,king); 1/4::card(player1,N,ace) :- between(1,4,N).
1/4::card(player2,N,jack); 1/4::card(player2,N,queen); 1/4::card(player2,N,king); 1/4::card(player2,N,ace) :- between(1,4,N), \+cheater(player2).
1/4::card(player2,N,queen); 1/4::card(player2,N,king); 2/4::card(player2,N,ace) :- between(1,4,N), cheater(player2).
coin(tails) :- \+coin(heads).

% Game win rules
winner(player1) :- 
    draw_hand(player1,Hand1), 
    draw_hand(player2,Hand2),
    game_outcome(Hand1, Hand2, player1).
winner(player1) :-
    draw_hand(player1,Hand1), 
    draw_hand(player2,Hand2),
    game_outcome(Hand1, Hand2, tie),
    coin(heads).
winner(player2) :- \+winner(player1).

%%%% Insert Prolog code from Exercise 2

% Rank values
value(jack,11).
value(queen,12).
value(king,13).
value(ace,14).

% High card
% Important: we define highcard as any of the cards, not as the highest card.
% Indeed, we are just interested in finding the best hand, so the lower cards will not impact the result.
% Searching for the highest card would would add a linear complexity (finding max), resulting in a very high
% computation time (in the online editor, even an out of time error).
hand(Cards,highcard(Rank)) :- member(Rank,Cards).

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
    RankValue1 > RankValue2.        % highest rank is always in the first position, easier to implement value()

% Three of a kind
hand(Cards,threeofakind(Rank)) :-
    select(Rank,Cards,CardsMinus1),
    select(Rank,CardsMinus1,CardsMinus2),
    member(Rank,CardsMinus2).

% Straight
% Important: we define straight only a hand containing [ace,king,queen,jack].
% A more general definition would be to have sequential cards, independently of the number of cards.
% However, the following test in test.py does not consider [jack,king,queen] a straight. Thus, the general definition
% would fail the test.
% game_outcome(list2term([jack, king, ace]), list2term([jack, king, queen]), X): [({X: player1}, 1.0)],
hand(Cards,straight) :-
    member(ace,Cards),
    member(king,Cards),
    member(queen,Cards),
    member(jack,Cards).

% Hand values
% Arguments: (hand, category_value, rank_value)
% - category_value (second argument) is useful to compare different hand categories (e.g., one pair vs two pair).
% - rank_value (third argument) is useful to compare same hand category (e.g., one pair) with different ranks.
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
:-use_module(library(apply)).
:-use_module(library(lists)).

% The following predicate will sample a Hand as a list of ranks for the given player.
% It expects that there are probabilistic facts of the form card(Player,N,Rank) as specified above

draw_hand(Player,Hand) :- maplist(card(Player),[1,2,3,4],Hand).

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



%%%% What’s the probability that player2 draws the hand [ace, king, queen, ace].
%%%% Your answer: 0.00625
% This query corresponds to the probability:
% P[card(player2,1,ace), card(player2,2,king), card(player2,3,queen), card(player2,4,ace)]
% Manual calculation yields the same result as ProbLog. ProbLog can calculate it by commenting the following line:
% query(draw_hand(player2,[ace,king,queen,ace])).


%%%% Given that player2 draws the hand [ace, king, queen, ace], and that the coin comes up tails, what is the posterior
%%%% belief that your opponent is cheating?
%%%% Your answer: 2/3 = 0.66666...
%% This query corresponds to the probability: P[cheater | [ace,king,queen,ace], tails].
%% Manual calculation yields the same result as ProbLog. ProbLog can calculate it by commenting the following lines:
% evidence(draw_hand(player2,[ace,king,queen,ace])).
% evidence(coin(tails)).
% query(cheater(player2)).


%%%% What is the prior probability that player 1 wins? Why does this query take so long to answer?
%%%% Your answer: 0.46332703
%% For this query, there are a lot of possibilities to consider, so manual calculation is infeasible.
%% ProbLog can calculate it by commenting the following line:
% query(winner(player1)).

%%%% What is the probability that player 1 wins, given that you know that player 2 is a cheater?
%%%% Your answer: 0.31663513
%% As expected, conditioning on the player 2 cheating makes the probability of winning decrease.
%% For this query, there are a lot of possibilities to consider, so manual calculation is infeasible.
%% ProbLog can calculate it by commenting the following lines:
% evidence(cheater(player2)).
% query(winner(player1)).
