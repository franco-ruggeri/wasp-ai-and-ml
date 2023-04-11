%%%% Insert and modify the ProbLog code from Exercise 1 here

% Encode the different cards as follows: card(Player,N,Rank)
% This means that the N-th card drawn by Player is of the given Rank.


%%%% Insert Prolog code from Exercise 2

hand(Cards,Hand).
better(BetterHand,WorseHand).

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
%%%% Your answer : 



%%%%  Given that player2 draws the hand [ace, king, queen, ace], and that the coin comes up tails, what is the posterior belief that your opponent is cheating?
%%%% Your answer : 



%%%%  What is the prior probability that player 1 wins?1 Why does this query take so long to answer? What is the probability that player 1 wins, given that you know that player 2 is a cheater?
%%%% Your answer : 
