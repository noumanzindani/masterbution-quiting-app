import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/content/reward_models.dart';

/// Validates the authored achievements against the metrics the RewardsProvider
/// actually produces. A badge that references an unknown metric can NEVER
/// unlock — a silent, demoralising bug this test makes impossible to ship.
void main() {
  // Must stay in sync with RewardsProvider._gatherMetrics().
  const knownMetrics = {'streakDays', 'positiveDays', 'reflections', 'daysActive'};

  final defs = (jsonDecode(
              File('assets/content/rewards/achievements.json').readAsStringSync())
          as List)
      .map((e) => Achievement.fromJson(e as Map<String, dynamic>))
      .toList();

  test('achievements corpus is non-empty', () {
    expect(defs, isNotEmpty);
  });

  test('every achievement targets a metric the app produces', () {
    for (final a in defs) {
      expect(knownMetrics.contains(a.metric), isTrue,
          reason: '"${a.id}" uses unknown metric "${a.metric}"');
    }
  });

  test('ids are unique', () {
    final ids = defs.map((a) => a.id).toList();
    expect(ids.toSet().length, ids.length);
  });

  test('every achievement has a positive threshold and coin reward', () {
    for (final a in defs) {
      expect(a.atLeast, greaterThan(0), reason: '${a.id} atLeast');
      expect(a.coins, greaterThan(0), reason: '${a.id} coins');
    }
  });
}
