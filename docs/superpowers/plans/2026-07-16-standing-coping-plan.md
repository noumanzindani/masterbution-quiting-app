# Standing Coping Plan Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Give the relapse reflection's if-then coping intention a durable home, revise it when the user reflects on the same trigger again, and surface it at the moment that trigger fires.

**Architecture:** A new `CopingPlan` Isar collection keyed by the existing `TriggerType` enum (the same vocabulary the urge log already records, which is what makes trigger-time matching possible). All decisions live in a pure, TDD'd `CopingPlanEngine`; a thin `CopingPlanRepo` only executes them. The coach flow gains two action tokens (`adjustPlan`, `addTodayIntention`) interpreted by `CoachFlowScreen`, exactly like the existing `saveReflection:` token.

**Tech Stack:** Flutter, `provider`, `isar_community` (+ `isar_community_generator`), `shared_preferences`. On-device only — no backend, no LLM.

**Spec:** `docs/superpowers/specs/2026-07-16-coping-plan-design.md`

## Global Constraints

- **Never reorder `TriggerType`.** Isar persists `@enumerated` fields by index (`lib/data/enums.dart:4-6`); reordering silently corrupts every stored `TrackerEvent`. Append only.
- **No test in this project opens Isar.** Testing is pure engines, JSON contracts, and widget tests over presenter widgets. Do not add an Isar-backed test.
- **Lapse-tolerant, non-shaming copy.** Superseding a plan is never framed as failure.
- **No ads in crisis/urge zones.** `copingPlan` must be added to `AdPolicy.noAdRoutes`.
- **Emergency mode is a forced, no-choice stepper.** Nothing may add a decision, a list, or a tap target to it.
- Match surrounding style. `flutter analyze` and `flutter test` must be green before any task is considered done.
- Re-run `dart run build_runner build --delete-conflicting-outputs` after editing any Isar collection; commit the regenerated `.g.dart`.

---

### Task 1: Taxonomy — append `tiredness`

**Files:**
- Modify: `lib/data/enums.dart:23-35`
- Modify: `lib/data/trigger_labels.dart:4-46`
- Test: `test/trigger_taxonomy_test.dart` (create)

**Interfaces:**
- Consumes: nothing.
- Produces: `TriggerType.tiredness`; `triggerLabel(TriggerType.tiredness) == 'Tiredness'`; `quickTriggers` contains `TriggerType.tiredness`.

**Why:** The relapse flow offers "I was tired or drained" but `TriggerType` has no such member. Adding it to the enum alone is not enough — the urge sheet only renders `quickTriggers`, so a trigger missing from that list can never be tagged, and a plan keyed to it could never match anything.

- [ ] **Step 1: Write the failing test**

Create `test/trigger_taxonomy_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/data/enums.dart';
import 'package:momentum/data/trigger_labels.dart';

/// The trigger taxonomy is a persistence contract: Isar stores TriggerType by
/// index, and the urge sheet can only offer what `quickTriggers` lists. These
/// tests pin both halves.
void main() {
  test('every TriggerType has a non-empty label', () {
    for (final t in TriggerType.values) {
      expect(triggerLabel(t), isNotEmpty, reason: '$t has no label');
    }
  });

  test('existing TriggerType indices are unchanged', () {
    // Isar persists @enumerated by index — inserting a value before any of
    // these silently rewrites the meaning of every stored TrackerEvent.
    expect(TriggerType.time.index, 0);
    expect(TriggerType.stress.index, 5);
    expect(TriggerType.boredom.index, 6);
    expect(TriggerType.loneliness.index, 7);
    expect(TriggerType.socialMedia.index, 11);
  });

  test('tiredness is appended after the original twelve', () {
    expect(TriggerType.tiredness.index, 12);
  });

  test('tiredness is taggable in the quick log sheet', () {
    // A trigger the sheet can't offer can never match a coping plan.
    expect(quickTriggers, contains(TriggerType.tiredness));
  });

  test('quickTriggers has no duplicates', () {
    expect(quickTriggers.toSet().length, quickTriggers.length);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/trigger_taxonomy_test.dart`
Expected: FAIL to compile — `The getter 'tiredness' isn't defined for the type 'TriggerType'`.

- [ ] **Step 3: Append `tiredness` to the enum**

In `lib/data/enums.dart`, add `tiredness` as the **last** member of `TriggerType`:

```dart
enum TriggerType {
  time,
  location,
  emotion,
  device,
  website,
  stress,
  boredom,
  loneliness,
  anger,
  rejection,
  alcohol,
  socialMedia,
  tiredness,
}
```

- [ ] **Step 4: Add the label and make it taggable**

In `lib/data/trigger_labels.dart`, add the case to the switch (the exhaustive switch will not compile without it) and add the trigger to `quickTriggers`:

```dart
    case TriggerType.socialMedia:
      return 'Social media';
    case TriggerType.tiredness:
      return 'Tiredness';
  }
}
```

```dart
const List<TriggerType> quickTriggers = [
  TriggerType.stress,
  TriggerType.boredom,
  TriggerType.loneliness,
  TriggerType.tiredness,
  TriggerType.anger,
  TriggerType.time,
  TriggerType.device,
  TriggerType.socialMedia,
  TriggerType.website,
  TriggerType.alcohol,
  TriggerType.rejection,
];
```

- [ ] **Step 5: Run tests to verify they pass**

Run: `flutter test test/trigger_taxonomy_test.dart && flutter analyze`
Expected: PASS, `No issues found!`

- [ ] **Step 6: Commit**

```bash
git add lib/data/enums.dart lib/data/trigger_labels.dart test/trigger_taxonomy_test.dart
git commit -m "feat: add TriggerType.tiredness and pin the taxonomy contract"
```

---

### Task 2: `CopingPlan` collection

**Files:**
- Create: `lib/data/collections/coping_plan.dart`
- Create (generated): `lib/data/collections/coping_plan.g.dart`
- Modify: `lib/data/isar_service.dart:1-45`

**Interfaces:**
- Consumes: `TriggerType` (Task 1).
- Produces: `class CopingPlan` with fields `id`, `trigger`, `strategy`, `createdAtUtc`, `supersededAtUtc`, `need`; `CopingPlanSchema`; the Isar accessor `isar.copingPlans`.

**Why:** "Replace, keep history" is modelled as a nullable `supersededAtUtc` rather than a delete — consistent with the app's principle of never destroying history.

There is no unit test for this task: no test in this project opens Isar. The gate is that codegen succeeds and analysis is clean.

- [ ] **Step 1: Create the collection**

Create `lib/data/collections/coping_plan.dart`:

```dart
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
```

- [ ] **Step 2: Run codegen**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: succeeds; `lib/data/collections/coping_plan.g.dart` is created.

- [ ] **Step 3: Register the schema**

In `lib/data/isar_service.dart`, add the import (alphabetical, after `cbt_entry.dart`):

```dart
import 'collections/coping_plan.dart';
```

and add the schema to the `Isar.open` list, after `SessionNoteSchema`:

```dart
        SleepEntrySchema,
        SessionNoteSchema,
        CopingPlanSchema,
      ],
```

- [ ] **Step 4: Verify analysis is clean**

Run: `flutter analyze && flutter test`
Expected: `No issues found!` and all existing tests pass.

