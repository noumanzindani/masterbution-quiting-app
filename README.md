# Momentum

A private, on-device recovery app that helps people quit or cut down compulsive
porn / masturbation use — grounded in CBT and sex-therapy best practice
(non-shaming, harm-reduction, **lapse-tolerant**).

Built under hard constraints, by design:

- **No backend, no Firebase, no server** — zero running cost.
- **No AI / no LLM calls** — anything "AI-like" is on-device rule-based logic or statistics.
- **All data local** on the device (Isar + SharedPreferences).
- **Monetized only via Google AdMob** (banner + capped interstitial), never in crisis/urge zones.
- **Content bundled** as JSON assets (text-first).
- Ships to **Android + iOS** from one Flutter codebase.

> **Status: Phases 0–7 complete — the planned build is done.** On top of the core loop, analytics,
> content, coach, gamification, wellbeing, sleep tracking and proactive intelligence, Phase 7 adds
> **AES-256-GCM encrypted backup/restore**, **progress-share + accountability partner** (prefilled
> SMS/WhatsApp) + **therapy notes**, **full ar/fr/es localization** (UI + RTL + locale-aware content),
> and a **discreet app icon/name** switch. 161 unit tests, `flutter analyze` clean; iOS sim + Android
> debug APK both build.
> **Next:** release hardening only — real AdMob IDs + consent (UMP/ATT), data-safety declarations, a
> store audit, and on-device QA of the two device-only behaviours (notification delivery; the live
> discreet-icon swap). No further feature phases are planned (see `hand.md` §12).
>
> **👉 If you're resuming this project, read [`hand.md`](hand.md) first** — it's the full handoff
> (architecture, engines, content system, gotchas, what's built, and exactly where to pick up).

## Run

```bash
flutter pub get
# Isar codegen — only needed after changing a @collection; *.g.dart are committed.
dart run build_runner build
flutter run                # Android or iOS device/simulator
```

## Quality gates

```bash
flutter analyze            # must be clean
flutter test               # 161 unit tests, must be green
```

## Tech stack

Flutter 3.41 / Dart 3.11 · `provider` state · `isar_community` (local DB) ·
`google_mobile_ads` · `flutter_local_notifications` · `local_auth` + `pinput` + `crypto`
(app lock) · `record` + `audioplayers` + `image_picker` (mood media) · `fl_chart` ·
`url_launcher` · `google_fonts`.

Ads currently use Google's **test** ad unit IDs. See the pre-release checklist in `hand.md`
before shipping.
