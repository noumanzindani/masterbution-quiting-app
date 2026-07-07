import '../config.dart';
import '../data/isar_service.dart';
import '../data/repositories/assessment_repo.dart';
import '../data/repositories/cbt_repo.dart';
import '../data/repositories/habit_repo.dart';
import '../data/repositories/journal_repo.dart';
import '../data/repositories/mood_repo.dart';
import '../data/repositories/recovery_goal_repo.dart';
import '../data/repositories/tracker_event_repo.dart';

/// One-shot async startup. Resolves the two things the app cannot run without —
/// SharedPreferences and the Isar database — and assigns them to the globals in
/// `config.dart` before `runApp`.
///
/// Phase 1 extends this with MobileAds init (once an AdMob App ID is configured),
/// timezone init, and local-notification channel setup.
class AppInit {
  static Future<void> run() async {
    prefs = await SharedPreferences.getInstance();
    isarService = await IsarService.open();

    // Wire repositories to the open database (single instance app-wide).
    final isar = isarService.isar;
    trackerRepo = TrackerEventRepo(isar);
    goalRepo = RecoveryGoalRepo(isar);
    assessmentRepo = AssessmentRepo(isar);
    journalRepo = JournalRepo(isar);
    habitRepo = HabitRepo(isar);
    moodRepo = MoodRepo(isar);
    cbtRepo = CbtRepo(isar);

    // Initialize the ads SDK (test IDs). Non-fatal if it fails — the app must
    // run fine without ads, and the AdPolicy gate keeps ads off until ready.
    await adService.init();

    // Load the bundled content corpus (small; degrades to empty on failure).
    await contentService.preload();

    // Record first-launch date once (used for lifetime stats, no PII).
    if (prefs.getString(session.firstLaunchDate) == null) {
      prefs.setString(
        session.firstLaunchDate,
        DateTime.now().toIso8601String(),
      );
    }
  }
}
