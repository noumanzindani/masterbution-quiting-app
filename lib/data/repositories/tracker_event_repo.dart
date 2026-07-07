import 'package:isar_community/isar.dart';

import '../collections/tracker_event.dart';
import '../enums.dart';
import '../time_buckets.dart';

/// Read/write access to the [TrackerEvent] log — the app's core append-only
/// stream of urges, wins, check-ins and lapses.
///
/// Every write goes through [log], which stamps the denormalized time-bucket
/// columns via [TimeBuckets] so the writer and the streak reader always agree
/// on "which day" an event belongs to. Nothing here ever deletes or mutates a
/// past event: lapse-tolerance means a slip is just another appended row.
class TrackerEventRepo {
  TrackerEventRepo(this._isar);

  final Isar _isar;

  IsarCollection<TrackerEvent> get _events => _isar.trackerEvents;

  /// Append one event. [at] defaults to now; pass it for testing/backfill.
  Future<void> log({
    required LogType logType,
    required Outcome outcome,
    required BehaviorTarget target,
    int? intensity,
    String? emotion,
    String? note,
    List<TriggerType> triggers = const [],
    DateTime? at,
  }) async {
    final when = at ?? DateTime.now();
    final buckets = TimeBuckets.fromLocal(when);

    final event = TrackerEvent()
      ..timestampUtc = when.toUtc()
      ..logType = logType
      ..outcome = outcome
      ..target = target
      ..hourOfDay = buckets.hourOfDay
      ..weekday = buckets.weekday
      ..dateEpochDay = buckets.dateEpochDay
      ..intensity = intensity
      ..emotion = emotion
      ..note = note
      ..triggers = triggers.map((t) => t.index).toList();

    await _isar.writeTxn(() => _events.put(event));
  }

  /// A resisted / surfed / delayed urge — a win, never a failure.
  Future<void> logUrge({
    required BehaviorTarget target,
    required Outcome outcome,
    int? intensity,
    String? emotion,
    List<TriggerType> triggers = const [],
    String? note,
  }) {
    return log(
      logType: LogType.urge,
      outcome: outcome,
      target: target,
      intensity: intensity,
      emotion: emotion,
      triggers: triggers,
      note: note,
    );
  }

  /// A lapse — appended as data, framed as learning, never a reset.
  Future<void> logLapse({
    required BehaviorTarget target,
    List<TriggerType> triggers = const [],
    String? emotion,
    String? note,
  }) {
    return log(
      logType: LogType.lapse,
      outcome: Outcome.lapse,
      target: target,
      triggers: triggers,
      emotion: emotion,
      note: note,
    );
  }

  /// A plain "still on track today" tap.
  Future<void> logCleanCheckin({required BehaviorTarget target}) {
    return log(
      logType: LogType.cleanCheckin,
      outcome: Outcome.neutral,
      target: target,
    );
  }

  /// Every event, oldest first — the streak service filters by target itself.
  Future<List<TrackerEvent>> all() =>
      _events.where().sortByDateEpochDay().findAll();

  /// The most recent [limit] events, newest first (for a dashboard activity
  /// feed / recent history).
  Future<List<TrackerEvent>> recent({int limit = 20}) =>
      _events.where().sortByDateEpochDayDesc().limit(limit).findAll();
}
