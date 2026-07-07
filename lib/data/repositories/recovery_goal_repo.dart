import 'package:isar_community/isar.dart';

import '../collections/recovery_goal.dart';
import '../enums.dart';

/// Owns the user's [RecoveryGoal]s. Only one is active at a time — [saveActive]
/// atomically retires any previously-active goal so the invariant can never be
/// violated by a crash mid-write.
class RecoveryGoalRepo {
  RecoveryGoalRepo(this._isar);

  final Isar _isar;

  IsarCollection<RecoveryGoal> get _goals => _isar.recoveryGoals;

  /// Persist [goal] as the single active goal and return its assigned id.
  Future<int> saveActive(RecoveryGoal goal) async {
    goal.active = true;
    late int id;
    await _isar.writeTxn(() async {
      // Retire whatever was active before, then store the new one.
      final previouslyActive = await _goals.filter().activeEqualTo(true).findAll();
      for (final g in previouslyActive) {
        g.active = false;
      }
      if (previouslyActive.isNotEmpty) {
        await _goals.putAll(previouslyActive);
      }
      id = await _goals.put(goal);
    });
    return id;
  }

  Future<RecoveryGoal?> getActive() =>
      _goals.filter().activeEqualTo(true).findFirst();

  Future<RecoveryGoal?> byId(int id) => _goals.get(id);

  /// Build a goal with a sensible milestone ladder derived from [targetDays].
  /// Standard checkpoints (1/3/7/14/30/90/180) are included when they fall on
  /// or before the target, and the target day itself always caps the ladder.
  static RecoveryGoal build({
    required GoalType type,
    required BehaviorTarget target,
    required int targetDays,
    required DateTime startDate,
  }) {
    const standard = [1, 3, 7, 14, 30, 90, 180];
    final days = <int>{
      for (final d in standard)
        if (d <= targetDays) d,
      targetDays,
    }.toList()
      ..sort();

    return RecoveryGoal()
      ..type = type
      ..target = target
      ..targetDays = targetDays
      ..startDate = startDate
      ..active = true
      ..milestones = [
        for (final d in days)
          Milestone()
            ..day = d
            ..label = _milestoneLabel(d)
            ..reached = false,
      ];
  }

  static String _milestoneLabel(int day) {
    switch (day) {
      case 1:
        return 'First day';
      case 3:
        return 'Three days';
      case 7:
        return 'One week';
      case 14:
        return 'Two weeks';
      case 30:
        return 'One month';
      case 90:
        return 'Three months';
      case 180:
        return 'Six months';
      default:
        return '$day days';
    }
  }
}
