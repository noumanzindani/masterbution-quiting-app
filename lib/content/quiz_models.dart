/// One multiple-choice question with the correct option index and an
/// explanation shown after answering.
class QuizQuestion {
  const QuizQuestion({
    required this.prompt,
    required this.options,
    required this.correctIndex,
    this.explanation = '',
  });

  final String prompt;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  factory QuizQuestion.fromJson(Map<String, dynamic> j) => QuizQuestion(
        prompt: j['prompt'] as String? ?? '',
        options:
            (j['options'] as List?)?.map((e) => e.toString()).toList() ??
                const [],
        correctIndex: (j['correctIndex'] as num?)?.toInt() ?? 0,
        explanation: j['explanation'] as String? ?? '',
      );
}

/// A short knowledge-check quiz tied to an academy category.
class Quiz {
  const Quiz({
    required this.id,
    required this.title,
    required this.category,
    required this.questions,
  });

  final String id;
  final String title;
  final String category;
  final List<QuizQuestion> questions;

  factory Quiz.fromJson(Map<String, dynamic> j) => Quiz(
        id: j['id'] as String,
        title: j['title'] as String? ?? '',
        category: j['category'] as String? ?? 'general',
        questions: (j['questions'] as List?)
                ?.map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
      );
}
