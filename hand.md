# Momentum — Handoff & Continuity (`hand.md`)

**Read this first when resuming.** It is the single source of truth for *where the project is*,
*how it's built*, and *exactly what to do next*. It exists because the AI-assistant memory that
enabled resuming across sessions lived **outside the repo** (`~/.claude/…/memory/`) and does **not**
travel with a `git clone`. This file replaces that.

- **Last updated:** 2026-07-10
- **Where we are:** **Phases 0–7 COMPLETE — the planned build is done.** Phase 7 shipped in increments:
  7.1 encrypted backup export/import (AES-256-GCM), 7.2–7.4 progress sharing + accountability partner
  (prefilled SMS/WhatsApp) + professional-support/therapy notes, 7.5 full **ar/fr/es** localization (UI + RTL
  + locale-aware bundled content), 7.6 **discreet app icon/name** (iOS alternate icon + Android activity-alias).
  `flutter analyze` clean, **214 unit tests green**, both the **iOS sim build and the Android debug APK build**.
  Since then: the 5-tab navigation shell and the **standing coping plan** (§7.I).
- **What's next:** no new planned phases — remaining work is **release hardening** (§12 checklist): real AdMob
  IDs + UMP/ATT consent wiring, data-safety declarations, store audit, and **on-device QA** of the two
  device-only behaviours (notification delivery; the live discreet icon/name swap). Deferred-to-v2 items
  (real AI chat, cloud sync, community, live therapist directory, bundled audio) remain out of scope.
- **⚠️ Two behaviours are device-only (never observable on the sim):** (1) notification *delivery* at the
  scheduled local time; (2) the discreet icon/name *swap* — alternate icons don't render in the iOS Simulator.
  Both are unit-tested and the native wiring is **build-verified** (iOS Info.plist gets `CFBundleAlternateIcons
  → AppIcon-Disguise`; the APK packages `DisguiseAlias` + all disguise mipmaps), but the visible effect needs
  a physical device. The placeholder disguise icons (neutral slate) must be replaced with final art pre-release.

---

## 0. TL;DR — resume in 3 steps

1. `flutter pub get && flutter analyze && flutter test` → expect clean + 214 passing. (If `.g.dart`
   errors appear, run `dart run build_runner build`.)
2. Read §7 (feature map) to see what exists, and §8 (Phase 4–7 status) for context.
3. Phases 0–7 are complete. There is no next phase — work from the **release-hardening checklist (§12)** and
   the two device-only QA items. Keep the clinical guardrails in §6 sacred.

Everything is on-device. No backend, no Firebase, no AI/LLM. Monetized only via AdMob (test IDs now).

---

## 1. The product & its hard constraints

A private app to quit/cut-down compulsive porn/masturbation use — CBT + sex-therapy grounded,
**non-shaming, harm-reduction, lapse-tolerant**. Every technical choice serves these constraints:

- No backend / no Firebase / no server (zero running cost).
- No AI / no LLM — "AI-like" features are on-device rule-based logic or descriptive statistics.
- All data local (Isar for structured/queryable data; SharedPreferences for scalar flags).
- Monetized only via Google AdMob — **never** in crisis/urge zones, never right after a lapse.
- Content is bundled JSON assets (text-first; audio deferred).
- Android + iOS from one Flutter codebase.

---

## 2. How to run / build / test

```bash
flutter pub get
dart run build_runner build     # Isar codegen. *.g.dart ARE committed, so only needed after
                                # you add/change a @collection. (NOT `--delete-conflicting-outputs`.)
flutter run                     # runs on a connected device / booted simulator
flutter analyze                 # must be clean before calling any task done
flutter test                    # 214 unit tests, must be green
```

**Verification philosophy (do not skip):** pure domain logic is TDD'd (red→green). But native
launch-time issues (see §9) are invisible to `analyze`/`test` — you MUST also boot the app on a
real simulator/device for anything touching plugins, native config, or new Isar schema.

---

## 3. Architecture (reused from the author's EzHand apps, backend stripped)

