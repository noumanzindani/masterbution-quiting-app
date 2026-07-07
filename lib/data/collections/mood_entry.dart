import 'package:isar_community/isar.dart';

part 'mood_entry.g.dart';

/// A mood journal entry: a 1–5 rating, optional emotion tags and free text.
///
/// [voicePath] and [photoPath] are reserved now (nullable) so adding voice/photo
/// capture in a later increment needs no schema migration — only paths live in
/// the DB; the media files themselves live on disk via path_provider.
@collection
class MoodEntry {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime timestampUtc;

  @Index()
  late int dateEpochDay;

  /// 1 (very low) – 5 (very good).
  late int mood;

  List<String> tags = const [];

  String? note;

  String? voicePath;
  String? photoPath;
}
