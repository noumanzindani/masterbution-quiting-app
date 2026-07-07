/// Pure habit-streak math over the set of local epoch-days a habit was done.
class HabitStats {
  const HabitStats._();

  /// Length of the consecutive run of done-days ending at [today] — or ending
  /// at yesterday if today isn't done yet, since the day isn't over. Returns 0
  /// if neither today nor yesterday was done.
  static int currentStreak(Set<int> doneDays, int today) {
    int start;
    if (doneDays.contains(today)) {
      start = today;
    } else if (doneDays.contains(today - 1)) {
      start = today - 1;
    } else {
      return 0;
    }
    var streak = 0;
    var d = start;
    while (doneDays.contains(d)) {
      streak++;
      d--;
    }
    return streak;
  }
}
