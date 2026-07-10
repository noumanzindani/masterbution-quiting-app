import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/services/progress_report.dart';

void main() {
  group('ProgressReport.build', () {
    test('includes the streak and days-active numbers', () {
      final text = ProgressReport.build(
        streakDays: 12,
        recoveryScore: 63,
        daysActive: 20,
        cleanCheckins: 15,
        goalLabel: 'Quit porn',
      );
      expect(text.contains('12'), isTrue);
      expect(text.contains('20'), isTrue);
      expect(text.toLowerCase().contains('day'), isTrue);
    });

    test('a zero streak reads supportively, never shaming', () {
      final text = ProgressReport.build(
        streakDays: 0,
        recoveryScore: 40,
        daysActive: 3,
        cleanCheckins: 0,
      );
      expect(text.trim(), isNotEmpty);
      for (final banned in ['fail', 'failure', 'relapse', 'weak', 'shame']) {
        expect(text.toLowerCase().contains(banned), isFalse,
            reason: 'progress copy must not contain "$banned"');
      }
    });
  });
}
