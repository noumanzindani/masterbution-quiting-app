import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/data/collections/tracker_event.dart';
import 'package:momentum/data/enums.dart';
import 'package:momentum/services/risk_engine.dart';

/// In-memory event builder (mirrors analytics_engine_test). [weekday] is ISO.
TrackerEvent _ev({
  int hour = 12,
  int weekday = 1,
  Outcome outcome = Outcome.lapse,
}) {
  return TrackerEvent()
    ..timestampUtc = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true)
    ..logType = LogType.lapse
    ..outcome = outcome
    ..target = BehaviorTarget.porn
    ..hourOfDay = hour
    ..weekday = weekday
    ..dateEpochDay = 100
    ..triggers = const [];
}

void main() {
  group('RiskEngine.profile — min-sample gate', () {
    test('too few lapses surfaces no risk hour or weekday', () {
      final events = [_ev(hour: 23), _ev(hour: 23)]; // only 2 lapses
      final p = RiskEngine.profile(events);
      expect(p.peakRiskHour, isNull);
      expect(p.toughestWeekday, isNull);
    });

    test('no events at all is a null profile', () {
      final p = RiskEngine.profile(const []);
      expect(p.peakRiskHour, isNull);
      expect(p.toughestWeekday, isNull);
      expect(p.hasSignal, isFalse);
    });
  });

  group('RiskEngine.profile — pattern detection', () {
    test('a late-night lapse cluster surfaces that hour', () {
      final events = [
        for (var i = 0; i < 6; i++) _ev(hour: 23),
        _ev(hour: 9),
      ];
      expect(RiskEngine.profile(events).peakRiskHour, 23);
    });

    test('a repeated tough weekday surfaces it (ISO weekday)', () {
      final events = [
        for (var i = 0; i < 6; i++) _ev(weekday: 6), // Saturday
        _ev(weekday: 2),
      ];
      expect(RiskEngine.profile(events).toughestWeekday, 6);
    });

    test('resisted urges are not risk — only lapses count', () {
      final events = [
        for (var i = 0; i < 8; i++) _ev(hour: 23, outcome: Outcome.resisted),
      ];
      expect(RiskEngine.profile(events).peakRiskHour, isNull);
    });

    test('lapses with no bin reaching 2 raise no false pattern', () {
      // 6 lapses, each in a distinct hour — enough samples, but no cluster.
      final events = [for (var h = 0; h < 6; h++) _ev(hour: h)];
      expect(RiskEngine.profile(events).peakRiskHour, isNull);
    });

    test('hasSignal is true when any pattern is found', () {
      final events = [for (var i = 0; i < 6; i++) _ev(hour: 1)];
      expect(RiskEngine.profile(events).hasSignal, isTrue);
    });
  });
}
