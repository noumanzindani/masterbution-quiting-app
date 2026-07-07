import 'dart:convert';

import 'package:isar_community/isar.dart';

import '../collections/cbt_entry.dart';
import '../enums.dart';
import '../time_buckets.dart';

/// Saves completed CBT worksheets. Append-only history so the user can look
/// back at their own thought records.
class CbtRepo {
  CbtRepo(this._isar);

  final Isar _isar;

  IsarCollection<CbtEntry> get _entries => _isar.cbtEntrys;

  Future<int> save({
    required String worksheetId,
    required String title,
    required CbtExercise exercise,
    required Map<String, String> responses,
    DateTime? at,
  }) {
    final when = at ?? DateTime.now();
    final entry = CbtEntry()
      ..timestampUtc = when.toUtc()
      ..dateEpochDay = TimeBuckets.epochDayForLocal(when)
      ..exercise = exercise
      ..worksheetId = worksheetId
      ..title = title
      ..responsesJson = jsonEncode(responses);
    return _isar.writeTxn(() => _entries.put(entry));
  }

  Future<List<CbtEntry>> recent({int limit = 50}) =>
      _entries.where().sortByTimestampUtcDesc().limit(limit).findAll();

  /// Decode a stored entry's answers back into a step-id → answer map.
  static Map<String, String> responsesOf(CbtEntry entry) {
    final decoded = jsonDecode(entry.responsesJson) as Map<String, dynamic>;
    return decoded.map((k, v) => MapEntry(k, v.toString()));
  }
}
