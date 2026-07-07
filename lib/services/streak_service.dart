import 'dart:math' as math;

import '../data/collections/tracker_event.dart';
import '../data/enums.dart';

/// Result of a streak computation for one behavior target.
class StreakStats {
  const StreakStats({
    required this.daysSinceLastLapse,
    required this.consistencyScore,
    required this.recoveryScore,
  });

  /// Days since the most recent lapse (or since the goal start if none). This
  /// is the counter that visibly resets to 0 on a lapse.
  final int daysSinceLastLapse;

  /// 0–100: share of recent days the user showed up with a positive action.
  final int consistencyScore;

  /// 0–100: overall progress. Deliberately *forgiving* — see [_wResilience].
  final int recoveryScore;
}

/// Pure, device-free streak + score math. Kept independent of Isar so it is
/// trivially unit-testable: repositories fetch [TrackerEvent]s and hand them in.
class StreakService {
  /// Recovery Score weighting (the "Forgiving" product choice):
  /// 70% resilience (windowed wins-vs-slips) + 30% habit formation (cumulative
  /// positive days). Habit formation is NOT erased by a lapse, so a single slip
  /// after a strong run barely moves the score even though the day-counter
  /// resets. Tune these two constants to shift how forgiving the app feels.
  static const double _wResilience = 0.7;
  static const double _wHabit = 0.3;

  /// Trailing window (days) for resilience + consistency.
  static const int _defaultWindow = 30;

  static StreakStats compute(
    List<TrackerEvent> events, {
    required int todayEpochDay,
    required int startEpochDay,
    required BehaviorTarget target,
    required int goalTargetDays,
    int windowDays = _defaultWindow,
  }) {
    final relevant = events.where((e) => _matches(target, e.target)).toList();
    final lapses = relevant.where((e) => e.outcome == Outcome.lapse).toList();
    final positives = relevant.where(_isPositive).toList();

    // --- Days since last lapse (the resetting counter) ---
    final daysSinceLastLapse = lapses.isEmpty
        ? math.max(0, todayEpochDay - startEpochDay)
        : todayEpochDay -
            lapses.map((e) => e.dateEpochDay).reduce(math.max);

    // --- Windowed resilience: wins vs slips in the trailing window ---
    final windowStart = todayEpochDay - windowDays + 1;
    bool inWindow(TrackerEvent e) =>
        e.dateEpochDay >= windowStart && e.dateEpochDay <= todayEpochDay;
    final windowPos = positives.where(inWindow).length;
    final windowLap = lapses.where(inWindow).length;
    final resilience = (windowPos + windowLap) == 0
        ? 0.5 // neutral baseline before any data exists
        : windowPos / (windowPos + windowLap);

    // --- Habit formation: cumulative distinct positive days (lapse-proof) ---
    final positiveDays = positives.map((e) => e.dateEpochDay).toSet();
    final habit = goalTargetDays <= 0
        ? 0.0
        : math.min(1.0, positiveDays.length / goalTargetDays);

    final recovery =
        (100 * (_wResilience * resilience + _wHabit * habit)).round().clamp(0, 100);

    // --- Consistency: share of window days with a positive action ---
    final windowPositiveDays =
        positives.where(inWindow).map((e) => e.dateEpochDay).toSet().length;
    final consistency =
        (100 * windowPositiveDays / windowDays).round().clamp(0, 100);

    return StreakStats(
      daysSinceLastLapse: daysSinceLastLapse,
      consistencyScore: consistency,
      recoveryScore: recovery,
    );
  }

  /// An event counts toward a target if it is that target, is tagged `both`, or
  /// the query itself is `both`.
  static bool _matches(BehaviorTarget query, BehaviorTarget eventTarget) =>
      query == BehaviorTarget.both ||
      eventTarget == BehaviorTarget.both ||
      eventTarget == query;

  static bool _isPositive(TrackerEvent e) =>
      e.outcome == Outcome.resisted ||
      e.outcome == Outcome.surfed ||
      e.outcome == Outcome.delayed ||
      e.logType == LogType.cleanCheckin ||
      e.logType == LogType.resistWin;
}
