import 'package:isar_community/isar.dart';

part 'habit_tick.g.dart';

/// A single "did this habit today" record. The *presence* of a tick for a
/// (habitId, dateEpochDay) pair means done; un-ticking deletes it. Both columns
/// are indexed for fast per-habit and per-day lookups.
@collection
class HabitTick {
  Id id = Isar.autoIncrement;

  @Index()
  late int habitId;

  @Index()
  late int dateEpochDay;
}