- [ ] **Step 5: Commit**

```bash
git add lib/data/collections/coping_plan.dart lib/data/collections/coping_plan.g.dart lib/data/isar_service.dart
git commit -m "feat: add CopingPlan collection (11th) keyed by TriggerType"
```

---

### Task 3: `CopingPlanEngine` — all the decisions, pure

**Files:**
- Create: `lib/services/coping_plan_engine.dart`
- Test: `test/coping_plan_engine_test.dart` (create)

**Interfaces:**
- Consumes: `CopingPlan` (Task 2), `TriggerType` / `Outcome` (`lib/data/enums.dart`), `quickTriggers` (Task 1).
- Produces:
  - `enum PlanAction { none, create, supersede, reaffirm }`
  - `class PlanRevision` with `final PlanAction action; final TriggerType? trigger; final String? strategy; final String? need; final int? supersededId;`, plus the constant `PlanRevision.noChange`
  - `CopingPlanEngine.parseTrigger(String?) → TriggerType?`
  - `CopingPlanEngine.revise({required Map<String, String> vars, required List<CopingPlan> active}) → PlanRevision`
  - `CopingPlanEngine.matchFor(List<TriggerType> triggers, List<CopingPlan> active) → CopingPlan?`
  - `CopingPlanEngine.cardFor({required Outcome? outcome, required List<TriggerType> triggers, required List<CopingPlan> active}) → CopingPlan?`

**Why:** This is the whole feature's intelligence, and the repo layer has no test home. `cardFor` carries the non-shaming guardrail (never show the plan straight after a lapse) as a pure, tested rule rather than a widget condition a refactor could quietly drop.

- [ ] **Step 1: Write the failing tests**

Create `test/coping_plan_engine_test.dart`:

```dart
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
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/coping_plan_engine_test.dart`
Expected: FAIL to compile — `Target of URI doesn't exist: 'package:momentum/services/coping_plan_engine.dart'`.

- [ ] **Step 3: Write the engine**

Create `lib/services/coping_plan_engine.dart`:

```dart
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
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/coping_plan_engine_test.dart && flutter analyze`
Expected: PASS (19 tests), `No issues found!`

- [ ] **Step 5: Commit**

```bash
git add lib/services/coping_plan_engine.dart test/coping_plan_engine_test.dart
git commit -m "feat: add pure CopingPlanEngine (revise/matchFor/cardFor)"
```

---

### Task 4: `CopingPlanRepo` + wiring

**Files:**
- Create: `lib/data/repositories/coping_plan_repo.dart`
- Modify: `lib/config.dart:14-22` (import), `lib/config.dart:59-69` (singleton)
- Modify: `lib/services/app_init.dart:27-35`

**Interfaces:**
- Consumes: `CopingPlan` (Task 2), `PlanRevision` / `PlanAction` (Task 3).
- Produces: global `copingPlanRepo` with `active()`, `activeFor(TriggerType)`, `historyFor(TriggerType)`, `apply(PlanRevision, {DateTime? at})`, `edit(int id, String strategy)`, `remove(int id)`.

**Why:** The repo only executes what the engine decided — `apply` is a no-op for `none`/`reaffirm` so "should this write at all?" is never asked in two places. The supersede + insert happen in one `writeTxn` so a crash can't leave a trigger with zero active plans.

No unit test (no Isar tests in this project). Gate: analyze + existing suite.

- [ ] **Step 1: Create the repo**

Create `lib/data/repositories/coping_plan_repo.dart`:

```dart
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
```

- [ ] **Step 2: Add the global singleton**

In `lib/config.dart`, add the import alongside the other repositories:

```dart
import 'data/repositories/coping_plan_repo.dart';
```

and declare the singleton after `sessionNoteRepo`:

```dart
late SessionNoteRepo sessionNoteRepo;
late CopingPlanRepo copingPlanRepo;
```

- [ ] **Step 3: Assign it at startup**

In `lib/services/app_init.dart`, after the `sessionNoteRepo` line:

```dart
    sessionNoteRepo = SessionNoteRepo(isar);
    copingPlanRepo = CopingPlanRepo(isar);
```

- [ ] **Step 4: Verify**

Run: `flutter analyze && flutter test`
Expected: `No issues found!`, all tests pass.

- [ ] **Step 5: Commit**

```bash
git add lib/data/repositories/coping_plan_repo.dart lib/config.dart lib/services/app_init.dart
git commit -m "feat: add CopingPlanRepo and wire it into app startup"
```

---

### Task 5: `ReflectionComposer` — keep the journal readable

**Files:**
- Create: `lib/services/reflection_composer.dart`
- Test: `test/reflection_composer_test.dart` (create)

**Interfaces:**
- Consumes: `CopingPlanEngine.parseTrigger` (Task 3), `triggerLabel` (Task 1).
- Produces: `ReflectionComposer.compose(Map<String, String> vars) → String`.

**Why:** Task 6 changes the flow to emit enum names, so `vars['trigger']` becomes `"stress"` — and `CoachFlowScreen._composeReflection` renders vars verbatim, which would quietly degrade the journal from `"Trigger: Stress"` to `"Trigger: stress"`. Lifting the composition out of the widget's private method gives that copy a test home; the screen keeps only rendering.

- [ ] **Step 1: Write the failing test**

Create `test/reflection_composer_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/services/reflection_composer.dart';

void main() {
  test('composes labelled lines from the collected vars', () {
    final text = ReflectionComposer.compose({
      'feeling': 'Guilty or ashamed',
      'need': 'a break',
    });
    expect(text, 'Feeling: Guilty or ashamed\nWhat I hoped it would give me: a break');
  });

  test('skips empty answers so a mostly-skipped check-in still reads cleanly', () {
    final text = ReflectionComposer.compose({
      'feeling': 'Numb',
      'need': '   ',
      'plan': 'Move my body',
    });
    expect(text, "Feeling: Numb\nNext time I'll try: Move my body");
  });

  test('renders a trigger enum name as its human label', () {
    // The flow emits TriggerType names so plans can match logged urges — the
    // journal must not inherit that machine vocabulary.
    final text = ReflectionComposer.compose({'trigger': 'socialMedia'});
    expect(text, 'Trigger: Social media');
  });

  test('an unknown trigger value passes through verbatim rather than vanishing', () {
    final text = ReflectionComposer.compose({'trigger': 'stres'});
    expect(text, 'Trigger: stres');
  });

  test('an unknown key falls back to the raw key', () {
    final text = ReflectionComposer.compose({'custom': 'value'});
    expect(text, 'custom: value');
  });

  test('no vars → empty string', () {
    expect(ReflectionComposer.compose(const {}), isEmpty);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/reflection_composer_test.dart`
Expected: FAIL to compile — `Target of URI doesn't exist: 'package:momentum/services/reflection_composer.dart'`.

- [ ] **Step 3: Write the composer**

Create `lib/services/reflection_composer.dart`:

