import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/services/sleep_tips_engine.dart';

/// Builds a night with a healthy-baseline default so each test overrides only
/// the one signal it exercises. Defaults: 8h sleep, 23:00 bedtime, good quality.
SleepNight _n({int duration = 480, int bedtime = 1380, int quality = 4}) =>
    SleepNight(durationMinutes: duration, bedtimeMinutes: bedtime, quality: quality);

Set<String> _ids(List<SleepTip> tips) => tips.map((t) => t.id).toSet();

void main() {
  group('SleepTipsEngine min-sample gate', () {
    test('fewer than 3 nights returns only the starter tip', () {
      final tips = SleepTipsEngine.tips([_n(), _n()]);
      expect(tips.map((t) => t.id).toList(), ['log_more']);
    });

    test('no nights returns only the starter tip', () {
      expect(SleepTipsEngine.tips(const []).map((t) => t.id).toList(),
          ['log_more']);
    });
  });

  group('SleepTipsEngine healthy baseline', () {
    test('consistent, adequate, good-quality sleep yields only encouragement',
        () {
      final tips = SleepTipsEngine.tips([_n(), _n(), _n(), _n()]);
      expect(tips.map((t) => t.id).toList(), ['on_track']);
    });
  });

  group('SleepTipsEngine problem detection', () {
    test('short average sleep raises the short-sleep tip', () {
      final tips =
          SleepTipsEngine.tips([_n(duration: 300), _n(duration: 300), _n(duration: 320)]);
      expect(_ids(tips).contains('short_sleep'), isTrue);
      expect(_ids(tips).contains('on_track'), isFalse);
    });

    test('bedtimes varying by more than 90 minutes raise the consistency tip',
        () {
      // 21:00, 22:00, 23:00 — none late, but a 120-minute spread.
      final tips = SleepTipsEngine.tips(
          [_n(bedtime: 1260), _n(bedtime: 1320), _n(bedtime: 1380)]);
      expect(_ids(tips).contains('consistency'), isTrue);
      expect(_ids(tips).contains('late_bedtime'), isFalse);
      expect(_ids(tips).contains('short_sleep'), isFalse);
    });

    test('consistently late bedtimes raise the late-bedtime tip', () {
      // 01:00 every night — after the 00:30 threshold, but a zero spread.
      final tips =
          SleepTipsEngine.tips([_n(bedtime: 60), _n(bedtime: 60), _n(bedtime: 60)]);
      expect(_ids(tips).contains('late_bedtime'), isTrue);
      expect(_ids(tips).contains('consistency'), isFalse);
    });

    test('low average quality raises the quality tip', () {
      final tips =
          SleepTipsEngine.tips([_n(quality: 2), _n(quality: 2), _n(quality: 1)]);
      expect(_ids(tips).contains('quality'), isTrue);
      expect(_ids(tips).contains('on_track'), isFalse);
    });
  });

  group('SleepTipsEngine ordering & composition', () {
    test('multiple problems appear together, never with on_track/log_more', () {
      // Short (5h), late (01:00) and low quality (2) all at once.
      final tips = SleepTipsEngine.tips([
        _n(duration: 300, bedtime: 60, quality: 2),
        _n(duration: 300, bedtime: 60, quality: 2),
        _n(duration: 300, bedtime: 60, quality: 1),
      ]);
      final ids = _ids(tips);
      expect(ids.contains('short_sleep'), isTrue);
      expect(ids.contains('late_bedtime'), isTrue);
      expect(ids.contains('quality'), isTrue);
      expect(ids.contains('on_track'), isFalse);
      expect(ids.contains('log_more'), isFalse);
    });

    test('short-sleep is ordered before quality when both fire', () {
      final tips = SleepTipsEngine.tips([
        _n(duration: 300, quality: 2),
        _n(duration: 300, quality: 2),
        _n(duration: 300, quality: 1),
      ]);
      final ids = tips.map((t) => t.id).toList();
      expect(ids.indexOf('short_sleep') < ids.indexOf('quality'), isTrue);
    });

    test('every tip carries a non-empty title and body', () {
      final tips = SleepTipsEngine.tips([_n(duration: 300), _n(), _n()]);
      for (final t in tips) {
        expect(t.title.trim(), isNotEmpty);
        expect(t.body.trim(), isNotEmpty);
      }
    });
  });
}
