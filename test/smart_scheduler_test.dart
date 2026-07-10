import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/services/risk_engine.dart';
import 'package:momentum/services/smart_scheduler.dart';

ReminderSpec? _byKey(List<ReminderSpec> specs, String key) {
  for (final s in specs) {
    if (s.key == key) return s;
  }
  return null;
}

void main() {
  // Quiet 22:00–07:00, daily check-in at 20:00 — the defaults.
  const prefs = NotificationPrefs(enabled: true);

  group('SmartScheduler — enablement', () {
    test('disabled prefs schedule nothing', () {
      const off = NotificationPrefs(enabled: false);
      expect(SmartScheduler.plan(RiskProfile.empty, off), isEmpty);
    });

    test('enabled with no pattern still schedules the daily check-in', () {
      final specs = SmartScheduler.plan(RiskProfile.empty, prefs);
      final checkin = _byKey(specs, 'daily_checkin');
      expect(checkin, isNotNull);
      expect(checkin!.hour, 20);
      expect(checkin.weekday, isNull); // daily
    });
  });

  group('SmartScheduler — risk-driven reminders', () {
    test('a daytime peak hour adds a heads-up one hour before', () {
      const profile = RiskProfile(peakRiskHour: 15);
      final heads = _byKey(SmartScheduler.plan(profile, prefs), 'risk_heads_up');
      expect(heads, isNotNull);
      expect(heads!.hour, 14);
      expect(heads.weekday, isNull);
    });

    test('a toughest weekday adds a weekly morning nudge on that day', () {
      const profile = RiskProfile(toughestWeekday: 6); // Saturday
      final tough = _byKey(SmartScheduler.plan(profile, prefs), 'tough_day');
      expect(tough, isNotNull);
      expect(tough!.weekday, 6);
    });
  });

  group('SmartScheduler — quiet hours', () {
    test('a reminder that falls inside quiet hours is dropped', () {
      // Peak at 23:00 → heads-up at 22:00, inside the 22:00–07:00 quiet window.
      const profile = RiskProfile(peakRiskHour: 23);
      final specs = SmartScheduler.plan(profile, prefs);
      expect(_byKey(specs, 'risk_heads_up'), isNull);
    });

    test('a check-in moved into quiet hours is dropped', () {
      const nightPrefs = NotificationPrefs(enabled: true, checkInHour: 2);
      final specs = SmartScheduler.plan(RiskProfile.empty, nightPrefs);
      expect(_byKey(specs, 'daily_checkin'), isNull);
    });
  });

  group('SmartScheduler — determinism', () {
    test('ids and keys are stable and unique across a full plan', () {
      const profile = RiskProfile(peakRiskHour: 15, toughestWeekday: 3);
      final specs = SmartScheduler.plan(profile, prefs);
      final ids = specs.map((s) => s.id).toList();
      final keys = specs.map((s) => s.key).toList();
      expect(ids.toSet().length, ids.length);
      expect(keys.toSet().length, keys.length);
      // Every spec carries non-empty copy.
      for (final s in specs) {
        expect(s.title.trim(), isNotEmpty);
        expect(s.body.trim(), isNotEmpty);
      }
    });
  });
}
