import 'package:isar_community/isar.dart';

import '../enums.dart';

part 'recovery_goal.g.dart';

/// The user's active recovery goal, chosen at onboarding and editable later.
/// Milestones (7/30/90/180-day, plus custom) are embedded so a goal is a single
/// self-contained record.
@collection
class RecoveryGoal {
  Id id = Isar.autoIncrement;

  @enumerated
  late GoalType type;

  /// Which behavior this goal concerns (drives which streaks are shown).
  @enumerated
  late BehaviorTarget target;

  /// Target length in days (7 / 30 / 90 / 180, or a custom value).
  late int targetDays;

  late DateTime startDate;

  /// Only one goal is active at a time; indexed for a fast lookup.
  @Index()
  bool active = true;

  List<Milestone> milestones = const [];
}

/// A single milestone within a [RecoveryGoal] (embedded, not its own table).
@embedded
class Milestone {
  /// Day offset from the goal start that unlocks this milestone (e.g. 7, 30).
  int day = 0;

  String label = '';

  bool reached = false;

  DateTime? reachedAt;
}
