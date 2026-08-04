# CLAUDE.md

Guidance for Claude Code working in this repo.

> **Not EzHand.** A `CLAUDE.md` in the parent dir (`StudioProjects/`) describes a
> Laravel/Dio marketplace called EzHand — it is auto-loaded but does **not** apply here.
> This project (`momentum`) has no backend, no Firebase, no Dio, no LLM calls.

> **Resuming work? Read `hand.md` first** — it is the single source of truth for
> where the project is and what to do next. `README.md` covers the product constraints.

## Project

Momentum — a private, **on-device** Flutter recovery app (CBT / sex-therapy,
non-shaming, harm-reduction). Hard constraints by design: no backend/Firebase/server,
no AI/LLM (anything "AI-like" is on-device rule-based logic or statistics), all data
local, monetized only via AdMob (never in crisis/urge zones), content bundled as JSON assets.

## Commands

```bash
flutter pub get
flutter run
flutter test                          # 39 test files under test/
flutter test test/streak_service_test.dart   # single file
flutter analyze                       # flutter_lints
dart run build_runner build --delete-conflicting-outputs   # after editing any Isar collection
flutter build apk --release
flutter build ios --release
```

## Architecture

- **State:** `provider` (`ChangeNotifier`), one `*Provider` per screen in `lib/providers/`.
- **Persistence:** `isar_community` (**NOT** the `isar` package — chosen to resolve a Dart
  3.11.5 resolution conflict). Codegen via `isar_community_generator`. Collections live in
  `lib/data/collections/*.dart` with generated `*.g.dart` siblings; access them through
  repositories in `lib/data/repositories/`. Also `shared_preferences` for lightweight prefs.
- **Business logic:** rule-based engines/services in `lib/services/` (e.g. `streak_service`,
  `analytics_engine`, `risk_engine`, `reward_engine`, `alternatives_engine`, `coach_runner`).
- **Screens:** `lib/screens/<feature>/`; the 5-tab bottom nav lives in `lib/screens/shell/`
  (`main_shell_screen.dart` + `tab_shell_scaffold.dart` + per-tab `*Body` presenter widgets).
- **Routing:** named routes — `lib/routes/route_name.dart` (strings) + `route_method.dart` (map).
- **Encrypted backup:** `encrypt` + `crypto` (AES) via `export_service` / `export_crypto`.
- **i18n:** `lib/common/languages/` (en/ar/fr/es), RTL for Arabic.

## Invariants (clinical guardrails — do not regress)

- **Lapse-tolerant** streaks/scoring — never punitive resets; see `streak_service`.
- **No ads in crisis/urge/SOS zones** — enforced by `ad_policy.dart` + `ad_guard_observer.dart`.
- **Non-diagnostic framing** — no medical/diagnostic claims in copy.
- The SOS panic button is a safety feature; keep it reachable.

## Conventions

- Match surrounding style; run `flutter analyze` and `flutter test` before marking work done.
- Editing an Isar collection requires re-running `build_runner`; commit the regenerated `.g.dart`.
- Planning docs (specs/plans) live in `docs/`.
