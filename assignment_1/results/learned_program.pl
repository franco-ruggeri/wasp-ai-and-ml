card(jack,11).
card(queen,12).
card(king,13).
card(ace,14).
0.650647699819742::cheater.
1/4::draw1(jack); 1/4::draw1(queen); 1/4::draw1(king); 1/4::draw1(ace).
1/4::draw2(queen); 1/4::draw2(king); 2/4::draw2(ace) :- cheater.
1/4::draw2(jack); 1/4::draw2(queen); 1/4::draw2(king); 1/4::draw2(ace) :- \+cheater.
1/2::coin(heads) :- \+cheater.
highest(none) :- draw1(Card), draw2(Card).
highest(player1) :- draw1(Card1), draw2(Card2), card(Card1,Value1), card(Card2,Value2), Value1>Value2.
winner :- highest(player1).
winner :- highest(none), coin(heads).
