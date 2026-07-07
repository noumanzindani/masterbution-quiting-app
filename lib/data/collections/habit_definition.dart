import 'package:isar_community/isar.dart';

import '../enums.dart';

part 'habit_definition.g.dart';

/// A healthy habit the user chose to track (e.g. exercise, meditation). Daily
/// completion is recorded separately as [HabitTick]s so history is append-only
/// and a habit can be retired ([active] = false) without losing its record.
@collection
class HabitDefinition {
  Id id = Isar.autoIncrement;

  @enumerated
  late HabitType type;

  late String title;

  @Index()
  bool active = true;

  late int createdEpochDay;

  int sortOrder = 0;
}
