/// Pure day-unlocking logic for a sequential multi-day program. Days are
/// 1-based; [completed] is the set of completed day numbers.
class ProgramProgress {
  const ProgramProgress._();

  /// A day is unlocked if it's the first day or the previous day is done.
  static bool isUnlocked(int day, Set<int> completed) =>
      day <= 1 || completed.contains(day - 1);

  /// The first not-yet-completed day (capped at [total]).
  static int currentDay(Set<int> completed, int total) {
    for (var d = 1; d <= total; d++) {
      if (!completed.contains(d)) return d;
    }
    return total;
  }

  static bool isComplete(Set<int> completed, int total) {
    for (var d = 1; d <= total; d++) {
      if (!completed.contains(d)) return false;
    }
    return total > 0;
  }
}