```dart
import '../data/trigger_labels.dart';
import 'coping_plan_engine.dart';

/// Turns a coach flow's collected variables into the readable, labelled body of
/// a saved reflection.
///
/// Pure, so the copy a user actually reads back months later is unit-tested
/// rather than buried in a widget's private method.
class ReflectionComposer {
  const ReflectionComposer._();

  /// Human labels for the collected variables, so a saved reflection reads
  /// naturally instead of as raw keys.
  static const _labels = {
    'feeling': 'Feeling',
    'trigger': 'Trigger',
    'need': 'What I hoped it would give me',
    'plan': "Next time I'll try",
    'mood': 'Today felt',
    'win': 'Something that went okay',
    'hard': 'What felt hard',
    'intention': "Tomorrow's intention",
  };

  /// Empty answers are skipped so a mostly-skipped daily check-in still reads
  /// cleanly. The `trigger` var holds a [TriggerType] *name* (the flow emits
  /// enum names so plans can be matched to logged urges) — it's rendered as its
  /// human label, falling back to the raw value if it doesn't parse.
  static String compose(Map<String, String> vars) {
    final lines = <String>[];
    for (final entry in vars.entries) {
      var value = entry.value.trim();
      if (value.isEmpty) continue;
      if (entry.key == 'trigger') {
        final trigger = CopingPlanEngine.parseTrigger(value);
        if (trigger != null) value = triggerLabel(trigger);
      }
      lines.add('${_labels[entry.key] ?? entry.key}: $value');
    }
    return lines.join('\n');
  }
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/reflection_composer_test.dart && flutter analyze`
Expected: PASS (6 tests), `No issues found!`

- [ ] **Step 5: Commit**

```bash
git add lib/services/reflection_composer.dart test/reflection_composer_test.dart
git commit -m "feat: extract ReflectionComposer with trigger-label rendering"
```

---

### Task 6: Flow JSON emits enum names + new nodes

**Files:**
- Modify: `assets/content/coach/flows/relapse_reflection.json:30-72`
- Modify: `test/coach_flows_test.dart:22,50-56,134-141`

**Interfaces:**
- Consumes: `CopingPlanEngine.parseTrigger` (Task 3), `TriggerType.tiredness` (Task 1).
- Produces: `relapse_reflection.json` emitting `{"trigger": "<TriggerType name>"}`; nodes `adjust` (action `adjustPlan`) and `echo`/`echo_add` (action `addTodayIntention`).

**Why:** Free strings can never be matched against a logged urge, which records enum indices. Two existing tests break here and must be updated in the same commit: `_validate` rejects unknown action tokens, and one test asserts `vars['trigger'] == 'Boredom'`.

The new action tokens are inert until Task 8 — `_runAction` ignores unrecognised tokens and proceeds, so this commit leaves the app working.

- [ ] **Step 1: Update the tests first**

In `test/coach_flows_test.dart`, add the import:

```dart
import 'package:momentum/services/coping_plan_engine.dart';
```

Extend the known-token check inside `_validate` (replacing the existing `known` line):

```dart
      final known = a.startsWith('saveReflection') ||
          a.startsWith('navigate:') ||
          a == 'adjustPlan' ||
          a == 'addTodayIntention';
      expect(known, isTrue, reason: '${n.id} has unknown action "$a"');
```

Update the variable expectation in the last test (`relapse_reflection collects the expected learning variables`):

```dart
    expect(s.vars['feeling'], 'Guilty or ashamed');
    expect(s.vars['trigger'], 'boredom');
    expect(s.vars['need'], 'a break');
```

And add a new contract test at the end of `main()`:

```dart
  test('every trigger effect names a real TriggerType', () {
    // A flow emitting "stres" would parse to nothing, silently create no plan,
    // and the user would never learn their reflection went nowhere — the same
    // silent-failure class achievements_content_test closes.
    flows.forEach((name, flow) {
      for (final node in flow.nodes) {
        for (final choice in node.choices) {
          final raw = choice.effect['trigger'];
          if (raw == null) continue;
          expect(
            CopingPlanEngine.parseTrigger(raw),
            isNotNull,
            reason: '$name: node "${node.id}" choice "${choice.label}" emits '
                'trigger "$raw", which is not a TriggerType',
          );
        }
      }
    });
  });
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/coach_flows_test.dart`
Expected: FAIL — `every trigger effect names a real TriggerType` fails on `"Boredom"`, and the variables test expects `'boredom'` but gets `'Boredom'`.

- [ ] **Step 3: Update the flow JSON**

In `assets/content/coach/flows/relapse_reflection.json`, replace the `trigger`, `save` and `offer`-preceding nodes so the sequence runs `plan → save → adjust → echo → (echo_add) → offer`. The `trigger` node becomes:

```json
    {
      "id": "trigger",
      "type": "choice",
      "text": "Looking back — what was going on just before?",
      "choices": [
        { "label": "I was bored", "next": "need", "effect": { "trigger": "boredom" } },
        { "label": "I felt stressed or anxious", "next": "need", "effect": { "trigger": "stress" } },
        { "label": "I was lonely", "next": "need", "effect": { "trigger": "loneliness" } },
        { "label": "I was tired or drained", "next": "need", "effect": { "trigger": "tiredness" } },
        { "label": "I was scrolling / online", "next": "need", "effect": { "trigger": "socialMedia" } },
        { "label": "Something else", "next": "need" }
      ]
    },
```

Note "Something else" now carries **no effect** — an unnameable trigger can't be matched to an urge anyway (the sheet only offers named ones), and omitting it lets the engine return "no plan" without needing a sentinel enum member.

Then replace the `save` node and insert `adjust`, `echo` and `echo_add` before the existing `offer` node:

```json
    {
      "id": "save",
      "type": "action",
      "text": "Saving what you learned…",
      "action": "saveReflection:relapse",
      "next": "adjust"
    },
    {
      "id": "adjust",
      "type": "action",
      "text": "Updating your plan…",
      "action": "adjustPlan",
      "next": "echo"
    },
    {
      "id": "echo",
      "type": "choice",
      "text": "Want to put a practice run on today's plan? Rehearsing it while things are calm is what makes it there when they aren't.",
      "choices": [
        { "label": "Yes, add it to today", "next": "echo_add" },
        { "label": "Not today", "next": "offer" }
      ]
    },
    {
      "id": "echo_add",
      "type": "action",
      "text": "Adding it to today…",
      "action": "addTodayIntention",
      "next": "offer"
    },
```

`adjustPlan` runs **after** `saveReflection:relapse` so a failed plan write can never cost the user their journal entry. Leave `offer`, `go_breathe`, `go_ground` and `end` exactly as they are.

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/coach_flows_test.dart && flutter analyze`
Expected: PASS — graph well-formed, flow terminates and saves, trigger vars parse.

- [ ] **Step 5: Commit**

```bash
git add assets/content/coach/flows/relapse_reflection.json test/coach_flows_test.dart
git commit -m "feat: relapse flow emits TriggerType names and offers a practice run"
```

---

### Task 7: `DailyPlanStore` extraction

**Files:**
- Create: `lib/services/daily_plan_store.dart`
- Modify: `lib/screens/coach/daily_planner_screen.dart:1-93`
- Test: `test/daily_plan_store_test.dart` (create)

**Interfaces:**
- Consumes: `prefs` + `session.dailyPlan` (`lib/config.dart`), `TimeBuckets.todayEpochDay()`.
- Produces: `class DailyPlanItem { String text; bool done; }` with `toJson()` / `DailyPlanItem.fromJson`; `DailyPlanStore.load() → List<DailyPlanItem>`; `DailyPlanStore.save(List<DailyPlanItem>) → Future<void>`; `DailyPlanStore.addIntention(String) → Future<void>`.

**Why:** Today's plan blob is read/written inside the screen's private `_load`/`_save`, so the coach flow's echo can't reach it. Extraction is scoped strictly to that — the planner's UI is untouched.

- [ ] **Step 1: Write the failing test**

Create `test/daily_plan_store_test.dart`:

```dart
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/config.dart';
import 'package:momentum/data/time_buckets.dart';
import 'package:momentum/services/daily_plan_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/daily_plan_store_test.dart`
Expected: FAIL to compile — `Target of URI doesn't exist: 'package:momentum/services/daily_plan_store.dart'`.