```
lib/
  config.dart          Barrel hub. Import this one file to get Flutter + common exports + the
                       global singletons + context helpers appColor()/isDark()/language()/rtl().
  packages_list.dart   Re-exports flutter/material, provider, shared_preferences, google_fonts.
  main.dart            main() → WidgetsFlutterBinding → AppInit.run() → runApp(MultiProvider → MaterialApp)
  common/
    session.dart       Holder of ALL SharedPreferences key strings (the prefs-vs-Isar boundary).
    app_fonts.dart     i18n KEY holder (confusingly named — it's string keys, not fonts).
    languages/         en/ar/fr/es maps + LanguageProvider (key→string, falls back to English; `isRtl` for
                       Arabic drives Directionality in MaterialApp.builder). Content is localized in parallel
                       under assets/content/i18n/<locale>/ with per-file English fallback (see ContentService).
    theme/             AppTheme (calm teal palette), ThemeService (light/dark/system), AppCss (GoogleFonts styles).
  content/             Bundled-content layer (Phase 3):
    content_service.dart   Loads & caches all JSON; preloaded in AppInit; degrades to empty on error.
    content_models.dart    ContentArticle/ArticleBlock, Quote, HealthyAlternative.
    cbt_models.dart, quiz_models.dart, session_models.dart, program_models.dart (Program/ProgramDay/ValueItem)
  data/                Isar layer:
    enums.dart         SINGLE SOURCE OF TRUTH for enums. ⚠ On-disk contract — see §5.
    isar_service.dart  Opens Isar ('momentum' db), registers all 9 collection schemas.
    time_buckets.dart  DST-safe local-day index (see §9).
    trigger_labels.dart
    collections/       8 @collection classes + generated *.g.dart (committed).
    repositories/      7 thin Isar repos (the ONLY code that touches Isar's native layer).
  providers/           One ChangeNotifier per feature (Onboarding/Dashboard/Settings/Analytics/Habit/Mood).
  routes/              route_name.dart (string constants), route_method.dart (name→WidgetBuilder map), index.dart.
  screens/             splash, onboarding, home (dashboard), emergency/, lock/, settings/, insights/,
                       habits/, mood/, learn/ (academy/article/motivation/alternatives/sessions/program/values),
                       cbt/ (hub/worksheet/entry-view/quiz).
  services/            app_init, ad_service, ad_policy, ad_guard_observer, lock_service, media_service,
                       + the pure engines (see §4).
  widgets/             primary_button, option_scale, content_blocks, article_card, ad/banner_ad_widget.
assets/content/        JSON corpus (see §7.C). Registered in pubspec.yaml under flutter: assets:.
test/                  Unit tests (63).
```

**Global singletons (in `config.dart`, assigned once in `AppInit`)**: `prefs`, `session`, `isarService`,
the 7 repos (`trackerRepo`, `goalRepo`, `assessmentRepo`, `journalRepo`, `habitRepo`, `moodRepo`, `cbtRepo`),
`adService`, `contentService`, plus `appFonts`, `appCss`, `route`, `rootNavigatorKey`.

**State management:** `provider` + `ChangeNotifier`. Feature providers are created per-screen (scoped) except
`ThemeService`, `LanguageProvider`, `SettingsProvider` which are app-wide in `main.dart`'s `MultiProvider`.

---

## 4. The engines (pure, device-free, TDD'd) — the "no-AI intelligence"

All under `lib/services/` (except TimeBuckets under `lib/data/`). Each is pure + unit-tested so ~90% of
the app's real logic runs in milliseconds on CI without a simulator. **Reuse these; don't re-derive per screen.**

| Engine | Does | Tests |
|---|---|---|
| `TimeBuckets` | Local-day index (`dateEpochDay`), DST-safe via UTC-midnight diff | `time_buckets_test` |
| `AssessmentEngine` | PHQ-2/GAD-2/ASRS-style screening → recovery-difficulty composite → suggested goal + plan | `assessment_engine_test` |
| `StreakService` | Lapse-tolerant streak + **forgiving Recovery Score** (70% windowed resilience + 30% cumulative habit) | `streak_service_test` |
| `AnalyticsEngine` | Hour/weekday histograms, 7×24 heatmap, top triggers, least-squares trend, **min-sample-gated insights** | `analytics_engine_test` |
| `HabitStats` | Current habit streak from done-days | `habit_stats_test` |
| `AlternativesEngine` | "I have N minutes" → time-fit + greedy category-variety suggestions | `alternatives_engine_test` |
| `CopingPlanEngine` | Standing-plan decisions: `revise` (create/supersede/reaffirm, keyed by `TriggerType`), `matchFor` (which plan to surface for a logged urge, in `quickTriggers` order), `cardFor` (= `matchFor`, except **never right after a lapse** — showing the plan there would read as a rebuke) | `coping_plan_engine_test` |
| `QuizEngine` | Quiz scoring, 70% pass bar | `quiz_engine_test` |
| `ProgramProgress` | Sequential day-unlock for multi-day programs | `program_progress_test` |
| `AdPolicy` | The ONLY thing that decides whether an ad may show (see §6/§10) | `ad_policy_test` |
| `LockService` | Salted SHA-256 PIN hash + verify | `lock_service_test` |

**The two forgiving-score constants** (`StreakService._wResilience = 0.7`, `_wHabit = 0.3`) and the
**assessment composite weights** (`AssessmentEngine._weights`, frequency-heaviest) are the main clinical dials.

---

## 5. Data layer & the on-disk contract

