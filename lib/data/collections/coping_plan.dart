import 'package:isar_community/isar.dart';

import '../enums.dart';

part 'coping_plan.g.dart';

/// A standing if-then coping plan: "when [trigger] hits, I'll [strategy]".
///
/// Captured by the relapse-reflection flow, which already collects exactly this
/// pair. Keyed by [TriggerType] — the same vocabulary the urge log records — so
/// a plan can be matched to a logged urge and surfaced at the moment it's for.
///
/// One plan per trigger is active at a time. A later reflection that picks a
/// different strategy stamps [supersededAtUtc] on the old row rather than
/// deleting it, so "breathing didn't hold for stress; reaching out did" stays
/// legible.
@collection
class CopingPlan {
  Id id = Isar.autoIncrement;

  @Index()
  @enumerated
  late TriggerType trigger;

  /// The coping action, e.g. "Reach out to someone". Free text so the plan
  /// screen can reword it; the flow seeds it from a fixed set of choices.
  late String strategy;

  @Index()
  late DateTime createdAtUtc;

  /// Null while this is the active plan for its trigger. Set when a later
  /// reflection replaces it — superseded plans are kept, never deleted.
  DateTime? supersededAtUtc;

  /// What the user hoped the behaviour would give them, from the reflection
  /// that created this plan. Context for the plan screen.
  String? need;
}