- [ ] **Step 3: Write the store**

Create `lib/services/daily_plan_store.dart`:

```dart
import 'dart:convert';

import '../config.dart';
import '../data/time_buckets.dart';

/// One intention on today's plan.
class DailyPlanItem {
  DailyPlanItem(this.text, this.done);

  final String text;
  bool done;

  Map<String, dynamic> toJson() => {'t': text, 'd': done};

  factory DailyPlanItem.fromJson(Map<String, dynamic> j) =>
      DailyPlanItem(j['t'] as String? ?? '', j['d'] as bool? ?? false);
}

/// Read/write access to today's plan.
///
/// A single current-day scalar that resets each morning, so per the
/// prefs-vs-Isar rule it lives in SharedPreferences as one JSON blob rather
/// than the database. Extracted from `DailyPlannerScreen` so the coach flow's
/// practice-run echo can append to the same list the planner renders.
class DailyPlanStore {
  const DailyPlanStore._();

  /// Today's items, or empty — a plan from a previous day starts fresh, and a
  /// corrupt blob degrades to empty rather than crashing the planner.
  static List<DailyPlanItem> load() {
    final raw = prefs.getString(session.dailyPlan);
    if (raw == null) return [];
    try {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      if ((data['day'] as num?)?.toInt() != TimeBuckets.todayEpochDay()) {
        return [];
      }
      final items = (data['items'] as List?) ?? const [];
      return items
          .map((e) => DailyPlanItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> save(List<DailyPlanItem> items) {
    final data = {
      'day': TimeBuckets.todayEpochDay(),
      'items': items.map((e) => e.toJson()).toList(),
    };
    return prefs.setString(session.dailyPlan, jsonEncode(data));
  }

  /// Append an intention to today, unless it's blank or already there.
  /// De-duping matters because the coach offers the practice run on every
  /// reflection — a rough week shouldn't stack five identical rows.
  static Future<void> addIntention(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    final items = load();
    final exists = items.any(
      (e) => e.text.trim().toLowerCase() == trimmed.toLowerCase(),
    );
    if (exists) return;
    items.add(DailyPlanItem(trimmed, false));
    await save(items);
  }
}
```

- [ ] **Step 4: Point the planner screen at the store**

In `lib/screens/coach/daily_planner_screen.dart`, delete the `dart:convert` import, the private `_PlanItem` class and the bodies of `_load`/`_save`, replacing them. The imports become:

```dart
import '../../config.dart';
import '../../services/daily_plan_store.dart';
import '../../widgets/ad/banner_ad_widget.dart';
```

The state's list and load/save become:

```dart
class _DailyPlannerScreenState extends State<DailyPlannerScreen> {
  final List<DailyPlanItem> _items = [];
  final _controller = TextEditingController();
```

```dart
  void _load() {
    final items = DailyPlanStore.load();
    if (items.isEmpty) return;
    setState(() => _items.addAll(items));
  }

  Future<void> _save() => DailyPlanStore.save(_items);
```

Then update the two remaining references to the old type: `_add` constructs `DailyPlanItem(t, false)`, and `_PlanRow`'s field becomes `final DailyPlanItem item;`.

- [ ] **Step 5: Run tests to verify they pass**

Run: `flutter test test/daily_plan_store_test.dart && flutter analyze && flutter test`
Expected: PASS (8 tests), `No issues found!`, whole suite green.

- [ ] **Step 6: Commit**

```bash
git add lib/services/daily_plan_store.dart lib/screens/coach/daily_planner_screen.dart test/daily_plan_store_test.dart
git commit -m "refactor: extract DailyPlanStore so the coach can reach today's plan"
```

---

### Task 8: Wire the action tokens into `CoachFlowScreen`

**Files:**
- Modify: `lib/screens/coach/coach_flow_screen.dart:1-137`

**Interfaces:**
- Consumes: `CopingPlanEngine.revise` (Task 3), `copingPlanRepo` (Task 4), `ReflectionComposer.compose` (Task 5), `DailyPlanStore.addIntention` (Task 7), the `adjustPlan` / `addTodayIntention` tokens (Task 6).
- Produces: nothing later tasks depend on.

**Why:** This closes the loop — after this task a relapse reflection actually writes a standing plan. `_runAction` becomes `Future<String?>`: when it returns text, `_advanceTo` appends it as a coach turn, so a supersede *says so* rather than changing behind the user's back. The flow JSON still can't branch on prior state; the apparent memory lives entirely in the action's return value, and `CoachRunner`'s 11 tests stay untouched.

- [ ] **Step 1: Replace the imports and drop the local labels**

In `lib/screens/coach/coach_flow_screen.dart`, the imports become:

```dart
import '../../config.dart';
import '../../content/coach_models.dart';
import '../../data/enums.dart';
import '../../data/trigger_labels.dart';
import '../../services/coach_runner.dart';
import '../../services/coping_plan_engine.dart';
import '../../services/daily_plan_store.dart';
import '../../services/reflection_composer.dart';
import '../../widgets/primary_button.dart';
```

Delete the `static const _labels = {...}` map (lines 33-42) and the `_composeReflection` method (lines 129-137) — both now live in `ReflectionComposer`.

- [ ] **Step 2: Make actions able to speak**

Replace `_advanceTo` so an action's returned text becomes a coach turn:

```dart
  Future<void> _advanceTo(CoachState s) async {
    setState(() => _state = s);
    final node = CoachRunner.current(_flow!, s);
    if (node.type == 'action') {
      final said = await _runAction(node);
      if (!mounted) return;
      if (said != null) {
        setState(() => _turns.add(_Turn.coach(said)));
        _scrollToEnd();
      }
      await _advanceTo(CoachRunner.proceed(_flow!, s));
      return;
    }
    setState(() => _turns.add(_Turn.coach(node.text)));
    _scrollToEnd();
  }
```

- [ ] **Step 3: Implement the two new tokens**

Replace `_runAction` and `_saveReflection` with:

