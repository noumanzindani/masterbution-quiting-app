import 'package:isar_community/isar.dart';

import '../collections/sleep_entry.dart';
import '../time_buckets.dart';

/// Nightly sleep storage. One entry per morning: adding a night that already
/// has an entry for its wake-day replaces it, so re-logging corrects rather
/// than duplicates.
class SleepRepo {
  SleepRepo(this._isar);

  final Isar _isar;

  IsarCollection<SleepEntry> get _entries => _isar.sleepEntrys;

  Future<int> add({
    required int bedtimeMinutes,
    required int wakeMinutes,
    required int quality,
    String? note,
    DateTime? at,
  }) async {
    final when = at ?? DateTime.now();
    final day = TimeBuckets.epochDayForLocal(when);

    // Upsert: keep the id of any existing entry for this morning so the day
    // isn't logged twice.
    final existing =
        await _entries.filter().dateEpochDayEqualTo(day).findFirst();

    final entry = SleepEntry()
      ..id = existing?.id ?? Isar.autoIncrement
      ..timestampUtc = when.toUtc()
      ..dateEpochDay = day
      ..bedtimeMinutes = bedtimeMinutes
      ..wakeMinutes = wakeMinutes
      ..quality = quality
      ..note = note;

    return _isar.writeTxn(() => _entries.put(entry));
  }

  /// Newest-first, for the history list and to feed the tips engine.
  Future<List<SleepEntry>> recent({int limit = 30}) =>
      _entries.where().sortByDateEpochDayDesc().limit(limit).findAll();
}
