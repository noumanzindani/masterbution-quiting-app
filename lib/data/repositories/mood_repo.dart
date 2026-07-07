import 'package:isar_community/isar.dart';

import '../collections/mood_entry.dart';
import '../time_buckets.dart';

/// Mood journal storage. Append-only history, newest-first on read.
class MoodRepo {
  MoodRepo(this._isar);

  final Isar _isar;

  IsarCollection<MoodEntry> get _entries => _isar.moodEntrys;

  Future<int> add({
    required int mood,
    List<String> tags = const [],
    String? note,
    String? voicePath,
    String? photoPath,
    DateTime? at,
  }) {
    final when = at ?? DateTime.now();
    final entry = MoodEntry()
      ..timestampUtc = when.toUtc()
      ..dateEpochDay = TimeBuckets.epochDayForLocal(when)
      ..mood = mood
      ..tags = tags
      ..note = note
      ..voicePath = voicePath
      ..photoPath = photoPath;
    return _isar.writeTxn(() => _entries.put(entry));
  }

  Future<List<MoodEntry>> recent({int limit = 60}) =>
      _entries.where().sortByTimestampUtcDesc().limit(limit).findAll();
}
