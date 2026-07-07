import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/services/program_progress.dart';

void main() {
  group('ProgramProgress.isUnlocked', () {
    test('day 1 is always unlocked', () {
      expect(ProgramProgress.isUnlocked(1, const {}), isTrue);
    });

    test('a later day unlocks only when the previous is completed', () {
      expect(ProgramProgress.isUnlocked(3, const {1}), isFalse);
      expect(ProgramProgress.isUnlocked(3, const {1, 2}), isTrue);
    });
  });

  group('ProgramProgress.currentDay', () {
    test('is day 1 when nothing is done', () {
      expect(ProgramProgress.currentDay(const {}, 7), 1);
    });

    test('is the first uncompleted day', () {
      expect(ProgramProgress.currentDay(const {1, 2}, 7), 3);
    });

    test('caps at the total when everything is done', () {
      expect(ProgramProgress.currentDay(const {1, 2, 3}, 3), 3);
    });
  });

  test('isComplete when every day is done', () {
    expect(ProgramProgress.isComplete(const {1, 2, 3}, 3), isTrue);
    expect(ProgramProgress.isComplete(const {1, 2}, 3), isFalse);
  });
}