```dart
  // --- Action nodes (the only place side-effects happen) --------------------

  /// Runs a node's `action` token. Returns text for the coach to say next, or
  /// null to stay quiet. Never throws: a storage failure must not derail a
  /// conversation someone is having at a raw moment, so it degrades to silence
  /// the way AdService and NotificationService do.
  Future<String?> _runAction(CoachNode node) async {
    final a = node.action ?? '';
    try {
      if (a.startsWith('saveReflection')) {
        await _saveReflection(a);
        return null;
      }
      if (a == 'adjustPlan') {
        return await _adjustPlan();
      }
      if (a == 'addTodayIntention') {
        return await _addTodayIntention();
      }
      if (a.startsWith('navigate:')) {
        await Navigator.pushNamed(context, a.substring('navigate:'.length));
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  Future<void> _saveReflection(String token) async {
    final kind = token.endsWith(':relapse')
        ? JournalKind.relapseReflection
        : JournalKind.dailyReflection;
    final text = ReflectionComposer.compose(_state.vars);
    if (text.isEmpty) return;
    await journalRepo.add(
      kind: kind,
      text: text,
      emotion: _state.vars['feeling'] ?? _state.vars['mood'],
    );
  }

  /// Records the if-then coping plan this reflection just produced, and says
  /// what changed — a plan that quietly rewrites itself teaches nothing.
  Future<String?> _adjustPlan() async {
    final active = await copingPlanRepo.active();
    final revision = CopingPlanEngine.revise(vars: _state.vars, active: active);
    if (revision.action == PlanAction.none) return null;

    // Grab the outgoing strategy BEFORE applying, so the coach can name what
    // it replaced.
    String? previous;
    for (final p in active) {
      if (p.id == revision.supersededId) previous = p.strategy;
    }

    await copingPlanRepo.apply(revision);

    final trigger = triggerLabel(revision.trigger!).toLowerCase();
    return switch (revision.action) {
      PlanAction.create =>
        'Saved — when $trigger shows up, your plan is: ${revision.strategy}.',
      PlanAction.supersede =>
        'Updated your plan for $trigger — ${revision.strategy} replaces '
            '${previous ?? 'what was there before'}.',
      PlanAction.reaffirm =>
        "That's still your plan for $trigger. Knowing what works is its own kind of progress.",
      PlanAction.none => null,
    };
  }

  Future<String?> _addTodayIntention() async {
    final strategy = (_state.vars['plan'] ?? '').trim();
    if (strategy.isEmpty) return null;
    await DailyPlanStore.addIntention('Practice: $strategy');
    return "It's on today's plan.";
  }
```

- [ ] **Step 4: Verify**

Run: `flutter analyze && flutter test`
Expected: `No issues found!`, whole suite green.

- [ ] **Step 5: Commit**

```bash
git add lib/screens/coach/coach_flow_screen.dart
git commit -m "feat: adjustPlan + addTodayIntention action tokens close the reflection loop"
```

---

### Task 9: Plan screen

**Files:**
- Create: `lib/screens/plan/coping_plan_body.dart`
- Create: `lib/screens/plan/coping_plan_screen.dart`
- Modify: `lib/routes/route_name.dart` (coach section), `lib/routes/route_method.dart` (import + map)
- Modify: `lib/services/ad_policy.dart:19-30`
- Modify: `lib/screens/shell/tools_tab_screen.dart:16-24`
- Test: `test/coping_plan_body_test.dart` (create), `test/tools_tab_body_test.dart` (modify)

**Interfaces:**
- Consumes: `CopingPlan` (Task 2), `copingPlanRepo` (Task 4), `triggerLabel` (Task 1).
- Produces: route `copingPlan`; `CopingPlanBody({required List<CopingPlan> plans, required void Function(CopingPlan) onEdit, required void Function(CopingPlan) onDelete, required void Function(CopingPlan) onHistory})`.

**Why:** Split presenter from screen so the body is widget-testable without Isar — the same pattern the bottom-nav shell used (`HomeTabBody`, `ToolsTabBody`). `CopingPlan` is a plain Dart object until it's persisted, so a test can construct one freely.

Follow the established split exactly: the **body** resolves its own theme with `appColor(context)` (as `ToolsTabBody` does) and only leaf widgets take a `theme` parameter. Tests therefore wrap in a `ThemeService` provider, matching `test/tools_tab_body_test.dart`.

The history view is what makes keeping superseded rows worth anything — it's where "breathing didn't hold for stress; reaching out did" becomes visible.

`copingPlan` goes in `AdPolicy.noAdRoutes` **not** because the screen is itself a crisis surface, but because the panic hub (Task 12) links straight to it — a banner here would sit one tap from the panic button.

- [ ] **Step 1: Write the failing test**

Create `test/coping_plan_body_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:momentum/common/theme/theme_service.dart';
import 'package:momentum/data/collections/coping_plan.dart';
import 'package:momentum/data/enums.dart';
import 'package:momentum/screens/plan/coping_plan_body.dart';

CopingPlan _plan(TriggerType t, String strategy, {int id = 1}) => CopingPlan()
  ..id = id
  ..trigger = t
  ..strategy = strategy
  ..createdAtUtc = DateTime.utc(2026, 3, 4);

Future<void> _pump(
  WidgetTester tester,
  List<CopingPlan> plans, {
  void Function(CopingPlan)? onEdit,
  void Function(CopingPlan)? onDelete,
  void Function(CopingPlan)? onHistory,
}) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  await tester.pumpWidget(
    ChangeNotifierProvider(
      create: (_) => ThemeService(prefs),
      child: MaterialApp(
        home: Scaffold(
          body: CopingPlanBody(
            plans: plans,
            onEdit: onEdit ?? (_) {},
            onDelete: onDelete ?? (_) {},
            onHistory: onHistory ?? (_) {},
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('renders each plan as trigger → strategy', (tester) async {
    await _pump(tester, [
      _plan(TriggerType.stress, 'Reach out to someone', id: 1),
      _plan(TriggerType.boredom, 'Move my body', id: 2),
    ]);
    expect(find.text('Stress'), findsOneWidget);
    expect(find.text('Reach out to someone'), findsOneWidget);
    expect(find.text('Boredom'), findsOneWidget);
    expect(find.text('Move my body'), findsOneWidget);
  });

  testWidgets('empty state explains where plans come from, without blame',
      (tester) async {
    await _pump(tester, const []);
    expect(find.textContaining('reflection'), findsOneWidget);
  });

  testWidgets('edit and delete report the plan they act on', (tester) async {
    CopingPlan? edited;
    CopingPlan? deleted;
    await _pump(
      tester,
      [_plan(TriggerType.stress, 'Reach out to someone', id: 9)],
      onEdit: (p) => edited = p,
      onDelete: (p) => deleted = p,
    );
    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pump();
    expect(edited?.id, 9);

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pump();
    expect(deleted?.id, 9);
  });

  testWidgets('tapping a plan asks for its history', (tester) async {
    CopingPlan? asked;
    await _pump(
      tester,
      [_plan(TriggerType.stress, 'Reach out to someone', id: 4)],
      onHistory: (p) => asked = p,
    );
    await tester.tap(find.text('Reach out to someone'));
    await tester.pump();
    expect(asked?.id, 4);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/coping_plan_body_test.dart`
Expected: FAIL to compile — `Target of URI doesn't exist: 'package:momentum/screens/plan/coping_plan_body.dart'`.

- [ ] **Step 3: Write the presenter**

Create `lib/screens/plan/coping_plan_body.dart`:

```dart
import '../../config.dart';
import '../../data/collections/coping_plan.dart';
import '../../data/trigger_labels.dart';

/// The plan list, as a pure presenter: it renders whatever [plans] it's handed
/// and reports taps back. Split from [CopingPlanScreen] so it's widget-testable
/// without opening Isar — the same split the tab bodies use.
class CopingPlanBody extends StatelessWidget {
  const CopingPlanBody({
    super.key,
    required this.plans,
    required this.onEdit,
    required this.onDelete,
    required this.onHistory,
  });

  final List<CopingPlan> plans;
  final void Function(CopingPlan) onEdit;
  final void Function(CopingPlan) onDelete;
  final void Function(CopingPlan) onHistory;

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    if (plans.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            "No plans yet. After a slip, the reflection helps you pick one "
            "thing to try next time that trigger shows up — it'll appear here.",
            textAlign: TextAlign.center,
            style: appCss.body14.textColor(theme.lightText),
          ),
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        Text(
          'When one of these shows up, this is what you decided to try first.',
          style: appCss.body14.textColor(theme.lightText),
        ),
        const SizedBox(height: 20),
        for (final plan in plans)
          _PlanCard(
            plan: plan,
            theme: theme,
            onEdit: () => onEdit(plan),
            onDelete: () => onDelete(plan),
            onHistory: () => onHistory(plan),
          ),
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.plan,
    required this.theme,
    required this.onEdit,
    required this.onDelete,
    required this.onHistory,
  });

  final CopingPlan plan;
  final AppTheme theme;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onHistory;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: theme.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.stroke),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onHistory,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(triggerLabel(plan.trigger),
                          style: appCss.label12.textColor(theme.primary)),
                      const SizedBox(height: 4),
                      Text(plan.strategy,
                          style: appCss.titleSemi16.textColor(theme.darkText)),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit_outlined,
                      color: theme.lightText, size: 20),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: Icon(Icons.close_rounded,
                      color: theme.lightText, size: 20),
                  onPressed: onDelete,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/coping_plan_body_test.dart`
Expected: PASS (3 tests).

- [ ] **Step 5: Write the screen**

Create `lib/screens/plan/coping_plan_screen.dart`:

```dart
import '../../config.dart';
import '../../data/collections/coping_plan.dart';
import '../../data/trigger_labels.dart';
import 'coping_plan_body.dart';

/// Your standing coping plans. NO-AD route: the panic hub links straight here,
/// so a banner would sit one tap from the panic button.
class CopingPlanScreen extends StatefulWidget {
  const CopingPlanScreen({super.key});

  @override
  State<CopingPlanScreen> createState() => _CopingPlanScreenState();
}

class _CopingPlanScreenState extends State<CopingPlanScreen> {
  List<CopingPlan> _plans = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final plans = await copingPlanRepo.active();
    if (!mounted) return;
    setState(() {
      _plans = plans;
      _loading = false;
    });
  }

  Future<void> _edit(CopingPlan plan) async {
    final controller = TextEditingController(text: plan.strategy);
    final theme = appColor(context);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: theme.cardBg,
        title: Text('When ${triggerLabel(plan.trigger).toLowerCase()} shows up',
            style: appCss.titleSemi16.textColor(theme.darkText)),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: appCss.body14.textColor(theme.darkText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (result == null || result.isEmpty) return;
    await copingPlanRepo.edit(plan.id, result);
    await _load();
  }

  Future<void> _delete(CopingPlan plan) async {
    await copingPlanRepo.remove(plan.id);
    await _load();
  }

  /// What you've tried for this trigger over time. Superseded strategies are
  /// kept precisely so this reads as evidence — "breathing didn't hold for
  /// stress; reaching out did" — rather than a plan appearing from nowhere.
  Future<void> _history(CopingPlan plan) async {
    final history = await copingPlanRepo.historyFor(plan.trigger);
    if (!mounted) return;
    final theme = appColor(context);
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: theme.scaffoldBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('When ${triggerLabel(plan.trigger).toLowerCase()} shows up',
                  style: appCss.titleSemi18.textColor(theme.darkText)),
              const SizedBox(height: 16),
              for (final h in history)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        h.supersededAtUtc == null
                            ? Icons.check_circle_rounded
                            : Icons.history_rounded,
                        size: 18,
                        color: h.supersededAtUtc == null
                            ? theme.primary
                            : theme.lightText,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          h.supersededAtUtc == null
                              ? '${h.strategy} — your plan now'
                              : '${h.strategy} — until '
                                  '${h.supersededAtUtc!.toLocal().year}-'
                                  '${h.supersededAtUtc!.toLocal().month.toString().padLeft(2, '0')}-'
                                  '${h.supersededAtUtc!.toLocal().day.toString().padLeft(2, '0')}',
                          style: appCss.body14.textColor(
                            h.supersededAtUtc == null
                                ? theme.darkText
                                : theme.lightText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBg,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBg,
        title: Text('My coping plans',
            style: appCss.headingBold22.textColor(theme.darkText)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : CopingPlanBody(
              plans: _plans,
              onEdit: _edit,
              onDelete: _delete,
              onHistory: _history,
            ),
    );
  }
}
```

- [ ] **Step 6: Register the route and deny ads on it**

In `lib/routes/route_name.dart`, add to the coach section:

```dart
  final String dailyPlanner = 'dailyPlanner';
  final String copingPlan = 'copingPlan';
```

In `lib/routes/route_method.dart`, add the import:

```dart
import '../screens/plan/coping_plan_screen.dart';
```

and the mapping, next to `dailyPlanner`:

```dart
        _r.dailyPlanner: (_) => const DailyPlannerScreen(),
        _r.copingPlan: (_) => const CopingPlanScreen(),
```

In `lib/services/ad_policy.dart`, add to `noAdRoutes`:

```dart
      r.relapseReflection,
      r.copingPlan,
      r.lock,
```

- [ ] **Step 7: Surface it in the Tools tab**

In `lib/screens/shell/tools_tab_screen.dart`, add a `NavRow` after the "Daily planner" row:

```dart
        const SizedBox(height: 10),
        NavRow(
          icon: Icons.shield_moon_rounded,
          title: 'My coping plans',
          subtitle: 'What you decided to try when a trigger shows up',
          route: routeName.copingPlan,
          theme: theme,
        ),
```

- [ ] **Step 8: Update the Tools tab test for the new row**

`test/tools_tab_body_test.dart` asserts the presence of six destinations without asserting a count, so it will still pass — but it would silently stop describing the tab. Update it: rename the test to `lists all seven tool destinations and navigates on tap`, add the route to its map:

```dart
            r.dailyPlanner: (_) => const Scaffold(body: Text('planner')),
            r.copingPlan: (_) => const Scaffold(body: Text('plans')),
```

and add the expectation:

```dart
    expect(find.text('My coping plans'), findsOneWidget);
```

- [ ] **Step 9: Verify**

Run: `flutter analyze && flutter test`
Expected: `No issues found!`, whole suite green (4 new body tests).

- [ ] **Step 10: Commit**

```bash
git add lib/screens/plan/ lib/routes/route_name.dart lib/routes/route_method.dart lib/services/ad_policy.dart lib/screens/shell/tools_tab_screen.dart test/coping_plan_body_test.dart test/tools_tab_body_test.dart
git commit -m "feat: add the coping plan screen on a no-ad route"
```

---

### Task 10: Urge log shows the matched plan

**Files:**
- Modify: `lib/screens/home/log_sheets.dart:1-6,100-190`

