import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/data/collections/sleep_entry.dart';

SleepEntry _e(int bed, int wake) => SleepEntry()
  ..bedtimeMinutes = bed
  ..wakeMinutes = wake
  ..quality = 3;

void main() {
  group('SleepEntry.durationMinutes', () {
    test('overnight sleep wraps past midnight (23:00 → 07:00 = 8h)', () {
      expect(_e(1380, 420).durationMinutes, 480);
    });

    test('bedtime after midnight, no wrap (00:30 → 08:00 = 7.5h)', () {
      expect(_e(30, 480).durationMinutes, 450);
    });

    test('same-evening span without wrap (22:00 → 23:30 = 1.5h)', () {
      expect(_e(1320, 1410).durationMinutes, 90);
    });
  });
}
