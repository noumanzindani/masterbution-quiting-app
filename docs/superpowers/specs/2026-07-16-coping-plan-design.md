# Standing coping plan — closing the relapse-reflection → plan loop

**Date:** 2026-07-16
**Status:** approved design, ready for an implementation plan

## Problem

The relapse-reflection flow already captures a textbook **implementation intention** — a
`trigger` ("Stress") paired with a `plan` ("Breathe for a minute") — and then throws the
structure away. `CoachFlowScreen._composeReflection` flattens both into prose
(`"Next time I'll try: Breathe for a minute"`) and stores it as a `JournalEntry`.

The failure isn't that the app "doesn't adjust the plan". It's that the plan is stored in a
**shape and place that cannot reach the user when it matters**. Implementation intentions work
precisely because they are retrieved *at the moment the trigger occurs*; journals are read in
calm reflection, never mid-urge.

This design gives that intention a durable home, revises it when the user reflects on the same
trigger again, and surfaces it where the trigger actually shows up.

## Constraints

- On-device only. No backend, no LLM — the revision rule is plain rule-based logic.
- Lapse-tolerant and non-shaming (`hand.md` §6). Superseding a plan is never framed as failure.
- No ads in crisis/urge zones.
- Emergency mode is a **forced, no-choice stepper**. Nothing here may add a decision to it.

## Decisions

| Question | Decision |
|---|---|
| What is "the plan"? | A **new durable standing plan** (if-then rules), plus an optional echo into today's checklist. Not the daily planner alone — it wipes each morning, so a "next time" intention would evaporate before next time. Not `RecoveryGoal` — changing someone's goal because they slipped reads as punitive. |
| Repeat trigger | **Replace, keep history.** One active strategy per trigger; superseded ones retained. |
| Trigger vocabulary | **Unify on the `TriggerType` enum.** |
| Where logic lives | **Pure engine + thin repo** (Approach A). |
| Strategy type | **Free text** (`String`), not an enum. |

### Why unify on `TriggerType`

Two incompatible vocabularies exist today:

- `TriggerType` (`lib/data/enums.dart`) — what `TrackerEvent` stores and what `AnalyticsEngine` /
  `RiskEngine` compute over.
- The relapse flow's free strings — `"Boredom"`, `"Stress"`, `"Loneliness"`, `"Tiredness"`,
  `"Scrolling"`, `"Something else"`.

Three overlap by luck. `"Tiredness"` has no enum member; `"Scrolling"` is ambiguous.

**Urges are recorded as enum indices.** A plan keyed by free string could therefore *never* be
matched against a logged urge — it could only ever be displayed as a static list, which forfeits
the entire point. Keying on the enum is what makes trigger-aware surfacing possible.

Note: `triggerLabel()` is **English-only** (its "localized in Phase 7" comment is stale — Phase 7
never did it). Unifying does *not* deliver i18n today; it does mean localizing that one switch
later fixes every surface at once.

### Why free-text strategy

An enum would let a plan link to its tool ("Breathe" → the breathing screen), but would block the
plan screen's editing. Editing wins: a plan you cannot reword is not yours. **The tool link is
deliberately deferred**, not forgotten.

## Data model

New Isar collection `CopingPlan` — the **11th**; register `CopingPlanSchema` in `isar_service.dart`
alongside the existing ten.

```dart
@collection
class CopingPlan {
  Id id = Isar.autoIncrement;

  @Index()
  @enumerated
  late TriggerType trigger;

  /// The coping action, e.g. "Reach out to someone". Free text so the plan
  /// screen can edit it; the flow seeds it from a fixed set of choices.
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

Active lookup: `filter().triggerEqualTo(t).supersededAtUtcIsNull().findFirst()`.

"Replace, keep history" falls out of a nullable timestamp rather than a delete — consistent with
the lapse-tolerance principle of never destroying data.

### Taxonomy changes (must land together)

1. Append `tiredness` to `TriggerType` — **at the end only**. `enums.dart:4-6`: Isar persists
   `@enumerated` by index, so reordering silently corrupts every stored `TrackerEvent`.
2. Add its `triggerLabel` case — the exhaustive switch makes this a compile error if forgotten.
3. Add `tiredness` to `quickTriggers`. **Without this the feature is inert for that trigger**: the
   urge sheet only offers `quickTriggers`, so an untaggable trigger can never match a plan.

### Flow JSON contract

Effects emit **enum names verbatim**: `{"trigger": "stress"}`, `{"trigger": "tiredness"}`,
`"Scrolling"` → `{"trigger": "socialMedia"}`. Parsing is a name lookup — no mapping table to drift.

`"Something else"` emits **no trigger effect**, so the engine returns "no plan" without a sentinel
enum member. Accepted tradeoff: that path loses its `Trigger:` line in the journal. A trigger the
user cannot name cannot be matched to an urge anyway, since the sheet only offers named ones.

`_composeReflection` needs **one special case**: route the `trigger` var through `triggerLabel()`,
or the journal degrades from `"Trigger: Stress"` to `"Trigger: stress"`.

## Components

### `CopingPlanEngine` (pure, TDD'd)

```dart
enum PlanAction { none, create, supersede, reaffirm }