**11 Isar collections** (registered in `isar_service.dart`): `TrackerEvent` (the analytics workhorse — every
urge/lapse/win/check-in; denormalized indexed `hourOfDay`/`weekday`/`dateEpochDay` for cheap GROUP-BY),
`RecoveryGoal` (+ embedded `Milestone`), `AssessmentResult`, `JournalEntry`, `HabitDefinition`, `HabitTick`,
`MoodEntry` (has reserved nullable `voicePath`/`photoPath`), `CbtEntry` (answers as JSON keyed by step id),
`SleepEntry` (bedtime/wake as minute-of-day, quality, note; `@ignore` `durationMinutes` getter),
`SessionNote` (professional/therapy notes — Phase 7.3), `CopingPlan` (standing plan per `TriggerType`;
`supersededAtUtc == null` means active — see §7.I).

⚠️ **`lib/data/enums.dart` is an on-disk contract.** Isar persists `@enumerated` fields **by index**, so
reordering an existing enum silently corrupts stored data. **Only ever append** new enum values.

⚠️ **Isar accessor pluralization is naive (+s):** `JournalEntry` → `isar.journalEntrys` (not `journalEntries`),
`CbtEntry` → `isar.cbtEntrys`, `MoodEntry` → `isar.moodEntrys`. Check the generated `.g.dart` when unsure.

**prefs-vs-Isar rule:** chart it / GROUP BY it / keep history → **Isar**. Single current scalar/flag →
**SharedPreferences** (keys live in `session.dart`: `isOnboarded`, `themeIndex`, app-lock `pinHash`/`pinSalt`,
`adCooldownUntil`, `dopamineProgress`, `chosenValues`, …).

**Correctness:** store both `timestampUtc` and local `dateEpochDay`; compute streaks/bins in local time via
`TimeBuckets` (never subtract raw DateTimes — DST breaks it).

---

## 6. Clinical guardrails — NON-NEGOTIABLE, baked into code (not just copy)

1. **Never "reset to zero" on a lapse.** A relapse is appended data (`Outcome.lapse`). The day-counter
   restarts but the Recovery Score barely moves (StreakService 70/30). No shame mechanics anywhere.
2. **No ads in crisis/urge zones** — `AdPolicy.noAdRoutes` = {panic, urgeSurf, breathing, grounding,
   emergencyJournal, emergencyMode, crisisResources, relapseReflection, lock}. Also a **post-lapse cooldown**
   (`adCooldownUntil`, tripped in `DashboardProvider.logLapse`). Keep new crisis routes in that denylist.
3. **Crisis resources always reachable** (panic hub + settings). "Not medical care" disclaimer on them.
4. **Non-diagnostic framing** on all screenings ("a self-reflection screen, not a diagnosis").
5. **Min-sample gate** on analytics insights (≥5 events) — the app stays honestly silent rather than
   fabricating a pattern that could read as a verdict.
6. Non-shaming, harm-reduction microcopy throughout. No unverified medical claims.

---

## 7. Feature map — what's built (Phases 0–7 ✅)

### A. Core loop (Phase 1)
Onboarding + local-formula screening → rule-based goal (quit/reduce, 7/30/90/180). Dashboard: streak hero,
Recovery/Consistency cards, quick actions (log urge / I resisted / check-in / I slipped), always-visible
Panic bar. **Emergency toolkit (NO-AD):** panic hub → paced breathing (4-4-6 animation), 3-min urge-surf
timer, 5-4-3-2-1 grounding, emergency journal, reach-out. **Crisis resources (NO-AD)** with tel:/sms: launch.
**App lock:** PIN (pinput, salted hash) + biometric, launch-gate + resume re-lock (15s grace). **AdService**
guardrail (banner on non-crisis screens, capped interstitial on resume, post-lapse cooldown). Settings.

### B. Make data meaningful (Phase 2)
Insights screen: 7×24 heatmap + top-triggers bars + `fl_chart` weekly-trend line + gated insight cards.
Habit tracker (10 presets, tap-complete, 🔥 streak, 7-day strip). Mood journal (1–5 faces + tags + note +
**voice note** [record→audioplayers playback] + **photo** [image_picker→MediaService copies to app docs;
only paths in Isar]).

### C. Content depth (Phase 3) — JSON-driven, generic renderers
Learn hub → **Academy** (articles by category + quizzes), generic **Article reader** (ContentBlocks:
h/p/list/callout + YouTube link), **CBT toolkit** (4 worksheets → generic form [text/scale/choice] → CbtEntry
→ history + viewer), **quizzes** (QuizEngine), **Guided sessions** (paced player), **7-day dopamine reset**
(day-gating via ProgramProgress; progress in prefs), **Values** module (multi-select + reflection → prefs),
**Motivation** (daily quote + stories).

