import 'package:isar_community/isar.dart';

part 'session_note.g.dart';

/// A private note from a session with a professional (therapist/counsellor),
/// plus an optional homework assignment the user can tick off. Local-only and
/// included in the encrypted backup — this is the "professional support" record,
/// never sent anywhere on its own.
@collection
class SessionNote {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime timestampUtc;

  @Index()
  late int dateEpochDay;

  late String title;

  String note = '';

  /// Optional homework/assignment text.
  String? homework;

  bool homeworkDone = false;
}
