import 'package:isar_community/isar.dart';

import '../collections/habit_definition.dart';
import '../collections/habit_tick.dart';
import '../enums.dart';

/// Habit definitions + their daily completion ticks. A tick's *presence* for a
/// (habitId, day) means done; toggling off deletes it.
class HabitRepo {
  HabitRepo(this._isar);

  final Isar _isar;

  IsarCollection<HabitDefinition> get _defs => _isar.habitDefinitions;
  IsarCollection<HabitTick> get _ticks => _isar.habitTicks;

  Future<List<HabitDefinition>> activeHabits() =>
      _defs.filter().activeEqualTo(true).sortBySortOrder().findAll();

  Future<int> addHabit({
    required HabitType type,
    required String title,
    required int createdEpochDay,
  }) async {
    final count = await _defs.count();
    final habit = HabitDefinition()
      ..type = type
      ..title = title
      ..active = true
      ..createdEpochDay = createdEpochDay
      ..sortOrder = count;
    return _isar.writeTxn(() => _defs.put(habit));
  }

  Future<void> archive(int habitId) async {
    final habit = await _defs.get(habitId);
    if (habit == null) return;
    habit.active = false;
    await _isar.writeTxn(() => _defs.put(habit));
  }

  /// Toggle today's completion for a habit.
  Future<void> toggle(int habitId, int day) async {
    await _isar.writeTxn(() async {
      final existing = await _ticks
          .filter()
          .habitIdEqualTo(habitId)
          .dateEpochDayEqualTo(day)
          .findFirst();
      if (existing != null) {
        await _ticks.delete(existing.id);
      } else {
        await _ticks.put(HabitTick()
          ..habitId = habitId
          ..dateEpochDay = day);
      }
    });
  }

  /// The set of habit ids ticked on [day] (for rendering today's checkboxes).
  Future<Set<int>> doneHabitIdsOn(int day) async {
    final ticks = await _ticks.filter().dateEpochDayEqualTo(day).findAll();
    return ticks.map((t) => t.habitId).toSet();
  }

  /// Every day a habit was completed (for streaks / week strip).
  Future<Set<int>> doneDays(int habitId) async {
    final ticks = await _ticks.filter().habitIdEqualTo(habitId).findAll();
    return ticks.map((t) => t.dateEpochDay).toSet();
  }
}