**Adding content = editing JSON.** Corpus in `assets/content/`: `manifest.json`, `academy/articles.json`,
`academy/quizzes.json`, `motivation/quotes.json`, `alternatives.json`, `cbt/worksheets.json`,
`sessions/sessions.json`, `programs/dopamine_reset.json`, `values/values.json`, **`coach/flows/*.json`**.
New files/dirs must be added to `pubspec.yaml` `flutter: assets:` AND wired into `ContentService.preload()`
(coach flows: add the filename to `ContentService._coachFlowFiles`). No new Dart for more of an existing type.

### D. Interactive guidance (Phase 4 core)
**Rule-based coach** — flows are JSON decision trees in `assets/content/coach/flows/*.json`; a **pure
`CoachRunner`** (state machine, 11 unit tests) walks them; **one generic `CoachFlowScreen`** renders any flow
as a calm chat. Node types `message | choice | input | action | end`; `choice.effect` records variables;
`action` tokens are interpreted only by the UI (`saveReflection:<kind>` → writes a `JournalEntry`;
`navigate:<route>` → opens a calming tool). **Adding a coach conversation = a new JSON file, zero code.**
- **Relapse-reflection flow** (`relapse_reflection.json`) auto-opens after "I slipped", on the
  `relapseReflection` **no-ad route**. Non-shaming: reframes the slip as learning, captures the trigger + a
  concrete "next time I'll try" coping intention, saves a `JournalKind.relapseReflection` entry.
- **Daily reflection** (`daily_reflection.json`) — guided check-in → `JournalKind.dailyReflection`.
- **Daily planner** — a few intentions for *today*, stored as one JSON blob in prefs (`session.dailyPlan`),
  auto-resets each day (prefs-vs-Isar rule: single current-day scalar).
- Entry points: dashboard **"Coach & check-ins"** nav row → `CoachHubScreen` (reflection, planner, recent
  reflections). Flows validated by `test/coach_flows_test.dart` (no dangling refs, all reachable, terminates).

### E. Gamification / rewards (Phase 5, increment 5.1)
**Achievements + coins + accent themes.** Pure `RewardEngine` (TDD, 9 tests): given a metrics snapshot +
achievement defs, computes earned ids and coin totals. `RewardsProvider` gathers metrics (`streakDays`,
`positiveDays`, `reflections`, `daysActive`) from repos and owns persistence (all prefs — no Isar).
Achievements authored in `assets/content/rewards/achievements.json` (a badge unlocks when one `metric ≥
atLeast`), validated by `test/achievements_content_test.dart` (every metric must be one the provider produces).
- **Guardrails baked in:** badges are **sticky** (provider unions newly-earned into a stored set — a lapse
  never revokes one); coins are **earned-only** (never deducted for a slip); the **only** coin sink is
  cosmetic **accent themes** (`AccentPalettes` in `common/theme/accent_palette.dart`) — never therapeutic
  content. Accent applied via `ThemeService.setAccent` + `themeDataFor` (recolours the `primary` pair app-wide).
- **Rewarded ads:** `AdService.showRewardedForCoins()` (Google TEST rewarded unit) — opt-in, user-initiated
  from the Rewards screen only, never a crisis zone. Uses a `Completer` so coins credit only if the reward
  actually fires. `RewardsScreen` (dashboard **"Milestones & rewards"** row): coin header, achievements list,
  accent shop.

### F. Wellbeing modules (Phase 5, increment 5.2)
Six modules — **mindfulness, self-esteem, relationships, anxiety, low-mood, sleep** — each grouping a few
articles + guided sessions. **Pure content + reuse:** a `WellbeingModule` (`wellbeing/modules.json`) just
lists article/session ids; `WellbeingModuleScreen` resolves them and opens the **existing** `ArticleScreen`
and `SessionPlayerScreen` — so a new module is JSON only. Content lives in separate files
(`wellbeing/articles.json`, `wellbeing/sessions.json`) with their own `ContentService` lookups, so it does
**not** leak into the Academy/Sessions library. The **low-mood module carries a prominent disclaimer**
("self-help, not medical care") rendered atop the module. Entry: dashboard **"Wellbeing"** row →
`WellbeingHubScreen`. Validated by `test/wellbeing_content_test.dart` (every referenced id resolves — no
module tile can open an empty screen).

### G. Sleep tracking (Phase 5, increment 5.3)