**Interfaces:**
- Consumes: `CopingPlanEngine.cardFor` (Task 3), `copingPlanRepo.active()` (Task 4).
- Produces: nothing later tasks depend on.

**Why:** The highest-value surface — the intention arrives at the moment it was written for. The lapse suppression is already pinned by `cardFor`'s tests; the widget only renders what the engine returns.

- [ ] **Step 1: Load active plans when the sheet opens**

In `lib/screens/home/log_sheets.dart`, add the imports:

```dart
import '../../data/collections/coping_plan.dart';
import '../../services/coping_plan_engine.dart';
```

In `_LogUrgeSheetState`, add the field and load it in `initState`:

```dart
class _LogUrgeSheetState extends State<_LogUrgeSheet> {
  int _intensity = 5;
  Outcome? _outcome;
  final Set<TriggerType> _triggers = {};
  final _noteController = TextEditingController();
  bool _saving = false;
  List<CopingPlan> _activePlans = const [];

  @override
  void initState() {
    super.initState();
    _loadPlans();
  }

  Future<void> _loadPlans() async {
    final plans = await copingPlanRepo.active();
    if (!mounted) return;
    setState(() => _activePlans = plans);
  }
```

- [ ] **Step 2: Render the card under the trigger chips**

In `_LogUrgeSheetState.build`, after the trigger `Wrap` and before the `_NoteField`, insert:

```dart
        _PlanReminder(
          plan: CopingPlanEngine.cardFor(
            outcome: _outcome,
            triggers: _triggers.toList(),
            active: _activePlans,
          ),
          theme: theme,
        ),
```

- [ ] **Step 3: Add the widget**

At the end of `lib/screens/home/log_sheets.dart`:

```dart
/// The standing coping plan for whatever trigger was just tagged — the whole
/// point of writing one down. Renders nothing when there's no match, and the
/// engine (not this widget) decides to stay quiet after a lapse.
class _PlanReminder extends StatelessWidget {
  const _PlanReminder({required this.plan, required this.theme});

  final CopingPlan? plan;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    final p = plan;
    if (p == null) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.primarySoft,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(Icons.shield_moon_rounded, color: theme.primary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Your plan for ${triggerLabel(p.trigger).toLowerCase()}: ${p.strategy}',
              style: appCss.medium14.textColor(theme.primary),
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Verify**

Run: `flutter analyze && flutter test`
Expected: `No issues found!`, whole suite green.

- [ ] **Step 5: Commit**

```bash
git add lib/screens/home/log_sheets.dart
git commit -m "feat: surface the matched coping plan in the urge log"
```

---

### Task 11: Carry the trigger into emergency mode

**Files:**
- Modify: `lib/screens/home/log_sheets.dart:8-22,118-132`
- Modify: `lib/screens/home/home_screen.dart:258-267`
- Modify: `lib/screens/emergency/emergency_mode_screen.dart:1-30,130-150,371-380`

**Interfaces:**
- Consumes: `CopingPlanEngine.matchFor` (Task 3), `copingPlanRepo` (Task 4).
- Produces: `showLogUrgeSheet(BuildContext) → Future<UrgeLogResult?>` where `class UrgeLogResult { final int intensity; final List<TriggerType> triggers; }`.

**Why:** The reflect step can only name the trigger if the sheet passes it along — this is the one existing signature the feature changes. The line is a **statement, not a menu**: emergency mode is a forced no-choice stepper by design, and nothing here may add a decision.

- [ ] **Step 1: Widen the sheet's result**

In `lib/screens/home/log_sheets.dart`, add the result type above `showLogUrgeSheet` and change its signature:

```dart
/// What the urge sheet collected. The triggers ride along so the caller can
/// match a standing coping plan without re-asking.
class UrgeLogResult {
  const UrgeLogResult({required this.intensity, required this.triggers});

  final int intensity;
  final List<TriggerType> triggers;
}

/// Opens the "log an urge" sheet. Captures intensity, outcome and optional
/// triggers/note, then writes a [TrackerEvent] via the dashboard provider.
/// Resolves once saved, so the caller can offer emergency mode on a
/// peak-intensity urge and name the trigger there; `null` if dismissed.
Future<UrgeLogResult?> showLogUrgeSheet(BuildContext context) {
  final provider = context.read<DashboardProvider>();
  return _showSheet<UrgeLogResult>(
    context,
    ChangeNotifierProvider.value(
      value: provider,
      child: const _LogUrgeSheet(),
    ),
  );
}
```

and in `_LogUrgeSheetState._save`, return the record instead of the bare int:

```dart
    if (!mounted) return;
    Navigator.pop(
      context,
      UrgeLogResult(intensity: _intensity, triggers: _triggers.toList()),
    );
```

- [ ] **Step 2: Pass the matched trigger on escalation**

In `lib/screens/home/home_screen.dart`, replace `_logUrge`:

```dart
  Future<void> _logUrge(BuildContext context) async {
    final result = await showLogUrgeSheet(context);
    // A peak-intensity urge escalates into the guided emergency sequence — the
    // same tested rule the panic hub uses (EmergencyFlow.shouldEscalate). The
    // matched trigger rides along so the reflect step can name the plan.
    if (result == null ||
        !EmergencyFlow.shouldEscalate(result.intensity) ||
        !context.mounted) {
      return;
    }
    final active = await copingPlanRepo.active();
    final plan = CopingPlanEngine.matchFor(result.triggers, active);
    if (!context.mounted) return;
    await Navigator.pushNamed(
      context,
      routeName.emergencyMode,
      arguments: plan?.trigger,
    );
  }
```

Add the imports to `home_screen.dart` if absent:

```dart
import '../../services/coping_plan_engine.dart';
```

- [ ] **Step 3: Show the line in the reflect step**

In `lib/screens/emergency/emergency_mode_screen.dart`, add the import:

```dart
import '../../data/collections/coping_plan.dart';
```

In `_EmergencyModeScreenState`, resolve the plan from the route argument:

```dart
  CopingPlan? _plan;
  bool _planLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_planLoaded) return;
    _planLoaded = true;
    final trigger = ModalRoute.of(context)?.settings.arguments as TriggerType?;
    if (trigger == null) return;
    copingPlanRepo.activeFor(trigger).then((plan) {
      if (mounted) setState(() => _plan = plan);
    });
  }
```

Thread it into the step view — update the `_StepView` construction in `build`:

```dart
                      _StepView(
                        step: step,
                        reflect: _reflect,
                        plan: _plan,
                        theme: theme,
                      ),
```

and `_StepView` itself:

```dart
class _StepView extends StatelessWidget {
  const _StepView({
    required this.step,
    required this.reflect,
    required this.plan,
    required this.theme,
  });
  final EmergencyStep step;
  final TextEditingController reflect;
  final CopingPlan? plan;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return switch (step) {
      EmergencyStep.breathe => _BreatheStep(theme: theme),
      EmergencyStep.ground => _GroundStep(theme: theme),
      EmergencyStep.surf => _SurfStep(theme: theme),
      EmergencyStep.reflect =>
        _ReflectStep(controller: reflect, plan: plan, theme: theme),
      EmergencyStep.close => _CloseStep(theme: theme),
    };
  }
}
```

Finally, in `_ReflectStep`, accept the plan and render **one line, no tap targets** above the text field:

```dart
class _ReflectStep extends StatelessWidget {
  const _ReflectStep({
    required this.controller,
    required this.plan,
    required this.theme,
  });
  final TextEditingController controller;

