import 'package:isar_community/isar.dart';

import '../enums.dart';

part 'cbt_entry.g.dart';

/// A completed CBT worksheet. The worksheet *template* is bundled JSON content;
/// this stores the user's answers, keyed by step id in [responsesJson], plus a
/// denormalized [title]/[exercise] so the history list needs no content lookup.
@collection
class CbtEntry {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime timestampUtc;

  @Index()
  late int dateEpochDay;

  @enumerated
  late CbtExercise exercise;

  late String worksheetId;

  /// Denormalized worksheet title for the history list.
  late String title;

  /// JSON object of `{ stepId: answer }` — flexible so different worksheet
  /// shapes need no schema change.
  late String responsesJson;
}