`SleepEntry` Isar collection (9th) stores each night as **local minute-of-day** bedtime/wake (not DateTimes, so
the "23:00→07:00" midnight wrap is plain arithmetic), a 1–5 `quality`, and an optional note; the `@ignore`
`durationMinutes` getter resolves the wrap. `SleepRepo` **upserts one entry per wake-day** (`dateEpochDay`), so
re-logging a night corrects it rather than duplicating. The tips are a **pure, statistics-only
`SleepTipsEngine`** (`lib/services/sleep_tips_engine.dart`, TDD — `test/sleep_tips_engine_test.dart`, 10 tests):
a **min-sample gate** (<3 nights → a single encouraging "log a few nights" tip, never a shaming pattern), then
short-sleep (<7h), late-bedtime, schedule-inconsistency, and low-quality rules, else an "on track" nudge.
Bedtimes before noon are **anchored +1440** so an evening→morning window is monotonic — "how late" and "how
spread out" become plain comparisons instead of circular statistics. `SleepProvider` (screen-scoped) maps recent
entries → engine; `SleepLogScreen` (route `sleepLog`) has the log form (time pickers + quality + note), the
tips, and recent-nights history. Surfaced via a new **optional `WellbeingModule.tracker` route field** (JSON
only) → a "Track your sleep" CTA atop the sleep module (any future module could point at its own tracker the
same way). The engine deliberately carries **no navigation** — it stays pure; the screen surfaces the sleep
module's existing `wind_down` session / `sleep_hygiene` article.

### H. Proactive intelligence (Phase 6)

Three pieces, all with the pure logic TDD'd and the side effects kept thin:

- **Emergency recovery mode** (`services/emergency_flow.dart`, `screens/emergency/emergency_mode_screen.dart`).
  `EmergencyFlow` (8 tests) owns the two decisions: `shouldEscalate(intensity) → intensity >= 9`, and the fixed
  step order `breathe → ground → surf → reflect → close`. The screen is a **forced full-screen `PageView`
  stepper** — no menu, so an at-peak urge doesn't demand a choice — with lightweight inline steps (a pulsing
  breath orb, a 5-4-3-2-1 list, a 90s surf countdown, an optional note saved as `emergencyJournal`, a
  non-shaming reframe). An exit is always shown; it guides, never traps. It's a **NO-AD** route (`emergencyMode`
  was already in `AdPolicy.noAdRoutes`; Phase 6 just registered the screen). Two entry points share the one
  tested rule: the panic hub's high-emphasis "It's really bad right now" card, and the urge-log sheet — which
  now returns its intensity (`showLogUrgeSheet → Future<int?>`) so `home._logUrge` escalates automatically.
- **Risk-pattern engine** (`services/risk_engine.dart`, 7 tests). `RiskEngine.profile(events)` → a `RiskProfile`
  of `peakRiskHour` / `toughestWeekday` (numbers, where `AnalyticsEngine.insights` gives prose). Reuses the
  Phase-2 histograms; gated (≥5 lapses **and** a peak bin ≥ 2) so a handful of points never becomes a verdict;
  only lapses count as risk.
- **Smart notifications** (`services/smart_scheduler.dart` + `notification_service.dart` +
  `notification_scheduling.dart`). Pure `SmartScheduler.plan(profile, prefs)` (7 tests) emits deterministic
  `ReminderSpec`s — a daily check-in, a heads-up an hour before the peak-risk hour, a weekly nudge on the tough
  day — and **drops any that land in quiet hours** (default 22:00–07:00, midnight-wrap aware). Opt-in: `enabled`
  defaults false. `NotificationService` wraps `flutter_local_notifications` v22 (all-named API) and, like
  `AdService`, degrades to a no-op on any failure. **Timezone with no `flutter_timezone` dependency:** the
  desired *local* wall-clock is converted to a concrete UTC instant and scheduled in `tz.UTC` with
  `matchDateTimeComponents`; re-scheduled every launch via `NotificationScheduling.refresh()` (AppInit + on
  settings change), so a DST change self-corrects on next open (≤1h drift meanwhile). Settings → **Reminders**:
  an enable toggle (asks OS permission first; stays off if denied) + a daily check-in time picker. Android
  manifest adds `POST_NOTIFICATIONS` + `RECEIVE_BOOT_COMPLETED` + the plugin's two receivers; `build.gradle.kts`
  enables **core-library desugaring** (`desugar_jdk_libs:2.1.4`) — *required* or the Android build fails.

### I. Standing coping plan (closes the Phase-4 reflection→plan gap)

The relapse flow already captured an if-then implementation intention (trigger + strategy) and flattened it
into journal prose, where it could never reach the user mid-urge. Now it writes a `CopingPlan` (**11th** Isar
collection) keyed by `TriggerType` — the same vocabulary the urge log records, which is what makes
trigger-time matching possible. One active plan per trigger; a later reflection picking a different strategy
stamps `supersededAtUtc` on the old row rather than deleting it, so "breathing didn't hold for stress;
reaching out did" stays legible. Superseding + inserting happen in **one `writeTxn`** — a crash between them
would leave the trigger with no active plan at all.

`TriggerType` gained `tiredness` (**appended** — never reorder, see §5) and the flow JSON now emits enum
names, so `ReflectionComposer` (6 tests) renders `triggerLabel()` to keep journals readable. Two new coach
action tokens: `adjustPlan` (engine → repo, and the coach *says* what changed) and `addTodayIntention` (an
opt-in "Practice: …" row via the extracted `DailyPlanStore`, 8 tests).

