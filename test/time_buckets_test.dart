import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/data/time_buckets.dart';

void main() {
  group('TimeBuckets.fromLocal', () {
    test('captures local hour and ISO weekday', () {
      // 2026-07-08 is a Wednesday (ISO weekday 3), 14:30 local.
      final b = TimeBuckets.fromLocal(DateTime(2026, 7, 8, 14, 30));
      expect(b.hourOfDay, 14);
      expect(b.weekday, 3);
    });

    test('epoch day is the count of calendar days since 1970-01-01', () {
      expect(TimeBuckets.fromLocal(DateTime(1970, 1, 1, 0, 0)).dateEpochDay, 0);
      expect(TimeBuckets.fromLocal(DateTime(1970, 1, 2, 0, 0)).dateEpochDay, 1);
    });

    test('two moments on the same calendar day share one epoch day', () {
      final justAfterMidnight =
          TimeBuckets.fromLocal(DateTime(2026, 7, 8, 0, 5));
      final lateNight = TimeBuckets.fromLocal(DateTime(2026, 7, 8, 23, 55));
      expect(justAfterMidnight.dateEpochDay, lateNight.dateEpochDay);
    });

    test('consecutive calendar days differ by exactly one epoch day', () {
      final d1 = TimeBuckets.fromLocal(DateTime(2026, 3, 8, 12)).dateEpochDay;
      final d2 = TimeBuckets.fromLocal(DateTime(2026, 3, 9, 12)).dateEpochDay;
      // Spans the US spring-forward DST night; must still be +1, not +0/+2.
      expect(d2 - d1, 1);
    });
  });
}