class PlanRevision {
  final PlanAction action;
  final TriggerType? trigger;
  final String? strategy;
  final String? need;
  final int? supersededId;   // the plan this replaces
}

class CopingPlanEngine {
  /// Decide what a reflection's collected [vars] imply for the standing plan,
  /// given every currently-[active] plan. Pure: the caller does the writing.
  static PlanRevision revise({
    required Map<String, String> vars,
    required List<CopingPlan> active,
  });

  /// The plan to surface for a logged urge: the first of [triggers] in
  /// `quickTriggers` order that has an active plan. Null when none match.
  static CopingPlan? matchFor(List<TriggerType> triggers, List<CopingPlan> active);
}
```

`strategy` is sourced from `vars['plan']`, `need` from `vars['need']`, `trigger` from
`vars['trigger']` — the keys the relapse flow already writes.

`matchFor` orders candidates by their index in `quickTriggers`. A trigger absent from
`quickTriggers` (`location`, `emotion`) sorts **last**, after every listed one, so ordering stays
total and deterministic rather than depending on selection order. In practice the sheet only offers
`quickTriggers`, so this is a defensive rule, not a live path.

Passing *all* active plans (at most one per trigger — a dozen rows) rather than a pre-fetched match
keeps this a single pure call; otherwise the caller must parse the trigger before it can query.

| Situation | Result |
|---|---|
| no `trigger` or `plan` var, or unparseable trigger | `none` |
| blank strategy | `none` |
| no active plan for that trigger | `create` |
| active plan, same strategy (trimmed, case-insensitive) | `reaffirm` — **no write** |
| active plan, different strategy | `supersede` + `create` |

`reaffirm` exists so that planning "breathe" for stress three times running doesn't manufacture
three identical history rows — history should read as signal, not churn.

### `CopingPlanRepo` (thin I/O)

`active()`, `activeFor(trigger)`, `historyFor(trigger)`, `apply(revision)`, `edit(id, strategy)`,
`remove(id)`.

`apply` stamps `supersededAtUtc` on the old row and inserts the new one **in one `writeTxn`**, so a
crash cannot leave a trigger with zero active plans. It is a **no-op for `none` and `reaffirm`** —
the engine decides, the repo only executes, so "should this write at all?" is never asked twice.

### `DailyPlanStore` (targeted refactor)

Today's plan blob is read/written *inside* `DailyPlannerScreen._load/_save`, so nothing else can
touch it. Extract `load()` / `save()` / `addIntention()` (with de-dup), preserving the existing
stale-day and corrupt-blob handling. Both the screen and the echo use it. **Scoped strictly to this
feature — the planner's UI is not touched.**

### Action tokens

Two new tokens in `CoachFlowScreen._runAction`, alongside `saveReflection:` / `navigate:`:

- `adjustPlan` — engine + repo; writes the standing plan.
- `addTodayIntention` — the echo (`"Practice: <strategy>"`).

**The echo is offered, not imposed** — silently mutating the user's checklist is rude, and existing
node types already express consent with no new mechanism.

`relapse_reflection.json` node sequence changes from `plan → save → offer` to
**`plan → save → adjust → echo → (echo_add) → offer`**, leaving `offer`, `go_breathe`, `go_ground`
and `end` untouched:

```json
{ "id": "save", "type": "action",
  "text": "Saving what you learned…",
  "action": "saveReflection:relapse", "next": "adjust" },

{ "id": "adjust", "type": "action",
  "text": "Updating your plan…",
  "action": "adjustPlan", "next": "echo" },

{ "id": "echo", "type": "choice",
  "text": "Want to put a practice run on today's plan?",
  "choices": [
    { "label": "Yes, add it to today", "next": "echo_add" },
    { "label": "Not today", "next": "offer" } ] },

{ "id": "echo_add", "type": "action",
  "text": "Adding it to today…",
  "action": "addTodayIntention", "next": "offer" }
