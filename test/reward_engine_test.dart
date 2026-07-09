import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/content/reward_models.dart';
import 'package:momentum/services/reward_engine.dart';

Achievement _a(String id, String metric, int atLeast, int coins) => Achievement(
      id: id,
      title: id,
      description: '',
      icon: 'star',
      metric: metric,
      atLeast: atLeast,
      coins: coins,
    );

void main() {
  final defs = [
    _a('first_step', 'positiveDays', 1, 5),
    _a('one_week', 'streakDays', 7, 20),
    _a('reflective', 'reflections', 5, 15),
  ];

  group('Achievement parsing', () {
    test('parses from JSON with defensive defaults', () {
      final a = Achievement.fromJson({
        'id': 'x',
        'title': 'X',
        'metric': 'streakDays',
        'atLeast': 3,
        'coins': 10,
      });
      expect(a.id, 'x');
      expect(a.atLeast, 3);
      expect(a.coins, 10);
      expect(a.icon, 'star'); // default
    });
  });

  group('RewardEngine.isEarned', () {
    test('true when the metric meets the threshold', () {
      expect(RewardEngine.isEarned(defs[1], {'streakDays': 7}), isTrue);
      expect(RewardEngine.isEarned(defs[1], {'streakDays': 9}), isTrue);
    });

    test('false below the threshold', () {
      expect(RewardEngine.isEarned(defs[1], {'streakDays': 6}), isFalse);
    });

    test('a missing metric counts as zero, not a crash', () {
      expect(RewardEngine.isEarned(defs[1], const {}), isFalse);
    });
  });

  group('RewardEngine.earnedIds', () {
    test('returns exactly the achievements whose condition is met', () {
      final ids = RewardEngine.earnedIds(defs, {
        'positiveDays': 3,
        'streakDays': 2,
        'reflections': 5,
      });
      expect(ids, {'first_step', 'reflective'});
    });

    test('is empty when nothing is met', () {
      expect(RewardEngine.earnedIds(defs, const {}), isEmpty);
    });
  });

  group('RewardEngine.coinsForUnlocked', () {
    test('sums the coins of the unlocked achievements only', () {
      expect(
        RewardEngine.coinsForUnlocked(defs, {'first_step', 'reflective'}),
        20,
      );
    });

    test('ignores unknown ids (e.g. a removed achievement)', () {
      expect(
        RewardEngine.coinsForUnlocked(defs, {'first_step', 'gone'}),
        5,
      );
    });

    test('is zero for an empty set', () {
      expect(RewardEngine.coinsForUnlocked(defs, const {}), 0);
    });
  });
}