Four surfaces, deliberately unequal in how hard they push:

| Surface | Behaviour |
|---|---|
| Urge log | the matched card via `cardFor` — **suppressed after a lapse** |
| Plan screen | route `copingPlan`, **NO-AD**; edit / delete / per-trigger history (`CopingPlanBody`, 4 tests) |
| Panic hub | `PanicPlanCard` — one more option in a menu, hidden entirely at zero plans |
| Emergency mode | a **single statement** in the `reflect` step — never a menu; the forced stepper stays forced |

`showLogUrgeSheet` widened to `Future<UrgeLogResult?>` to carry the trigger through. `copingPlan` is on
`AdPolicy.noAdRoutes` **because the panic hub links straight into it** — that membership is now pinned by a
test, since iterating the denylist proves the listed routes block ads but can't notice one going missing.

---

## 8. Phase 4–7 — status & what remains

### Phase 4 (interactive guidance) — core done (see §7.D)

Built & tested: the rule-based `CoachRunner`, the generic `CoachFlowScreen`, the relapse-reflection flow,
daily reflection, the daily planner, and the `CoachHubScreen`. To add a flow: drop
`assets/content/coach/flows/<name>.json`, add `<name>` to `ContentService._coachFlowFiles`, open it via
`Navigator.pushNamed(context, routeName.coach, arguments: '<flow-id>')` (new route + denylist entry if it's a
crisis flow). `action` tokens recognised: `saveReflection:relapse`, `saveReflection:daily`, `navigate:<route>`.
*Optional polish:* more coach flows. (The relapse-analysis → plan-adjustment step is **done** — see §7.I.)

### Phase 5 (gamification + wellbeing + sleep) — COMPLETE

**5.1 gamification/rewards — DONE (see §7.E):** `RewardEngine` (TDD), achievements JSON, coins, rewarded ads,
unlockable accent themes, `RewardsScreen`.

**5.2 wellbeing modules — DONE (see §7.F):** six modules (mindfulness, self-esteem, relationships, anxiety,
low-mood-with-disclaimer, sleep-hygiene) as pure content over the reused article reader + session player.

**5.3 sleep TRACKING — DONE:** `SleepEntry` Isar collection (9th; `bedtimeMinutes`/`wakeMinutes` as local
minute-of-day, `quality` 1–5, `note`; `@ignore` `durationMinutes` getter resolves the midnight wrap) +
`SleepRepo` (upserts one entry per wake-day so re-logging corrects, not duplicates). Pure **`SleepTipsEngine`**
(TDD, 10 tests) — statistics-only, min-sample gate (<3 nights → starter tip; no shaming), short-sleep,
late-bedtime (anchors pre-noon bedtimes +1440 → monotonic evening→morning axis), inconsistency (spread >90min),
low-quality, else on_track. `SleepProvider` (screen-scoped) + `SleepLogScreen` (route `sleepLog`: time pickers,
1–5 quality, note → save; tips + recent-nights history). Surfaced via a new optional `WellbeingModule.tracker`
route field (JSON-only) → "Track your sleep" CTA atop the sleep module.

**111 tests green; app boots on sim (Isar opened with the new schema, dashboard verified).** *GUI click-through
still blocked this session by macOS Automation permissions — the tips engine + `durationMinutes` wrap + content
wiring are covered by unit tests; the screen reuses the verified provider+ListView+card render patterns.*

### Phase 6 (proactive intelligence) — COMPLETE (see §7.H)

Guided **emergency recovery mode** (urge ≥ 9/10 forced stepper reusing the tested escalation rule), a pure
**`RiskEngine`** (peak-risk hour / toughest weekday over existing TrackerEvents, min-sample gated), and a pure
**`SmartScheduler`** → `NotificationService` pipeline (opt-in, quiet-hours-aware, rescheduled each launch). No
new Isar collections. Android manifest gained `POST_NOTIFICATIONS` + `RECEIVE_BOOT_COMPLETED` + the plugin's
two receivers; `build.gradle.kts` gained core-library desugaring. Device-only gap: actual notification delivery.

### Phase 7 (privacy/export + social + i18n + discreet) — COMPLETE

- **7.1 encrypted backup** — `ExportCrypto` (AES-256-GCM, 20k-iter SHA-256 KDF, unified wrong-passphrase error)
  + `ExportCodec` (versioned, app-tagged bundle) + `ExportService` (gathers every Isar collection + a prefs
  allow-list that **never** includes the PIN hash/salt) → `BackupScreen` (passphrase, private-notes toggle,
  share-sheet export, paste-to-restore). All pure crypto/codec logic is TDD'd.
