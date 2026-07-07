import '../config.dart';
import '../data/collections/recovery_goal.dart';
import '../data/enums.dart';
import '../data/time_buckets.dart';
import '../services/streak_service.dart';

/// Backs the dashboard: loads the active goal + event history, derives the
/// lapse-tolerant [StreakStats], and routes the core-loop logging actions
/// (urge / lapse / check-in) through the repo, refreshing afterwards.
class DashboardProvider extends ChangeNotifier {
  DashboardProvider() {
    load();
  }

  RecoveryGoal? goal;
  StreakStats? stats;
  bool loading = true;

  BehaviorTarget get target => goal?.target ?? BehaviorTarget.both;

  Future<void> load() async {
    loading = true;
    notifyListeners();

    goal = await goalRepo.getActive();
    if (goal != null) {
      final events = await trackerRepo.all();
      stats = StreakService.compute(
        events,
        todayEpochDay: TimeBuckets.todayEpochDay(),
        startEpochDay: TimeBuckets.epochDayForLocal(goal!.startDate),
        target: goal!.target,
        goalTargetDays: goal!.targetDays,
      );
    }

    loading = false;
    notifyListeners();
  }

  /// Log an urge and its outcome (resisted / surfed / delayed / lapse), then
  /// recompute. A lapse here dips the score slightly — it never resets it.
  Future<void> logUrge({
    required Outcome outcome,
    int? intensity,
    String? emotion,
    List<TriggerType> triggers = const [],
    String? note,
  }) async {
    await trackerRepo.logUrge(
      target: target,
      outcome: outcome,
      intensity: intensity,
      emotion: emotion,
      triggers: triggers,
      note: note,
    );
    await load();
  }

  /// Log a lapse directly (the "I slipped" action). Appended as data, framed as
  /// learning — the day-counter resets but the Recovery Score barely moves.
  Future<void> logLapse({
    List<TriggerType> triggers = const [],
    String? emotion,
    String? note,
  }) async {
    await trackerRepo.logLapse(
      target: target,
      triggers: triggers,
      emotion: emotion,
      note: note,
    );
    // A person who just logged a slip is never monetised in that moment: open a
    // no-ad cooldown window before reloading (the banner re-checks on rebuild).
    adService.tripPostLapseCooldown();
    await load();
  }

  /// A simple "still on track today" tap.
  Future<void> checkInClean() async {
    await trackerRepo.logCleanCheckin(target: target);
    await load();
  }
}
