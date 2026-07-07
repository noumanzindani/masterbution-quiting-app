import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/content/quiz_models.dart';
import 'package:momentum/services/quiz_engine.dart';

Quiz _quiz() => const Quiz(
      id: 'q',
      title: 'Q',
      category: 'brain',
      questions: [
        QuizQuestion(prompt: 'a', options: ['x', 'y'], correctIndex: 1),
        QuizQuestion(prompt: 'b', options: ['x', 'y'], correctIndex: 0),
        QuizQuestion(prompt: 'c', options: ['x', 'y'], correctIndex: 1),
      ],
    );

void main() {
  group('QuizEngine.score', () {
    test('counts correct answers', () {
      // answers: q0=1 (right), q1=1 (wrong), q2=1 (right) => 2/3
      final r = QuizEngine.score(_quiz(), {0: 1, 1: 1, 2: 1});
      expect(r.correct, 2);
      expect(r.total, 3);
    });

    test('all correct', () {
      final r = QuizEngine.score(_quiz(), {0: 1, 1: 0, 2: 1});
      expect(r.correct, 3);
      expect(r.passed, isTrue);
    });

    test('unanswered questions count as wrong', () {
      final r = QuizEngine.score(_quiz(), {0: 1});
      expect(r.correct, 1);
      expect(r.total, 3);
    });

    test('isCorrect reports per-question correctness', () {
      final quiz = _quiz();
      expect(QuizEngine.isCorrect(quiz.questions[0], 1), isTrue);
      expect(QuizEngine.isCorrect(quiz.questions[0], 0), isFalse);
    });
  });
}
