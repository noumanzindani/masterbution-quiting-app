import '../config.dart';
import '../data/collections/sleep_entry.dart';
import '../services/sleep_tips_engine.dart';

/// Screen-scoped state for the sleep tracker: the recent nightly history plus
/// the rule-based tips derived from it. Saving a night re-derives both, so the
/// tips update live as data accrues.
class SleepProvider extends ChangeNotifier {
  SleepProvider() {
    refresh();
  }

  bool loading = true;
  List<SleepEntry> entries = const [];
  List<SleepTip> tips = const [];

  Future<void> refresh() async {
    loading = true;
    notifyListeners();

    entries = await sleepRepo.recent();
    tips = SleepTipsEngine.tips(entries
        .map((e) => SleepNight(
              durationMinutes: e.durationMinutes,
              bedtimeMinutes: e.bedtimeMinutes,
              quality: e.quality,
            ))
        .toList());

    loading = false;
    notifyListeners();
  }

  Future<void> log({
    required int bedtimeMinutes,
    required int wakeMinutes,
    required int quality,
    String? note,
  }) async {
    await sleepRepo.add(
      bedtimeMinutes: bedtimeMinutes,
      wakeMinutes: wakeMinutes,
      quality: quality,
      note: (note != null && note.trim().isNotEmpty) ? note.trim() : null,
    );
    await refresh();
  }
}
