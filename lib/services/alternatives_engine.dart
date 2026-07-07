import '../content/content_models.dart';

/// Pure rule-based "I have N minutes — what could I do instead?" generator.
/// No AI: it filters the bundled activity list by available time and greedily
/// favours a spread of categories so the suggestions don't all feel the same.
class AlternativesEngine {
  const AlternativesEngine._();

  static List<HealthyAlternative> suggest(
    List<HealthyAlternative> all, {
    required int maxMinutes,
    int count = 4,
  }) {
    final fitting = all.where((a) => a.minutes <= maxMinutes).toList()
      ..sort((a, b) {
        // Prefer activities that use more of the available time, then stable
        // by id so results are deterministic (testable, no randomness).
        final byTime = b.minutes.compareTo(a.minutes);
        return byTime != 0 ? byTime : a.id.compareTo(b.id);
      });

    final chosen = <HealthyAlternative>[];
    final usedCategories = <String>{};

    // First pass: at most one per category, to maximise variety.
    for (final a in fitting) {
      if (chosen.length >= count) break;
      if (usedCategories.add(a.category)) chosen.add(a);
    }
    // Second pass: fill any remaining slots with the best-fitting leftovers.
    for (final a in fitting) {
      if (chosen.length >= count) break;
      if (!chosen.contains(a)) chosen.add(a);
    }
    return chosen;
  }
}
