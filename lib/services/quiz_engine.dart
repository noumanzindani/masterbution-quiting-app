import '../content/quiz_models.dart';

/// Result of scoring a quiz attempt.
class QuizResult {
  const QuizResult({required this.correct, required this.total});
  final int correct;
  final int total;

  /// Pass at 70%+ — a low-stakes "you've got the idea" bar, not an exam.
  bool get passed => total > 0 && correct / total >= 0.7;
}

/// Pure quiz scoring. [answers] maps question index → chosen option index;
/// a missing entry counts as unanswered (wrong).
class QuizEngine {
  const QuizEngine._();

  static bool isCorrect(QuizQuestion q, int? chosen) => chosen == q.correctIndex;

  static QuizResult score(Quiz quiz, Map<int, int> answers) {
    var correct = 0;
    for (var i = 0; i < quiz.questions.length; i++) {
      if (isCorrect(quiz.questions[i], answers[i])) correct++;
    }
    return QuizResult(correct: correct, total: quiz.questions.length);
  }
}
