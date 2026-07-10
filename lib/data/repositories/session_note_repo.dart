import 'package:isar_community/isar.dart';

import '../collections/session_note.dart';
import '../time_buckets.dart';

/// Storage for professional-support session notes + homework. Newest-first.
class SessionNoteRepo {
  SessionNoteRepo(this._isar);

  final Isar _isar;

  IsarCollection<SessionNote> get _notes => _isar.sessionNotes;

  Future<int> add({
    required String title,
    String note = '',
    String? homework,
    DateTime? at,
  }) {
    final when = at ?? DateTime.now();
    final entry = SessionNote()
      ..timestampUtc = when.toUtc()
      ..dateEpochDay = TimeBuckets.epochDayForLocal(when)
      ..title = title
      ..note = note
      ..homework = homework;
    return _isar.writeTxn(() => _notes.put(entry));
  }

  Future<List<SessionNote>> recent({int limit = 100}) =>
      _notes.where().sortByTimestampUtcDesc().limit(limit).findAll();

  Future<void> setHomeworkDone(int id, bool done) async {
    await _isar.writeTxn(() async {
      final n = await _notes.get(id);
      if (n != null) {
        n.homeworkDone = done;
        await _notes.put(n);
      }
    });
  }

  Future<void> delete(int id) =>
      _isar.writeTxn(() => _notes.delete(id));
}
