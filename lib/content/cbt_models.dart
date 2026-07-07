import '../data/enums.dart';

/// One step of a CBT worksheet. [type] is `text` (free response), `scale`
/// (0–[max] rating) or `choice` (pick from [options]).
class CbtStep {
  const CbtStep({
    required this.id,
    required this.prompt,
    this.type = 'text',
    this.hint = '',
    this.max = 10,
    this.options = const [],
  });

  final String id;
  final String prompt;
  final String type;
  final String hint;
  final int max;
  final List<String> options;

  factory CbtStep.fromJson(Map<String, dynamic> j) => CbtStep(
        id: j['id'] as String,
        prompt: j['prompt'] as String? ?? '',
        type: j['type'] as String? ?? 'text',
        hint: j['hint'] as String? ?? '',
        max: (j['max'] as num?)?.toInt() ?? 10,
        options: (j['options'] as List?)?.map((e) => e.toString()).toList() ??
            const [],
      );
}

/// A bundled CBT worksheet template. The user's answers are saved as a
/// [CbtEntry]; the template itself is content, so new worksheets are pure JSON.
class CbtWorksheet {
  const CbtWorksheet({
    required this.id,
    required this.title,
    required this.intro,
    required this.exercise,
    required this.steps,
  });

  final String id;
  final String title;
  final String intro;
  final CbtExercise exercise;
  final List<CbtStep> steps;

  factory CbtWorksheet.fromJson(Map<String, dynamic> j) => CbtWorksheet(
        id: j['id'] as String,
        title: j['title'] as String? ?? '',
        intro: j['intro'] as String? ?? '',
        exercise: _exerciseFrom(j['exercise'] as String?),
        steps: (j['steps'] as List?)
                ?.map((e) => CbtStep.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
      );

  static CbtExercise _exerciseFrom(String? name) {
    for (final e in CbtExercise.values) {
      if (e.name == name) return e;
    }
    return CbtExercise.automaticThought;
  }
}
