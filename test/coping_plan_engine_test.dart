import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/data/collections/coping_plan.dart';
import 'package:momentum/data/enums.dart';
import 'package:momentum/services/coping_plan_engine.dart';

CopingPlan _plan(
  TriggerType trigger,
  String strategy, {
  int id = 1,
  DateTime? superseded,
}) =>
    CopingPlan()
      ..id = id
      ..trigger = trigger
      ..strategy = strategy
      ..createdAtUtc = DateTime.utc(2026, 1, 1)
      ..supersededAtUtc = superseded;

void main() {
  group('revise', () {
    test('no trigger var → no change', () {
      final r = CopingPlanEngine.revise(
        vars: {'plan': 'Breathe for a minute'},
        active: const [],
      );
      expect(r.action, PlanAction.none);
    });

    test('unparseable trigger → no change, never throws', () {
      final r = CopingPlanEngine.revise(
        vars: {'trigger': 'stres', 'plan': 'Breathe for a minute'},
        active: const [],
      );
      expect(r.action, PlanAction.none);
    });

    test('no plan var → no change', () {
      final r = CopingPlanEngine.revise(
        vars: {'trigger': 'stress'},
        active: const [],
      );
      expect(r.action, PlanAction.none);
    });

    test('blank strategy → no change', () {
      final r = CopingPlanEngine.revise(
        vars: {'trigger': 'stress', 'plan': '   '},
        active: const [],
      );
      expect(r.action, PlanAction.none);
    });

    test('no active plan for the trigger → create', () {
      final r = CopingPlanEngine.revise(
        vars: {'trigger': 'stress', 'plan': 'Breathe for a minute'},
        active: [_plan(TriggerType.boredom, 'Move my body')],
      );
      expect(r.action, PlanAction.create);
      expect(r.trigger, TriggerType.stress);
      expect(r.strategy, 'Breathe for a minute');
      expect(r.supersededId, isNull);
    });

    test('carries the need var onto the revision', () {
      final r = CopingPlanEngine.revise(
        vars: {
          'trigger': 'stress',
          'plan': 'Breathe for a minute',
          'need': 'a break',
        },
        active: const [],
      );
      expect(r.need, 'a break');
    });

    test('blank need is dropped rather than stored empty', () {
      final r = CopingPlanEngine.revise(
        vars: {'trigger': 'stress', 'plan': 'Breathe for a minute', 'need': '  '},
        active: const [],
      );
      expect(r.need, isNull);
    });

    test('same strategy again → reaffirm, so history stays signal not churn', () {
      final r = CopingPlanEngine.revise(
        vars: {'trigger': 'stress', 'plan': '  breathe FOR a minute '},
        active: [_plan(TriggerType.stress, 'Breathe for a minute')],
      );
      expect(r.action, PlanAction.reaffirm);
      expect(r.supersededId, isNull);
    });

    test('different strategy → supersede, carrying the old id', () {
      final r = CopingPlanEngine.revise(
        vars: {'trigger': 'stress', 'plan': 'Reach out to someone'},
        active: [_plan(TriggerType.stress, 'Breathe for a minute', id: 7)],
      );
      expect(r.action, PlanAction.supersede);
      expect(r.supersededId, 7);
      expect(r.strategy, 'Reach out to someone');
    });

    test('a superseded plan does not block a new one', () {
      final r = CopingPlanEngine.revise(
        vars: {'trigger': 'stress', 'plan': 'Reach out to someone'},
        active: [
          _plan(TriggerType.stress, 'Breathe for a minute',
              id: 7, superseded: DateTime.utc(2026, 2, 1)),
        ],
      );
      expect(r.action, PlanAction.create);
      expect(r.supersededId, isNull);
    });
  });

  group('matchFor', () {
    test('no triggers → no match', () {
      expect(
        CopingPlanEngine.matchFor(const [], [_plan(TriggerType.stress, 'Breathe')]),
        isNull,
      );
    });

    test('no plan for any selected trigger → no match', () {
      expect(
        CopingPlanEngine.matchFor(
          [TriggerType.anger],
          [_plan(TriggerType.stress, 'Breathe')],
        ),
        isNull,
      );
    });

    test('ignores superseded plans', () {
      expect(
        CopingPlanEngine.matchFor(
          [TriggerType.stress],
          [
            _plan(TriggerType.stress, 'Breathe',
                superseded: DateTime.utc(2026, 2, 1)),
          ],
        ),
        isNull,
      );
    });

    test('several matches → picks quickTriggers order, not selection order', () {
      // quickTriggers lists stress before anger, so stress wins even though
      // anger was passed first.
      final match = CopingPlanEngine.matchFor(
        [TriggerType.anger, TriggerType.stress],
        [
          _plan(TriggerType.anger, 'Walk it off', id: 1),
          _plan(TriggerType.stress, 'Reach out to someone', id: 2),
        ],
      );
      expect(match?.strategy, 'Reach out to someone');
    });
  });

  group('cardFor', () {
    test('shows the matched plan on a resisted urge', () {
      final card = CopingPlanEngine.cardFor(
        outcome: Outcome.resisted,
        triggers: [TriggerType.stress],
        active: [_plan(TriggerType.stress, 'Reach out to someone')],
      );
      expect(card?.strategy, 'Reach out to someone');
    });

    test('stays quiet after a lapse — the plan must never read as a rebuke', () {
      final card = CopingPlanEngine.cardFor(
        outcome: Outcome.lapse,
        triggers: [TriggerType.stress],
        active: [_plan(TriggerType.stress, 'Reach out to someone')],
      );
      expect(card, isNull);
    });

    test('shows on a null outcome (nothing picked yet)', () {
      final card = CopingPlanEngine.cardFor(
        outcome: null,
        triggers: [TriggerType.stress],
        active: [_plan(TriggerType.stress, 'Reach out to someone')],
      );
      expect(card, isNotNull);
    });
  });
}
