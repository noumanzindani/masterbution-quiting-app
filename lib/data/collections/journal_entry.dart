import 'package:isar_community/isar.dart';

import '../enums.dart';

part 'journal_entry.g.dart';

/// A free-text journal entry. In Phase 1 this backs the emergency journal (a
/// place to externalise an urge in the moment); later phases reuse it for daily
/// reflection and gratitude via [JournalKind].
@collection
class JournalEntry {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime timestampUtc;

  /// Local calendar-day index (see [TimeBuckets]) for day-grained grouping.
  @Index()
  late int dateEpochDay;

  @Index()
  @enumerated
  late JournalKind kind;

  late String text;

  /// Optional dominant emotion label captured alongside the entry.
  String? emotion;

  /// Optional 0–10 mood rating.
  short? mood;
}
