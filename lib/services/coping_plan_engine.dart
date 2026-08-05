import '../data/collections/coping_plan.dart';
import '../data/enums.dart';
import '../data/trigger_labels.dart';

/// What a reflection implies for the standing plan.
enum PlanAction {
  /// Nothing to record (no trigger, no strategy, or an unparseable trigger).
  none,

  /// First plan for this trigger.
  create,

  /// A different strategy replaces the active one; the old row is kept.
  supersede,

  /// The same strategy again — deliberately NOT a write, so repeating a plan
  /// doesn't manufacture identical history rows.
  reaffirm,
}

/// The decision [CopingPlanEngine.revise] reached. Data only — the repo executes it.
class PlanRevision {
  const PlanRevision({
    required this.action,
    this.trigger,
    this.strategy,
    this.need,
    this.supersededId,
  });

  static const PlanRevision noChange = PlanRevision(action: PlanAction.none);

  final PlanAction action;
  final TriggerType? trigger;
  final String? strategy;
  final String? need;

  /// Id of the plan this replaces — null unless [action] is [PlanAction.supersede].
  final int? supersededId;
}

/// Every decision about the standing coping plan, as pure functions over data.
///
/// Nothing here touches Isar, Flutter or the clock: the caller passes the
/// currently-active plans in and gets a decision back. That's what makes the
/// supersede semantics and the post-lapse guardrail unit-testable — this
/// project has no Isar-backed tests by design.
class CopingPlanEngine {
  const CopingPlanEngine._();

  /// [TriggerType] by enum name, or null. Deliberately not `values.byName`,
  /// which throws — an authoring typo in a flow JSON must degrade to "no plan",
  /// never crash a reflection.
  static TriggerType? parseTrigger(String? name) {
    if (name == null) return null;
    for (final t in TriggerType.values) {
      if (t.name == name) return t;
    }
    return null;
  }

  /// Decide what a reflection's collected [vars] imply, given every currently
  /// [active] plan. Reads `vars['trigger']` (a TriggerType name), `vars['plan']`
  /// (the strategy) and `vars['need']` — the keys the relapse flow writes.
  static PlanRevision revise({
    required Map<String, String> vars,
    required List<CopingPlan> active,
  }) {
    final trigger = parseTrigger(vars['trigger']);
    if (trigger == null) return PlanRevision.noChange;

    final strategy = (vars['plan'] ?? '').trim();
    if (strategy.isEmpty) return PlanRevision.noChange;

    final rawNeed = (vars['need'] ?? '').trim();
    final need = rawNeed.isEmpty ? null : rawNeed;

    final existing = _activeFor(trigger, active);
    if (existing == null) {
      return PlanRevision(
        action: PlanAction.create,
        trigger: trigger,
        strategy: strategy,
        need: need,
      );
    }
    if (_sameStrategy(existing.strategy, strategy)) {
      return PlanRevision(
        action: PlanAction.reaffirm,
        trigger: trigger,
        strategy: existing.strategy,
      );
    }
    return PlanRevision(
      action: PlanAction.supersede,
      trigger: trigger,
      strategy: strategy,
      need: need,
      supersededId: existing.id,
    );
  }

  /// The plan to surface for a logged urge: of [triggers], the one earliest in
  /// `quickTriggers` order that has an active plan. Order comes from the
  /// taxonomy rather than the user's tap order so the choice is deterministic.
  static CopingPlan? matchFor(
    List<TriggerType> triggers,
    List<CopingPlan> active,
  ) {
    CopingPlan? best;
    var bestRank = quickTriggers.length + 1;
    for (final t in triggers) {
      final plan = _activeFor(t, active);
      if (plan == null) continue;
      final rank = _rank(t);
      if (rank < bestRank) {
        bestRank = rank;
        best = plan;
      }
    }
    return best;
  }

  /// [matchFor], except never right after a lapse.
  ///
  /// Showing "your plan for stress: reach out to someone" the instant someone
  /// taps "I acted on it" reads as *you planned to, and didn't* — a rebuke, and
  /// a breach of the non-shaming guardrail. The relapse reflection auto-opens on
  /// that path and is where the learning belongs.
  static CopingPlan? cardFor({
    required Outcome? outcome,
    required List<TriggerType> triggers,
    required List<CopingPlan> active,
  }) {
    if (outcome == Outcome.lapse) return null;
    return matchFor(triggers, active);
  }

  static CopingPlan? _activeFor(TriggerType t, List<CopingPlan> active) {
    for (final p in active) {
      if (p.trigger == t && p.supersededAtUtc == null) return p;
    }
    return null;
  }

  /// A trigger absent from `quickTriggers` sorts last, keeping the order total.
  static int _rank(TriggerType t) {
    final i = quickTriggers.indexOf(t);
    return i == -1 ? quickTriggers.length : i;
  }

  static bool _sameStrategy(String a, String b) =>
      a.trim().toLowerCase() == b.trim().toLowerCase();
}