- **7.2–7.4 social** — pure `ProgressReport` + `AccountabilityMessages` (wa.me / sms: URIs) → progress-share +
  accountability-partner screens (contact in prefs, prefilled SMS/WhatsApp via url_launcher/share_plus); 10th
  Isar collection `SessionNote` + repo → professional/therapy notes screen (title/note/homework/done).
- **7.5 i18n** — ar/fr/es UI maps (English fallback), RTL for Arabic via `MaterialApp.builder`, locale-aware
  `ContentService` (`assets/content/i18n/<locale>/…` with per-file English fallback), settings language picker.
  *Scoping note:* the **clinical content corpus is deliberately left to fall back to English** pending human
  translation — machine-translating sensitive therapy copy would violate the accuracy guardrail. Only the
  non-clinical motivation quotes were translated as a demonstration; the localization *infrastructure* is
  complete, so translated JSON dropped into the locale dirs is picked up with zero code changes.
- **7.6 discreet icon/name** — `DisguiseService` (MethodChannel, TDD'd contract, degrades to no-op) driven by
  the Settings toggle + re-applied on launch. iOS: `AppIcon-Disguise` alternate set + `INCLUDE_ALL_APPICON_ASSETS`
  build flag + `setAlternateIconName` in AppDelegate (icon only — iOS can't rename at runtime). Android:
  `DisguiseAlias` toggled against MainActivity via `PackageManager` (name **and** icon). **Both builds pass**;
  placeholder slate icons need replacing with final art. Device-only gap: the visible swap.

**161 tests green; `flutter analyze` clean; iOS sim build + Android debug APK build both succeed.**

---

## 9. Hard-won gotchas & lessons (don't relearn these)

- **Isar:** use **`isar_community` 3.3.2** (+ `_flutter_libs`, `_generator`), NOT the dormant `isar` package.
  It resolves + codegens + runs on Dart 3.11.5.
- **AdMob launch crash:** the `google_mobile_ads` SDK validates the AdMob **App ID** in `Info.plist`
  (`GADApplicationIdentifier`) / `AndroidManifest.xml` (`APPLICATION_ID`) **at launch**, even before
  `MobileAds.initialize()`. Missing → hard crash on boot. Both are set to **test** App IDs. (`analyze`/`test`
  were 100% green when this crashed — only a real boot caught it.)
- **`record` plugin:** pin **`record: ^6.x`** (6.2.1). `record 5.2.1` pulled an incompatible `record_linux`
  (a `hasPermission` signature mismatch in the federated `record_platform_interface`) and **failed the Dart
  compile for iOS** — because Dart compiles *every* endorsed platform implementation. Bumping the umbrella
  package fixed the transitive set. Lesson: with federated plugins, pin the umbrella to a coherent release.
- **`local_auth` 3.x:** `authenticate()` takes `biometricOnly:` / `persistAcrossBackgrounding:` **directly**
  — NOT `options: AuthenticationOptions(...)` (that's the 2.x API).
- **`pinput`:** `autofocus` only fires on first mount. On the confirm/after-error step you must attach a
  `FocusNode` and call `requestFocus()` or typed input is silently ignored.
- **iOS `Info.plist` usage strings required:** `NSFaceIDUsageDescription` (local_auth),
  `NSMicrophoneUsageDescription` (record), `NSPhotoLibraryUsageDescription` + `NSCameraUsageDescription`
  (image_picker), `NSUserTrackingUsageDescription` (ATT). Android: `RECORD_AUDIO` in the manifest.
- **DST-safe day math:** compute `dateEpochDay` as the diff of **UTC midnights** of the local date
  (`TimeBuckets`), never by subtracting raw local DateTimes.
- **Driving the iOS simulator from the CLI (for verification):** `cliclick` works, but zsh needs
  `cliclick ${=tokens}` to word-split; scrolling needs a *fine multi-step* `dd/w/m/du` drag (instant drags
  don't register as Flutter scrolls); lists settle with inertia so re-screenshot before tapping bottom
  buttons. `flutter run` in background + poll the log; `xcrun simctl io <id> screenshot`.

---

## 10. Ads — how the guardrail is structured (defense-in-depth)

`AdService` (SDK wrapper) is the ONLY code that talks to `google_mobile_ads`. Every show-decision defers to
the pure, unit-tested `AdPolicy` (no-ad-route denylist + consent gate + post-lapse cooldown + interstitial
cadence cap). `BannerAdWidget` renders `SizedBox.shrink()` when the policy disallows. `AdGuardObserver`
(a `NavigatorObserver`) keeps `adService.currentRoute` in sync so the policy always knows the top screen.
Interstitial fires only on app-resume, capped + gap-limited, never in a no-ad zone or cooldown.

**Currently test ad units.** Before release (§12): real ad units + real **UMP consent + iOS ATT**
(the `_consentResolved` flag is set true after init purely because test ads need no consent).

---

## 11. The master plan (phases 0–7)

The original approved plan lived at `~/.claude/plans/tell-me-all-of-dreamy-sun.md` (outside the repo). It maps
all 35 requested features to where each honestly lives (✅ local / 🔶 on-device stats / 🟡 zero-cost substitute /
🔒 v2). Phase summary:

- **0 Scaffolding** ✅ — project, theme, routing, Session, Isar, schema-critical collections.
- **1 Shippable MVP** ✅ — onboarding+screening, core logging, dashboard, emergency toolkit, app lock, ads, crisis.
- **2 Meaningful data** ✅ — analytics/heatmap/trend, mood journal (voice/photo), habit tracker.
- **3 Content depth** ✅ — CBT, academy+quizzes, guided sessions, dopamine reset, motivation, alternatives, values.
- **4 Interactive guidance** ✅ core — rule-based coach engine, relapse-reflection flow, daily reflection,
  daily planner. (Optional polish remains: explicit plan-adjustment step, more flows — see §8.)
- **5 Gamification + wellbeing + sleep** ✅ — rewards (badges/coins via **rewarded ads**, accent themes);
  six wellbeing modules (mindfulness, self-esteem, relationships, anxiety, low-mood-with-disclaimer,
  sleep-hygiene); **sleep tracking** (`SleepEntry` + `SleepTipsEngine`, rule-based tips).
- **6 Proactive** ✅ — emergency recovery mode (`EmergencyFlow`, urge ≥ 9/10 forced sequence), risk-pattern
  engine (`RiskEngine`), and rule-based smart local reminders (`SmartScheduler` + `NotificationService`,
  opt-in + quiet-hours). *(Notification delivery + Android build unverified this session — see §8.)*
- **7 Privacy/export + social + i18n** — encrypted export/import + PDF/share, sharing controls, discreet
  icon/name, accountability partner (prefilled SMS/WhatsApp via url_launcher), professional-support notes,
  full ar/fr/es localization.

**Deferred to a paid v2** (need backend/AI): real AI chatbot, Community, real accountability sync + SOS push,
cloud backup, live therapist directory, bundled audio.

---

## 12. Pre-release checklist (before any store submission)

- [ ] Swap AdMob **test** App IDs + ad unit IDs → **real** ones (Info.plist, AndroidManifest, `ad_service.dart`).
- [ ] Implement **Google UMP consent + iOS ATT** (SKAdNetwork IDs; non-personalized ads if declined; no ad
      before consent resolves). Flip `AdService._consentResolved` to be driven by real consent.
- [ ] **Data-safety declarations** — even though user data is local, the AdMob SDK collects ad IDs → declare
      in Play Data Safety + Apple Privacy Label; add Android 13+ `AD_ID` permission.
- [ ] Rate **17+**, ship zero explicit content, frame as health/recovery, keep store listing/screenshots clean.
- [ ] Surface crisis resources; keep "screening, not a diagnosis" + "not a substitute for care" disclaimers.
- [ ] Provide in-app **data wipe** (no account = no deletion endpoint needed).
- [ ] Run the `store-readiness-audit` / `app-audit` skill.
- [x] **Android build verified** (`flutter build apk --debug`, Phase 7.6) — the desugaring + notification
      receivers + the new `DisguiseAlias`/mipmaps all compile and package. Re-run in CI before release.
- [ ] **QA notification delivery on a physical device** — grant the runtime permission, confirm the daily
      check-in / risk heads-up / tough-day reminders actually fire at the right local time (the schedule logic
      is unit-tested, but on-device delivery wasn't exercised). Consider adding `flutter_timezone` if exact
      DST/zone handling matters more than the current launch-reschedule approximation.
- [ ] **QA the discreet icon/name swap on a physical device** — toggle Settings → Discreet mode; confirm the
      home-screen icon (both platforms) and launcher name (Android) actually change. The native wiring is
      build-verified but the swap can't render on the iOS Simulator. **Replace the placeholder slate icons with
      final neutral art** (iOS `AppIcon-Disguise.appiconset`, Android `mipmap-*/ic_launcher_disguise.png`).

---

## 13. Conventions to keep

- Match the surrounding code's idiom/comment density. Import `config.dart` in screens/providers for the barrel.
- New route → add the string to `RouteName`, register the builder in `AppRoute.routes`. If it's a crisis/urge
  surface, ALSO add it to `AdPolicy.noAdRoutes`.
- New `@collection` → register its `…Schema` in `isar_service.dart`, add a repo, run `build_runner`, commit `.g.dart`.
- New pure logic → **TDD it** (red→green) and add it to §4. New content type → JSON + generic renderer.
- Never hardcode secrets. Conventional Commits (`feat:`/`fix:`/`chore:`). Don't force-push `main`.