  /// The standing plan for the trigger that got them here, if any. Rendered as
  /// a *statement* — emergency mode is a forced no-choice sequence, so this
  /// reminds without asking anything.
  final CopingPlan? plan;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    final p = plan;
    return _StepFrame(
      icon: Icons.edit_note_rounded,
      title: 'What\'s going on for you?',
      body: p == null
          ? 'Optional — just a line or two. What set this off, what you need '
              'right now.'
          : 'Last time ${triggerLabel(p.trigger).toLowerCase()} hit, you '
              'planned to ${p.strategy.toLowerCase()}.',
      theme: theme,
      child: TextField(
        controller: controller,
        maxLines: 4,
        style: appCss.body14.textColor(theme.darkText),
        decoration: InputDecoration(
          hintText: 'Type here if it helps…',
          hintStyle: appCss.label12.textColor(theme.lightText),
          filled: true,
          fillColor: theme.scaffoldBg,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.stroke),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.stroke),
          ),
        ),
      ),
    );
  }
}
```

Add `import '../../data/trigger_labels.dart';` to the screen if absent.

- [ ] **Step 4: Verify**

Run: `flutter analyze && flutter test`
Expected: `No issues found!`, whole suite green. Any other caller of `showLogUrgeSheet` must be updated — grep to confirm:

Run: `grep -rn "showLogUrgeSheet" lib/`
Expected: only `log_sheets.dart` (definition) and `home_screen.dart` (call).

- [ ] **Step 5: Commit**

```bash
git add lib/screens/home/log_sheets.dart lib/screens/home/home_screen.dart lib/screens/emergency/emergency_mode_screen.dart
git commit -m "feat: name the standing plan in emergency mode's reflect step"
```

---

### Task 12: Panic hub card

**Files:**
- Modify: `lib/screens/emergency/panic_screen.dart`

**Interfaces:**
- Consumes: `copingPlanRepo.active()` (Task 4), route `copingPlan` (Task 9).
- Produces: nothing.

**Why:** The panic hub is already a menu, so one more calm option adds no decision burden — unlike emergency mode. This is the link that forced `copingPlan` onto the no-ad denylist in Task 9.

- [ ] **Step 1: Make the screen stateful and load the count**

`PanicScreen` is currently a `StatelessWidget`. Convert it, keeping its existing `ListView` children intact:

```dart
class PanicScreen extends StatefulWidget {
  const PanicScreen({super.key});

  @override
  State<PanicScreen> createState() => _PanicScreenState();
}

class _PanicScreenState extends State<PanicScreen> {
  int _planCount = 0;

  @override
  void initState() {
    super.initState();
    copingPlanRepo.active().then((plans) {
      if (mounted) setState(() => _planCount = plans.length);
    });
  }
```

- [ ] **Step 2: Add the card**

Add to the `ListView`'s children, after the existing `_EscalateCard`:

```dart
          if (_planCount > 0)
            _PlanCard(count: _planCount, theme: theme),
```

and add the widget at the end of the file:

```dart
/// A quiet pointer to the plans you already made for moments like this. The hub
/// is a menu by design, so this is one more option — never a demand.
class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.count, required this.theme});

  final int count;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: theme.cardBg,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => Navigator.pushNamed(context, routeName.copingPlan),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.shield_moon_rounded, color: theme.primary),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Your coping plans',
                          style: appCss.titleSemi16.textColor(theme.darkText)),
                      const SizedBox(height: 2),
                      Text(
                        count == 1
                            ? 'One thing you decided to try'
                            : '$count things you decided to try',
                        style: appCss.body14.textColor(theme.lightText),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: theme.lightText),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 3: Verify**

Run: `flutter analyze && flutter test`
Expected: `No issues found!`, whole suite green.

- [ ] **Step 4: Commit**

```bash
git add lib/screens/emergency/panic_screen.dart
git commit -m "feat: link the coping plans from the panic hub"
```

---

### Task 13: Full verification + docs

**Files:**
- Modify: `hand.md` (§4 engines, §7 feature map, §8 status)

**Why:** `hand.md` is this repo's stated source of truth for "where the project is". A feature that isn't in it doesn't exist to the next session.

- [ ] **Step 1: Run the whole suite**

Run: `flutter analyze && flutter test`
Expected: `No issues found!`; all tests pass (161 existing + ~40 new).

- [ ] **Step 2: Confirm codegen is committed and clean**

Run: `dart run build_runner build --delete-conflicting-outputs && git status --porcelain`
Expected: no unstaged changes to `lib/data/collections/coping_plan.g.dart` — if there are, the generated file wasn't committed in Task 2.

- [ ] **Step 3: Update `hand.md`**

In §4 (the engines table/list), add:

```markdown
- **`CopingPlanEngine`** (`lib/services/coping_plan_engine.dart`, 19 tests) — the standing coping
  plan's decisions: `revise` (create / supersede / reaffirm, keyed by `TriggerType`), `matchFor`
  (which plan to surface for a logged urge, in `quickTriggers` order), and `cardFor` (`matchFor`
  except never right after a lapse — showing the plan there would read as a rebuke).
```

In §7, add a new subsection:

```markdown
### I. Standing coping plan (closes the Phase-4 reflection→plan gap)

The relapse flow already captured an if-then implementation intention (trigger + strategy) and
flattened it into journal prose, where it could never reach the user mid-urge. Now it writes a
`CopingPlan` (11th Isar collection) keyed by `TriggerType` — the same vocabulary the urge log
records, which is what makes trigger-time matching possible. One active plan per trigger; a later
reflection picking a different strategy stamps `supersededAtUtc` on the old row rather than
deleting it, so "breathing didn't hold for stress; reaching out did" stays legible.

`TriggerType` gained `tiredness` (appended — never reorder: Isar persists by index) and the flow
JSON now emits enum names, so `ReflectionComposer` renders `triggerLabel()` to keep journals
readable. Two new action tokens: `adjustPlan` (engine → repo, and the coach *says* what changed)
and `addTodayIntention` (an opt-in "Practice: …" row via the extracted `DailyPlanStore`).

Surfaces: the urge log's matched card (suppressed after a lapse), the plan screen (route
`copingPlan`, **no-ad — the panic hub links straight to it**), the panic hub card, and a single
statement in emergency mode's `reflect` step (never a menu — the forced stepper stays forced).
`showLogUrgeSheet` widened to `Future<UrgeLogResult?>` to carry the trigger through.
```

In §8, under Phase 4, replace the "Optional polish" note with:

```markdown
*Optional polish:* more coach flows. (The relapse-analysis → plan-adjustment step is **done** — see §7.I.)
```

- [ ] **Step 4: Commit**

```bash
git add hand.md
git commit -m "docs: record the standing coping plan in hand.md"
```

---

## Deferred (do not build here)

- Strategy → tool route linking ("do it now" from a plan card)
- Localizing `triggerLabel()` (it is English-only; its "localized in Phase 7" comment is stale)
- Plan suggestions derived from `RiskEngine` patterns
- Any further change to emergency mode
