import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/data/collections/tracker_event.dart';
import 'package:momentum/data/enums.dart';
import 'package:momentum/services/streak_service.dart';

/// Build an in-memory TrackerEvent for a given local epoch-day.
TrackerEvent _ev(
  int day, {
  Outcome outcome = Outcome.resisted,
  LogType log = LogType.resistWin,
  BehaviorTarget target = BehaviorTarget.porn,
}) {
  return TrackerEvent()
    ..timestampUtc =
        DateTime.fromMillisecondsSinceEpoch(day * 86400000, isUtc: true)
    ..logType = log
    ..outcome = outcome
    ..target = target
    ..hourOfDay = 12
    ..weekday = 1
    ..dateEpochDay = day
    ..triggers = const [];
}

TrackerEvent _lapse(int day, {BehaviorTarget target = BehaviorTarget.porn}) =>
    _ev(day, outcome: Outcome.lapse, log: LogType.lapse, target: target);

void main() {
  const today = 100;
  const start = 55;
  const goal = 90;

  group('daysSinceLastLapse', () {
    test('equals days since start when there are no lapses', () {
      final events = [for (var d = 70; d < 100; d++) _ev(d)];
      final s = StreakService.compute(
        events,
        todayEpochDay: today,
        startEpochDay: start,
        target: BehaviorTarget.porn,
        goalTargetDays: goal,
      );
      expect(s.daysSinceLastLapse, today - start); // 45
    });

    test('counts days since the most recent lapse', () {
      final events = [_lapse(97), _ev(98), _ev(99)];
      final s = StreakService.compute(
        events,
        todayEpochDay: today,
        startEpochDay: start,
        target: BehaviorTarget.porn,
        goalTargetDays: goal,
      );
      expect(s.daysSinceLastLapse, 3);
    });
  });

  group('forgiving recovery score (70% resilience / 30% habit formation)', () {
    // 30 positive days of history.
    List<TrackerEvent> history() => [for (var d = 70; d < 100; d++) _ev(d)];

    test('one lapse after a strong run dips the score only slightly', () {
      final before = StreakService.compute(
        history(),
        todayEpochDay: today,
        startEpochDay: start,
        target: BehaviorTarget.porn,
        goalTargetDays: goal,
      );
      final after = StreakService.compute(
        [...history(), _lapse(today)],
        todayEpochDay: today,
        startEpochDay: start,
        target: BehaviorTarget.porn,
        goalTargetDays: goal,
      );

      // The visible streak counter resets...
      expect(before.daysSinceLastLapse, 45);
      expect(after.daysSinceLastLapse, 0);
      // ...but the Recovery Score barely moves, and never to zero.
      expect(before.recoveryScore - after.recoveryScore, lessThanOrEqualTo(5));
      expect(after.recoveryScore, greaterThan(0));
    });
  });

  group('score bounds and target isolation', () {
    test('scores stay within 0..100 even with only lapses', () {
      final events = [for (var d = 90; d < 100; d++) _lapse(d)];
      final s = StreakService.compute(
        events,
        todayEpochDay: today,
        startEpochDay: 80,
        target: BehaviorTarget.porn,
        goalTargetDays: goal,
      );
      expect(s.recoveryScore, inInclusiveRange(0, 100));
      expect(s.consistencyScore, inInclusiveRange(0, 100));
    });

    test('a lapse on a different behavior does not reset this streak', () {
      final events = [
        for (var d = 70; d < 100; d++) _ev(d, target: BehaviorTarget.porn),
        _lapse(today, target: BehaviorTarget.masturbation),
      ];
      final s = StreakService.compute(
        events,
        todayEpochDay: today,
        startEpochDay: start,
        target: BehaviorTarget.porn,
        goalTargetDays: goal,
      );
      expect(s.daysSinceLastLapse, 45);
    });
  });
}
