%%%% The Problog program implementing the Bayesian network.

% Card values
value(jack,11).
value(queen,12).
value(king,13).
value(ace,14).

% Cheater
1/5::cheater.
% t(_)::cheater.      % to learn the probability, replace the previous line with this one

% Draw1
1/4::draw1(jack); 1/4::draw1(queen); 1/4::draw1(king); 1/4::draw1(ace).

% Draw2
1/4::draw2(queen); 1/4::draw2(king); 2/4::draw2(ace) :- cheater.
1/4::draw2(jack); 1/4::draw2(queen); 1/4::draw2(king); 1/4::draw2(ace) :- \+cheater.

% Coin
1/2::coin(heads) :- \+cheater.

% Highest
highest(none) :- draw1(Card), draw2(Card).          % players have the same card
highest(player1) :-
    draw1(Card1),
    draw2(Card2),
    value(Card1,Value1),
    value(Card2,Value2),
    Value1 > Value2.                                % player 1 has the highest card
highest(player2) :- \+highest(player1), \+highest(none).

% Winner
winner :- highest(player1).
winner :- highest(none), coin(heads).

%%%% Is Draw1 marginally independent of Coin ? ( Yes / No)
%%%% Your answer : Yes. All paths from Draw1 to Coin are blocked by head-to-head structures with no evidence.

%%%% Is Draw1 marginally independent of Coin given Winner ? ( Yes / No)
%%%% Your answer : No. The path Draw1->Highest->Winner->Coin has a head-to-head structure with evidence in Winner.

%%%% Given the observations in Table 1, learn the probability that player 2 is a cheater (keep the other
%%%% parameters fixed). Use the learning tab from the online editor to do this. What is the final probability?
%%%% Your answer : 0.6506477

