import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/data/collections/tracker_event.dart';
import 'package:momentum/data/enums.dart';
import 'package:momentum/services/analytics_engine.dart';

/// In-memory event builder. [weekday] is ISO (1=Mon..7=Sun).
TrackerEvent _ev({
  int hour = 12,
  int weekday = 1,
  int day = 100,
  Outcome outcome = Outcome.lapse,
  LogType log = LogType.lapse,
  BehaviorTarget target = BehaviorTarget.porn,
  List<TriggerType> triggers = const [],
}) {
  return TrackerEvent()
    ..timestampUtc = DateTime.fromMillisecondsSinceEpoch(day * 86400000, isUtc: true)
    ..logType = log
    ..outcome = outcome
    ..target = target
    ..hourOfDay = hour
    ..weekday = weekday
    ..dateEpochDay = day
    ..triggers = triggers.map((t) => t.index).toList();
}

void main() {
  group('histograms', () {
    test('hourHistogram counts events into 24 hourly bins', () {
      final events = [_ev(hour: 1), _ev(hour: 1), _ev(hour: 23)];
      final h = AnalyticsEngine.hourHistogram(events);
      expect(h.length, 24);
      expect(h[1], 2);
      expect(h[23], 1);
      expect(h[12], 0);
    });

    test('weekdayHistogram indexes Mon..Sun as 0..6', () {
      final events = [_ev(weekday: 1), _ev(weekday: 7), _ev(weekday: 7)];
      final w = AnalyticsEngine.weekdayHistogram(events);
      expect(w.length, 7);
      expect(w[0], 1); // Monday
      expect(w[6], 2); // Sunday
    });

    test('heatmap is a 7x24 grid keyed by [weekday][hour]', () {
      final events = [_ev(weekday: 3, hour: 2), _ev(weekday: 3, hour: 2)];
      final grid = AnalyticsEngine.heatmap(events);
      expect(grid.length, 7);
      expect(grid[0].length, 24);
      expect(grid[2][2], 2); // Wednesday, 2am
      expect(grid[0][0], 0);
    });
  });

  group('top triggers', () {
    test('counts and ranks triggers most-common first', () {
      final events = [
        _ev(triggers: const [TriggerType.stress, TriggerType.boredom]),
        _ev(triggers: const [TriggerType.stress]),
        _ev(triggers: const [TriggerType.stress, TriggerType.loneliness]),
      ];
      final top = AnalyticsEngine.topTriggers(events, limit: 2);
      expect(top.length, 2);
      expect(top.first.trigger, TriggerType.stress);
      expect(top.first.count, 3);
    });
  });

  group('shareInHours', () {
    test('fraction of events falling in the given hours', () {
      final events = [_ev(hour: 0), _ev(hour: 1), _ev(hour: 14), _ev(hour: 15)];
      expect(AnalyticsEngine.shareInHours(events, const {0, 1, 2, 3}), 0.5);
    });

    test('empty input is zero, not a divide-by-zero', () {
      expect(AnalyticsEngine.shareInHours(const [], const {0}), 0.0);
    });
  });

  group('least-squares trend', () {
    test('rising series has positive slope and projects upward', () {
      final t = AnalyticsEngine.trend([1, 2, 3, 4, 5]);
      expect(t.slope, closeTo(1.0, 1e-9));
      expect(t.projectedNext, closeTo(6.0, 1e-9));
    });

    test('falling series has negative slope', () {
      expect(AnalyticsEngine.trend([5, 4, 3, 2, 1]).slope, lessThan(0));
    });

    test('flat series has zero slope', () {
      expect(AnalyticsEngine.trend([3, 3, 3, 3]).slope, closeTo(0.0, 1e-9));
    });
  });

  group('insights (minimum-sample gated)', () {
    List<TrackerEvent> lateNight(int n) =>
        [for (var i = 0; i < n; i++) _ev(hour: 1, day: 100 + i)];

    test('no insights below the minimum sample size', () {
      final ids = AnalyticsEngine.insights(lateNight(3))
          .map((i) => i.id)
          .toList();
      expect(ids, isEmpty);
    });

    test('a strong late-night pattern surfaces once there is enough data', () {
      final ids = AnalyticsEngine.insights(lateNight(6))
          .map((i) => i.id)
          .toList();
      expect(ids, contains('late_night'));
    });

    test('a dominant trigger surfaces as an insight', () {
      final events = [
        for (var i = 0; i < 6; i++)
          _ev(day: 100 + i, triggers: const [TriggerType.stress]),
      ];
      final ids =
          AnalyticsEngine.insights(events).map((i) => i.id).toList();
      expect(ids, contains('top_trigger'));
    });
  });
}
