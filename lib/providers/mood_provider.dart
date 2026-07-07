import '../config.dart';
import '../data/collections/mood_entry.dart';

/// Backs the mood journal: recent entries plus the add action.
class MoodProvider extends ChangeNotifier {
  MoodProvider() {
    load();
  }

  bool loading = true;
  List<MoodEntry> entries = const [];

  Future<void> load() async {
    loading = true;
    notifyListeners();
    entries = await moodRepo.recent();
    loading = false;
    notifyListeners();
  }

  Future<void> add({
    required int mood,
    List<String> tags = const [],
    String? note,
    String? voicePath,
    String? photoPath,
  }) async {
    await moodRepo.add(
      mood: mood,
      tags: tags,
      note: note,
      voicePath: voicePath,
      photoPath: photoPath,
    );
    await load();
  }
}
