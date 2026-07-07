import '../config.dart';
import '../data/collections/habit_definition.dart';
import '../data/enums.dart';
import '../data/time_buckets.dart';
import '../services/habit_stats.dart';

/// Backs the habits screen: today's habits with their done state, current
/// streaks, and the last-7-days strip. Toggling refreshes.
class HabitProvider extends ChangeNotifier {
  HabitProvider() {
    load();
  }

  bool loading = true;
  int today = TimeBuckets.todayEpochDay();

  List<HabitDefinition> habits = const [];
  Set<int> doneToday = {};
  Map<int, int> streaks = {};
  Map<int, Set<int>> doneDaysByHabit = {};

  Future<void> load() async {
    loading = true;
    notifyListeners();

    today = TimeBuckets.todayEpochDay();
    habits = await habitRepo.activeHabits();
    doneToday = await habitRepo.doneHabitIdsOn(today);

    streaks = {};
    doneDaysByHabit = {};
    for (final h in habits) {
      final days = await habitRepo.doneDays(h.id);
      doneDaysByHabit[h.id] = days;
      streaks[h.id] = HabitStats.currentStreak(days, today);
    }

    loading = false;
    notifyListeners();
  }

  Future<void> toggle(int habitId) async {
    await habitRepo.toggle(habitId, today);
    await load();
  }

  Future<void> addHabit(HabitType type, String title) async {
    await habitRepo.addHabit(type: type, title: title, createdEpochDay: today);
    await load();
  }

  Future<void> archive(int habitId) async {
    await habitRepo.archive(habitId);
    await load();
  }
}
