# Bottom-nav shell for Momentum

**Date:** 2026-07-10
**Status:** Approved

## Problem

Momentum has ~15 built feature areas (insights, habits, mood, coach, CBT,
wellbeing, sleep, rewards, learn, social/accountability, professional notes,
emergency tools, settings) but they're all reached through a single scrolling
`HomeScreen` that pushes full-screen routes. There's no persistent navigation,
so the app reads as a "one-page app" even though the functionality is there.

The one hard constraint: the **Panic/SOS action** ("I need help right now")
must stay one tap from anywhere. It's a clinical guardrail
([hand.md](../../../hand.md)), not just a UX nicety, and it currently lives in
the screen real-estate a bottom nav bar would occupy.

## Decisions (locked via user approval)

1. **Layout:** 5-tab bottom nav — Home · Insights · Tools · Learn · You.
2. **Polish scope:** Shell + Home refresh. Build the new bottom-nav shell,
   redesign Home's hero/cards, and redesign the 4 new tab landing pages.
   Deeper detail screens (individual worksheets, articles, session players,
   etc.) keep their current look — polished in a later pass, not this one.
3. **Feature scope:** Surface what's already built. No new features. This is
   an information-architecture and navigation change only.

## Architecture

A single new `MainShellScreen` replaces `HomeScreen` at the existing `'home'`
route (`RouteName.home` — the string value doesn't change, so nothing else
in the app, including `AdGuardObserver`'s no-ad denylist, `main.dart`'s
`initialRoute`, or the lock-screen resume flow, needs to change).

`MainShellScreen` owns one `Scaffold`:
- `bottomNavigationBar`: `BottomNavigationBar` with 5 items, icon + label
  (per Material/HIG guidance — never icon-only).
- `body`: an `IndexedStack` of 5 tab-root widgets, switched by the selected
  index. `IndexedStack` (not `PageView`/lazy rebuild) so each tab's scroll
  position and provider state survive tab switches.
- Tapping a card *inside* a tab still does a normal
  `Navigator.pushNamed(context, ...)` on the root navigator, exactly as
  today. This means:
  - No nested per-tab `Navigator`s — the existing single-`Navigator`
    architecture, `rootNavigatorKey`, and `AdGuardObserver` are untouched.
  - Pushed detail screens cover the shell full-screen (bottom nav bar
    hidden), and popping back returns to the shell with the same tab still
    selected.
  - This is the lowest-risk option: it reuses 100% of the existing
    navigation/ads/lock infrastructure and only changes what sits at the
    `home` route.

## Tab mapping

Surfacing existing screens — no new screens beyond the shell itself and two
new "landing" widgets (Tools, You) that aggregate existing hub screens.

| Tab | Icon | Root content | Source |
|---|---|---|---|
| **Home** | `home_rounded` | Streak hero, recovery/consistency scores, quick actions (log urge / resisted / check-in / slip). Drops the nav-row list that duplicated the other 4 tabs (Insights, Habits, Mood, Coach, Rewards, Wellbeing, Learn) — that's the "Home refresh." | `HomeScreen` body, decluttered |
| **Insights** | `insights_rounded` | Existing analytics/patterns content + 2 quick-link cards to Habits and Mood Journal (the other "track yourself" screens that feed the same data). | `InsightsScreen` body (extracted) |
| **Tools** | `handyman_rounded` | New landing: cards to Coach & Check-ins, Daily Planner, Wellbeing hub, Sleep, Milestones & Rewards, Healthy Alternatives. | New `ToolsTabScreen`, links to existing hubs |
| **Learn** | `menu_book_rounded` | Existing `LearnHubScreen` content as-is (Academy, CBT, Sessions, Motivation, Program, Values, Quiz). | `LearnHubScreen` body (extracted) |
| **You** | `person_rounded` | Existing `SettingsScreen` content + quick links to Accountability Partner, Therapy Notes, Backup/Export. | `SettingsScreen` body (extracted), + new `YouTabScreen` wrapper |

## Panic/SOS placement

- **Home tab:** keeps a full-width red **"I need help right now"** bar,
  pinned at the top of the tab body (below the app bar) — the bottom slot is
  now occupied by the nav bar, so the bar moves from bottom to top. Same
  widget behavior as today's `_PanicBar`, just repositioned.
- **Insights / Tools / Learn / You tabs:** a small floating shield button
  (`FloatingActionButton`, shield icon), fixed position, always visible,
  routes straight to `routeName.panic`. Smaller footprint than a full bar so
  it doesn't dominate every tab, but still exactly one tap away.
- Both mechanisms call the same navigation (`Navigator.pushNamed(context,
  routeName.panic)`) already used today — no changes to `EmergencyFlow` or
  the no-ad guard logic.

## Compatibility approach

`InsightsScreen`, `LearnHubScreen`, and `SettingsScreen` currently each own
a `Scaffold` + `AppBar`. To embed them in the shell's `IndexedStack` without
double-`Scaffold` nesting, each is split into:
- A `*Body` widget (the actual content — provider setup, list/column, etc.)
  with no `Scaffold`/`AppBar` of its own.
- The original screen class becomes a thin wrapper: `Scaffold(appBar: ...,
  body: const *Body())` — kept around in case anything still pushes the
  route directly (e.g. deep links, tests), so no behavior is duplicated or
  lost.

`HomeScreen` is replaced outright by `MainShellScreen` (it's the route
target, not something pushed on top of itself).

## Testing

- Widget test: pumping `MainShellScreen` and tapping each of the 5
  bottom-nav items shows the correct tab body.
- Widget test: the SOS bar/shield is present on every tab and tapping it
  navigates to `routeName.panic`.
- No changes to data models, providers, or business logic — the existing
  161 unit tests should be unaffected. `flutter analyze` and `flutter test`
  must stay green before this is considered done (per project standard).

## Out of scope (explicitly deferred)

- Restyling detail/leaf screens (worksheets, article reader, session
  player, individual wellbeing modules, etc.) — only the 5 tab landing
  pages get the "Home refresh" treatment.
- Any new feature — this is IA/navigation only.
- Nested per-tab navigation stacks / preserving a back-stack per tab.
