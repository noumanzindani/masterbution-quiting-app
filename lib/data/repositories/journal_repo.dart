import 'package:isar_community/isar.dart';

import '../collections/journal_entry.dart';
import '../enums.dart';
import '../time_buckets.dart';

/// Read/write access to [JournalEntry]. Append-only, like the rest of the app's
/// history.
class JournalRepo {
  JournalRepo(this._isar);

  final Isar _isar;

  IsarCollection<JournalEntry> get _entries => _isar.journalEntrys;

  Future<int> add({
    required JournalKind kind,
    required String text,
    String? emotion,
    int? mood,
    DateTime? at,
  }) {
    final when = at ?? DateTime.now();
    final entry = JournalEntry()
      ..timestampUtc = when.toUtc()
      ..dateEpochDay = TimeBuckets.epochDayForLocal(when)
      ..kind = kind
      ..text = text
      ..emotion = emotion
      ..mood = mood;
    return _isar.writeTxn(() => _entries.put(entry));
  }

  Future<List<JournalEntry>> recent({int limit = 30}) =>
      _entries.where().sortByTimestampUtcDesc().limit(limit).findAll();
}
