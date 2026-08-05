import 'package:isar_community/isar.dart';

import '../../services/coping_plan_engine.dart';
import '../collections/coping_plan.dart';
import '../enums.dart';

/// Storage for standing coping plans. One active plan per trigger; replacing a
/// strategy stamps the old row as superseded rather than deleting it, so the
/// history of what did and didn't hold survives.
class CopingPlanRepo {
  CopingPlanRepo(this._isar);

  final Isar _isar;

  IsarCollection<CopingPlan> get _plans => _isar.copingPlans;

  /// Every currently-active plan — the input [CopingPlanEngine] expects.
  Future<List<CopingPlan>> active() =>
      _plans.filter().supersededAtUtcIsNull().findAll();

  Future<CopingPlan?> activeFor(TriggerType trigger) =>
      _plans.filter().triggerEqualTo(trigger).supersededAtUtcIsNull().findFirst();

  /// Newest-first, active and superseded, for the plan screen's history view.
  Future<List<CopingPlan>> historyFor(TriggerType trigger) =>
      _plans.filter().triggerEqualTo(trigger).sortByCreatedAtUtcDesc().findAll();

  /// Execute an engine decision. No-op for [PlanAction.none] and
  /// [PlanAction.reaffirm] — the engine decides whether to write.
  Future<void> apply(PlanRevision revision, {DateTime? at}) async {
    if (revision.action == PlanAction.none ||
        revision.action == PlanAction.reaffirm) {
      return;
    }
    final now = (at ?? DateTime.now()).toUtc();
    // One transaction: superseding the old row and inserting its replacement
    // must not be separable, or a crash between them leaves the trigger with no
    // active plan at all.
    await _isar.writeTxn(() async {
      final supersededId = revision.supersededId;
      if (supersededId != null) {
        final old = await _plans.get(supersededId);
        if (old != null) {
          old.supersededAtUtc = now;
          await _plans.put(old);
        }
      }
      final plan = CopingPlan()
        ..trigger = revision.trigger!
        ..strategy = revision.strategy!
        ..createdAtUtc = now
        ..need = revision.need;
      await _plans.put(plan);
    });
  }

  /// Reword a plan in place. Editing isn't a revision — it's the same intention,
  /// said better — so it doesn't create history.
  Future<void> edit(int id, String strategy) async {
    final plan = await _plans.get(id);
    if (plan == null) return;
    plan.strategy = strategy;
    await _isar.writeTxn(() => _plans.put(plan));
  }

  Future<void> remove(int id) => _isar.writeTxn(() => _plans.delete(id));
}
