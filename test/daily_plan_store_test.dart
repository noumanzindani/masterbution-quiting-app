import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/config.dart';
import 'package:momentum/data/time_buckets.dart';
import 'package:momentum/services/daily_plan_store.dart';

Future<void> _setRaw(String? raw) async {
  SharedPreferences.setMockInitialValues(
    raw == null ? {} : {session.dailyPlan: raw},
  );
  prefs = await SharedPreferences.getInstance();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('no stored plan → empty', () async {
    await _setRaw(null);
    expect(DailyPlanStore.load(), isEmpty);
  });

  test('loads today\'s items', () async {
    await _setRaw(jsonEncode({
      'day': TimeBuckets.todayEpochDay(),
      'items': [
        {'t': 'Move my body', 'd': false},
        {'t': 'Sleep by 11pm', 'd': true},
      ],
    }));
    final items = DailyPlanStore.load();
    expect(items.length, 2);
    expect(items.first.text, 'Move my body');
    expect(items.last.done, isTrue);
  });

  test('a plan from a previous day is not carried over', () async {
    await _setRaw(jsonEncode({
      'day': TimeBuckets.todayEpochDay() - 1,
      'items': [
        {'t': 'Yesterday\'s intention', 'd': false},
      ],
    }));
    expect(DailyPlanStore.load(), isEmpty);
  });

  test('a corrupt blob starts empty rather than throwing', () async {
    await _setRaw('not json at all');
    expect(DailyPlanStore.load(), isEmpty);
  });

  test('addIntention appends to today', () async {
    await _setRaw(null);
    await DailyPlanStore.addIntention('Practice: Breathe for a minute');
    final items = DailyPlanStore.load();
    expect(items.single.text, 'Practice: Breathe for a minute');
    expect(items.single.done, isFalse);
  });

  test('addIntention de-dupes so a repeated reflection cannot stack it up',
      () async {
    await _setRaw(null);
    await DailyPlanStore.addIntention('Practice: Breathe for a minute');
    await DailyPlanStore.addIntention('  practice: breathe for a minute ');
    expect(DailyPlanStore.load().length, 1);
  });

  test('addIntention ignores blank text', () async {
    await _setRaw(null);
    await DailyPlanStore.addIntention('   ');
    expect(DailyPlanStore.load(), isEmpty);
  });

  test('save round-trips through prefs', () async {
    await _setRaw(null);
    await DailyPlanStore.save([DailyPlanItem('Get outside', true)]);
    final items = DailyPlanStore.load();
    expect(items.single.text, 'Get outside');
    expect(items.single.done, isTrue);
  });
}