```

`adjustPlan` runs *after* `saveReflection:relapse` so the journal entry is written even if the plan
write fails. The `echo` node is static, so it is offered on every run — including the
`"Something else"` path where no standing plan is created but a practice intention still makes
sense.

### Making the revision visible

`_runAction` becomes `Future<String?>`; when it returns text, `_advanceTo` appends it as a coach
turn:

> "Updated your plan for stress — reaching out to someone replaces breathing for a minute."

`create` confirms, `reaffirm` affirms, `none` says nothing. The user learns their own pattern
instead of it changing behind their back.

The flow JSON still cannot branch on prior state — `CoachRunner` stays pure and stateless, and its
11 existing tests stay valid. The apparent memory lives entirely in the action's return value.

## Surfaces

**Urge log → matched plan.** A selected trigger with an active plan shows a soft card: *"Your plan
for stress: Reach out to someone."*

**Suppressed when `outcome == lapse`.** Showing the plan right after "I acted on it" reads as *"you
planned to reach out — and didn't."* That is a rebuke, and it collides with the non-shaming
guardrail. It is also redundant: the relapse flow auto-opens on that path and is the right place
for that learning.

**Plan screen** (new route `copingPlan`, reached from a Tools-tab `NavRow`). Active plans as
trigger → strategy with "since <date>"; tap for history (superseded strategies + dates — where
"breathing didn't hold for stress; reaching out did" becomes legible); inline edit; delete. Empty
state explains where plans come from rather than implying the user is behind.

**Panic hub** — a compact card listing active plans, tapping through to the plan screen. Already a
menu, so no new decision burden.

**Emergency mode** — the matched plan as a **single line inside the existing `reflect` step**. No
list, no tap targets, no new step; renders exactly as today when there is no match. This requires
widening `showLogUrgeSheet` from `Future<int?>` to also return the selected triggers, with
`home._logUrge` passing the matched trigger to `EmergencyModeScreen` via route arguments. Entered
from the panic hub there is no trigger, hence no line.

**This is the only existing signature the feature changes.**

### Ad policy

`copingPlan` goes in `AdPolicy.noAdRoutes`.

Not because the screen is itself a crisis surface — it reads as calm and reflective, and
`DailyPlannerScreen` carries a banner. **Because the panic hub links directly to it**, a banner
there would put an ad one tap from the panic button.

Route-based ad policy cannot see reachability: each route is correct in isolation and the violation
is created by a *link*. "Is this a crisis surface?" is really "is this reachable in one tap from
one?" — a question about the navigation graph. This applies to every future surface the panic hub
links to.

## Error handling

Nothing in this path may throw.

- `TriggerType.values.byName()` raises `ArgumentError` on an unknown name — the engine uses a
  **null-returning lookup** instead, so an authoring typo yields `none`, never a crash mid-reflection.
- Repo writes are wrapped: an Isar failure leaves the conversation running and returns no coach
  turn, matching how `AdService` / `NotificationService` degrade to no-ops.
- Corrupt-blob and stale-day handling carries over unchanged into `DailyPlanStore`.
- Deleting an already-gone plan is a no-op.

## Testing

**No test in this project opens Isar** — testing is pure engines, JSON contracts, and widgets. This
is why the logic belongs in the engine: logic in the repo would be logic with no test home.

*Pure engine* (`test/coping_plan_engine_test.dart`), written red→green before any UI:

- `none` when the trigger var is missing, unparseable, or the strategy is blank
- `create` when no active plan exists for that trigger
- `reaffirm`, and **no write**, when the same strategy repeats (case/whitespace-insensitive)
- `supersede` carries the correct `supersededId`
- `need` is carried onto the revision
- `matchFor`: null when nothing matches; `quickTriggers` order when several match; **ignores
  superseded plans**

*Content contract* (extend `test/coach_flows_test.dart`): every `trigger` effect in every flow
parses to a real `TriggerType`. This is the `achievements_content_test` bug class — a flow emitting
`{"trigger": "stres"}` would silently create no plan and the user would never know the reflection
went nowhere.

*Widget*: plan screen renders active plans and its empty state; urge sheet shows the plan card on a
matched trigger and **hides it when outcome is lapse** (guardrail pinned by test, so a later
refactor cannot quietly undo it).

## Mechanical checklist

- `dart run build_runner build --delete-conflicting-outputs`; commit the `.g.dart`
- register `CopingPlanSchema` in `isar_service.dart`
- add `copingPlan` to `RouteName` + `AppRoute.routes` **and** `AdPolicy.noAdRoutes`
- `flutter analyze` + `flutter test` green

## Out of scope (deliberate)

- Strategy → tool route linking ("do it now" from a plan card)
- Localizing `triggerLabel()`
- Plan suggestions derived from `RiskEngine` patterns
- Any change to emergency mode beyond the single `reflect` line
