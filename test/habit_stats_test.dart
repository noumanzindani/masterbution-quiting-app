import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/services/habit_stats.dart';

void main() {
  const today = 100;

  group('habit currentStreak', () {
    test('done today only is a streak of 1', () {
      expect(HabitStats.currentStreak({today}, today), 1);
    });

    test('consecutive days ending today', () {
      expect(HabitStats.currentStreak({today, today - 1, today - 2}, today), 3);
    });

    test('today not done yet but yesterday-back is still the current streak', () {
      expect(HabitStats.currentStreak({today - 1, today - 2}, today), 2);
    });

    test('a gap breaks the streak to zero', () {
      expect(HabitStats.currentStreak({today - 3, today - 4}, today), 0);
    });

    test('no ticks is zero', () {
      expect(HabitStats.currentStreak(const {}, today), 0);
    });
  });
}
