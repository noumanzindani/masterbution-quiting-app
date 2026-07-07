import 'package:isar_community/isar.dart';

import '../enums.dart';

part 'tracker_event.g.dart';

/// The central event log — every urge, lapse, resist-win and check-in lands
/// here. It is the workhorse the streak service and the Bucketed Aggregation
/// Engine read from.
///
/// Two design choices matter:
///  * **Lapse-tolerance** lives in [outcome]. A relapse is an ordinary row with
///    `outcome == Outcome.lapse`; nothing is ever deleted or reset.
///  * **Denormalized time buckets** ([hourOfDay], [weekday], [dateEpochDay]) are
///    stored + indexed so insights like "72% of lapses after midnight" are cheap
///    indexed `GROUP BY` counts rather than full-table scans.
@collection
class TrackerEvent {
  Id id = Isar.autoIncrement;

  /// UTC instant the event happened. Paired with [dateEpochDay] (local) so
  /// streaks/bins are computed in local time without DST/midnight drift.
  @Index()
  late DateTime timestampUtc;

  @Index()
  @enumerated
  late LogType logType;

  /// The lapse-tolerance mechanism — see class docs.
  @Index()
  @enumerated
  late Outcome outcome;

  @Index()
  @enumerated
  late BehaviorTarget target;

  // --- Denormalized time-bucket columns (indexed for GROUP-BY analytics) ---

  /// Local hour of day, 0–23.
  @Index()
  late int hourOfDay;

  /// Local ISO weekday, 1 (Mon) – 7 (Sun).
  @Index()
  late int weekday;

  /// Local days since Unix epoch (floor(localMillis / 86_400_000)). Used for
  /// day-grained grouping, streaks, and joins with mood/habit/sleep entries.
  @Index()
  late int dateEpochDay;

  /// Urge strength 0–10 (null for non-urge events).
  short? intensity;

  /// Free-form dominant emotion label (null if not captured).
  String? emotion;

  /// Optional note the user attached.
  String? note;

  /// Triggers as [TriggerType] indices. Value-indexed so per-trigger counts
  /// (`triggersElementEqualTo(t.index)`) are indexed lookups.
  @Index(type: IndexType.value)
  List<byte> triggers = const [];
}
