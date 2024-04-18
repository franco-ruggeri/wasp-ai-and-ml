import problog.engine
from problog import get_evaluatable
from problog.engine import DefaultEngine
from problog.program import PrologFile, Term, Var, list2term, Constant

best_hand = Term('best_hand')
game_outcome = Term('game_outcome')
card = Term('card')
draw_hand = Term('draw_hand')
heads = Term('heads')
coin = Term('coin')
draw1 = Term('draw1')

player1 = Term('player1')
player2 = Term('player2')
tie = Term('tie')

highcard = Term('highcard')
threeofakind = Term('threeofakind')
straight = Term('straight')

jack = Term('jack')
queen = Term('queen')
king = Term('king')
ace = Term('ace')

X = Var('X')

test_1 = {
    coin(heads): [({}, 0.4)],
    draw1(jack): [({}, 0.25)],
}

test_2 = {
    best_hand(list2term([jack, king, ace]), X): [({X: highcard(ace)}, 1.0)],
    best_hand(list2term([jack, king, jack, jack]), X): [({X: threeofakind(jack)}, 1.0)],
    best_hand(list2term([queen, ace, king, jack]), X): [({X: straight}, 1.0)],
    game_outcome(list2term([jack, king, ace]), list2term([jack, king, queen]), X): [({X: player1}, 1.0)],
    game_outcome(list2term([jack, king, jack]), list2term([jack, king, king]), X): [({X: player2}, 1.0)],
    game_outcome(list2term([jack, jack, ace]), list2term([jack, king, jack]), X): [({X: tie}, 1.0)],
}

test_3 = {
    card(player1, Constant(1), jack): [({}, 0.25)],
    draw_hand(player1, list2term([ace, king, queen, X])): [
        ({X: jack}, 0.25 ** 4),
        ({X: queen}, 0.25 ** 4),
        ({X: king}, 0.25 ** 4),
        ({X: ace}, 0.25 ** 4)],
}

all_tests = {
    'Exercise 1': ('exercise1.pl', test_1),
    'Exercise 2': ('exercise2.pl', test_2),
    'Exercise 3': ('exercise3.pl', test_3),
}


def test_query(program, query, expected_answers):
    engine = DefaultEngine()
    db = engine.prepare(program)
    try:
        ground = engine.ground(db, query, label='query')
        results = get_evaluatable().create_from(ground).evaluate()
    except problog.engine.UnknownClause as e:
        print(e)
        results = {}

    wrong = False
    for expected_answer, probability in expected_answers:
        substituted_answer = query.apply(expected_answer)
        if substituted_answer not in results:
            print('Expected answer {} not found for query {}.'.format(substituted_answer, query))
            wrong = True
        elif probability - 1e-12 < results[substituted_answer] < probability + 1e-12:
            del results[substituted_answer]
        else:
            print('{} has a probability of {} vs {}.'.format(substituted_answer, results[substituted_answer],
                                                             probability))
            wrong = True
            del results[substituted_answer]
    for answer in results:
        print('Unexpected answer {} present for query {}'.format(answer, query))
        wrong = True
    if not wrong:
        print('Query {} answered correctly.'.format(query))


if __name__ == '__main__':
    for exercise_name in all_tests:
        filename, tests = all_tests[exercise_name]
        print('-' * len(exercise_name))
        print(exercise_name)
        print('-' * len(exercise_name))
        program = PrologFile(filename)
        for query in tests:
            test_query(program, query, tests[query])
        print('-' * len(exercise_name))
