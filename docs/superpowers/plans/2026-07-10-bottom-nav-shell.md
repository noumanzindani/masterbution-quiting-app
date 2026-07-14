# Bottom-Nav Shell Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace Momentum's single scrolling `HomeScreen` with a 5-tab bottom-navigation shell (Home / Insights / Tools / Learn / You) that surfaces the ~15 already-built feature areas, while keeping the "I need help right now" panic action one tap from every tab.

**Architecture:** A new `MainShellScreen` becomes the handler for the existing `'home'` route. It owns a `Scaffold` with a `BottomNavigationBar` and an `IndexedStack` of 5 tab-root widgets. Tapping into a tab still uses the existing `Navigator.pushNamed` — no nested navigators, no route-name changes, no changes to `AdGuardObserver` or the ad no-ad denylist.

**Tech Stack:** Flutter 3.41 / Dart 3.11.5, `provider` (already a dependency), existing `config.dart` theme/i18n helpers. No new packages.

## Global Constraints

- Package name `momentum`, Dart SDK `^3.11.5` — do not change.
- No new pub dependencies — everything needed (`provider`, `shared_preferences`, `flutter_test`) is already in `pubspec.yaml`.
- The route name string `'home'` (`RouteName.home`) must not change — `AdGuardObserver` and the lock/resume flow key off it.
- The Panic/SOS action must stay exactly one tap from every tab (clinical guardrail — see `hand.md`).
- Any new UI string key added to `AppFonts` must get an entry in `en.dart`, `ar.dart`, `fr.dart`, and `es.dart` — `test/i18n_content_test.dart` enforces this automatically for every key in `en`.
- `flutter analyze` must be clean (0 issues) and the full `flutter test` suite (161 existing tests + new ones) must pass before this is considered done.
- Conventional Commits (`feat:`/`fix:`/`chore:`) — but per this project's standing instruction, only actually run `git commit` during execution if the user has confirmed committing per task; otherwise stage locally and let the user commit.
- Design reference: `docs/superpowers/specs/2026-07-10-bottom-nav-shell-design.md`.

## Testing note (read before Task 5 and Task 9)

This codebase's existing test suite (161 tests) is 100% pure-Dart unit tests — there are zero existing widget tests that pump a screen backed by a live `Isar` database. `DashboardProvider` and `AnalyticsProvider` both hit Isar-backed repositories (`goalRepo`, `trackerRepo`) synchronously in their constructors, so widget-testing `HomeTabBody` or `InsightsBody`'s *provider-driven* content would require inventing an in-memory-Isar test harness this project has never used. That's out of scope for a navigation refactor (YAGNI) and would be the first such harness in the codebase.

Where a tab body has **no Isar-backed provider** (`ToolsTabBody`, `LearnHubBody`, `SettingsBody` — the latter only touches `SharedPreferences`, confirmed by reading `settings_provider.dart`), this plan writes real widget tests. Where a tab body **is** Isar-backed (`HomeTabBody`, `InsightsBody`, and the fully-wired `MainShellScreen`), this plan verifies via `flutter analyze` plus a manual on-device walkthrough (Task 12) — consistent with the project's own established testing boundary, and with the base instruction that UI changes must be verified by actually running the app, not just by type-checking.

---

### Task 1: Extract a shared `NavRow` widget

**Files:**
- Create: `lib/widgets/nav_row.dart`
- Test: `test/nav_row_test.dart`

**Interfaces:**
- Produces: `class NavRow extends StatelessWidget` with constructor `NavRow({required IconData icon, required String title, required String subtitle, required String route, required AppTheme theme})`. Renders a card; tapping it does `Navigator.pushNamed(context, route)`. Later tasks (Insights, Tools) import this from `package:momentum/widgets/nav_row.dart`.

- [ ] **Step 1: Write the failing test**

```dart
// test/nav_row_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/common/theme/app_theme.dart';
import 'package:momentum/widgets/nav_row.dart';

void main() {
  testWidgets('NavRow shows title/subtitle and pushes its route on tap',
      (tester) async {
    final theme = AppTheme.fromType(ThemeType.light);

    await tester.pumpWidget(MaterialApp(
      home: NavRow(
        icon: Icons.star,
        title: 'Habits',
        subtitle: 'Build wins',
        route: '/target',
        theme: theme,
      ),
      routes: {
        '/target': (_) => const Scaffold(body: Text('target screen')),
      },
    ));

    expect(find.text('Habits'), findsOneWidget);
    expect(find.text('Build wins'), findsOneWidget);

    await tester.tap(find.text('Habits'));
    await tester.pumpAndSettle();

    expect(find.text('target screen'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/nav_row_test.dart`
Expected: FAIL — `Target of URI doesn't exist: 'package:momentum/widgets/nav_row.dart'` (or similar "NavRow not found" compile error).

- [ ] **Step 3: Write minimal implementation**

```dart
// lib/widgets/nav_row.dart
import '../config.dart';

/// A tappable card row: icon, title, subtitle, chevron. Pushes [route] on tap.
/// Shared by the Tools/Insights tab landings.
class NavRow extends StatelessWidget {
  const NavRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
    required this.theme,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String route;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: theme.cardBg,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => Navigator.pushNamed(context, route),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: theme.stroke),
          ),
          child: Row(
            children: [
              Icon(icon, color: theme.primary, size: 24),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: appCss.titleSemi16.textColor(theme.darkText)),
                    Text(subtitle,
                        style: appCss.label12.textColor(theme.lightText)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: theme.lightText),
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/nav_row_test.dart`
Expected: PASS (1 test)

- [ ] **Step 5: Commit**

```bash
git add lib/widgets/nav_row.dart test/nav_row_test.dart
git commit -m "feat: extract shared NavRow widget for tab landings"
```

---

### Task 2: Add bottom-nav tab label translations

**Files:**
- Modify: `lib/common/app_fonts.dart`
- Modify: `lib/common/languages/en.dart`
- Modify: `lib/common/languages/ar.dart`
- Modify: `lib/common/languages/fr.dart`
- Modify: `lib/common/languages/es.dart`
- Test: `test/i18n_content_test.dart` (existing — no changes needed, it already loops over every key in `en`)

**Interfaces:**
- Produces: `appFonts.tabHome`, `appFonts.tabInsights`, `appFonts.tabTools`, `appFonts.tabLearn`, `appFonts.tabYou` — five new `String` key constants. `MainShellScreen` (Task 10) calls `language(context, appFonts.tabHome)` etc. for both the bottom-nav labels and the app-bar titles.

- [ ] **Step 1: Add the keys to English only, leave other locales untouched**

Edit `lib/common/app_fonts.dart` — add before the closing `}`:

```dart
  // Bottom-nav tab labels
  final String tabHome = 'tabHome';
  final String tabInsights = 'tabInsights';
  final String tabTools = 'tabTools';
  final String tabLearn = 'tabLearn';
  final String tabYou = 'tabYou';
```

Edit `lib/common/languages/en.dart` — add before the closing `};`:

```dart
  'tabHome': 'Home',
  'tabInsights': 'Insights',
  'tabTools': 'Tools',
  'tabLearn': 'Learn',
  'tabYou': 'You',
```

- [ ] **Step 2: Run the i18n test to verify it fails (RED — ar/fr/es are now missing keys)**

Run: `flutter test test/i18n_content_test.dart`
Expected: FAIL — `ar is missing "tabHome"` (and the same for fr, es, and each of the other 4 keys).

- [ ] **Step 3: Add the same keys to ar.dart, fr.dart, es.dart**

Edit `lib/common/languages/ar.dart` — add before the closing `};`:

```dart
  'tabHome': 'الرئيسية',
  'tabInsights': 'الإحصاءات',
  'tabTools': 'الأدوات',
  'tabLearn': 'تعلّم',
  'tabYou': 'أنت',
```

Edit `lib/common/languages/fr.dart` — add before the closing `};`:

```dart
  'tabHome': 'Accueil',
  'tabInsights': 'Aperçus',
  'tabTools': 'Outils',
  'tabLearn': 'Apprendre',
  'tabYou': 'Vous',
```

Edit `lib/common/languages/es.dart` — add before the closing `};`:

```dart
  'tabHome': 'Inicio',
  'tabInsights': 'Estadísticas',
  'tabTools': 'Herramientas',
  'tabLearn': 'Aprender',
  'tabYou': 'Tú',
```

- [ ] **Step 4: Run the i18n test to verify it passes (GREEN)**

Run: `flutter test test/i18n_content_test.dart`
Expected: PASS (all UI-string-map tests green)

- [ ] **Step 5: Commit**

```bash
git add lib/common/app_fonts.dart lib/common/languages/en.dart lib/common/languages/ar.dart lib/common/languages/fr.dart lib/common/languages/es.dart
git commit -m "feat: add bottom-nav tab label translations (en/ar/fr/es)"
```

---

### Task 3: Build the SOS bar and SOS floating button

**Files:**
- Create: `lib/screens/shell/sos_widgets.dart`
- Test: `test/sos_widgets_test.dart`

**Interfaces:**
- Consumes: `PrimaryButton` from `lib/widgets/primary_button.dart` (existing).
- Produces: `class SosBar extends StatelessWidget` (`{required VoidCallback onTap, required AppTheme theme}`) and `class SosFab extends StatelessWidget` (same constructor shape). `MainShellScreen` (Task 10) uses both.

- [ ] **Step 1: Write the failing test**

```dart
// test/sos_widgets_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/common/theme/app_theme.dart';
import 'package:momentum/screens/shell/sos_widgets.dart';

void main() {
  final theme = AppTheme.fromType(ThemeType.light);

  testWidgets('SosBar shows the help label and calls onTap', (tester) async {
    var tapped = false;
    await tester.pumpWidget(MaterialApp(
      home: SosBar(theme: theme, onTap: () => tapped = true),
    ));

    expect(find.text('I need help right now'), findsOneWidget);

    await tester.tap(find.text('I need help right now'));
    expect(tapped, isTrue);
  });

  testWidgets('SosFab shows a shield icon and calls onTap', (tester) async {
    var tapped = false;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        floatingActionButton:
            SosFab(theme: theme, onTap: () => tapped = true),
      ),
    ));

    expect(find.byIcon(Icons.shield_outlined), findsOneWidget);

    await tester.tap(find.byType(SosFab));
    expect(tapped, isTrue);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/sos_widgets_test.dart`
Expected: FAIL — `Target of URI doesn't exist: 'package:momentum/screens/shell/sos_widgets.dart'`

- [ ] **Step 3: Write minimal implementation**

```dart
// lib/screens/shell/sos_widgets.dart
import '../../config.dart';
import '../../widgets/primary_button.dart';

/// Full-width "I need help right now" bar — the Home tab's persistent,
/// one-tap path to the panic flow. Pinned above the tab content (the bottom
/// slot is occupied by the bottom-nav bar).
class SosBar extends StatelessWidget {
  const SosBar({super.key, required this.onTap, required this.theme});

  final VoidCallback onTap;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      color: theme.scaffoldBg,
      child: PrimaryButton(
        label: 'I need help right now',
        icon: Icons.shield_outlined,
        color: theme.accent,
        onPressed: onTap,
      ),
    );
  }
}

/// Small floating shield button shown on every non-Home tab — keeps the panic
/// flow exactly one tap away without repeating the full-width bar on every
/// screen.
class SosFab extends StatelessWidget {
  const SosFab({super.key, required this.onTap, required this.theme});

  final VoidCallback onTap;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'sosFab',
      backgroundColor: theme.accent,
      onPressed: onTap,
      child: const Icon(Icons.shield_outlined, color: Colors.white),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/sos_widgets_test.dart`
Expected: PASS (2 tests)

- [ ] **Step 5: Commit**

```bash
git add lib/screens/shell/sos_widgets.dart test/sos_widgets_test.dart
git commit -m "feat: add SosBar and SosFab — persistent one-tap panic access"
```

---

### Task 4: Build the pure `TabShellScaffold`

**Files:**
- Create: `lib/screens/shell/tab_shell_scaffold.dart`
- Test: `test/tab_shell_scaffold_test.dart`

**Interfaces:**
- Consumes: `ThemeService` via `appColor(context)` (existing, from `config.dart`).
- Produces: `class TabShellScaffold extends StatefulWidget` with constructor:
  ```dart
  TabShellScaffold({
    required List<Widget> tabs,
    required List<BottomNavigationBarItem> items,
    String Function(int index)? appBarTitleFor,
    Widget? Function(int index)? topBannerFor,
    Widget? Function(int index)? floatingActionFor,
    int initialIndex = 0,
  })
  ```
  `MainShellScreen` (Task 10) wraps the 5 real tab bodies in this.

- [ ] **Step 1: Write the failing test**

```dart
// test/tab_shell_scaffold_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:momentum/common/theme/theme_service.dart';
import 'package:momentum/screens/shell/tab_shell_scaffold.dart';

Future<Widget> _harness(Widget child) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  return ChangeNotifierProvider(
    create: (_) => ThemeService(prefs),
    child: MaterialApp(home: child),
  );
}

void main() {
  testWidgets('tapping a nav item switches the IndexedStack index',
      (tester) async {
    await tester.pumpWidget(await _harness(
      const TabShellScaffold(
        tabs: [Text('tab 0'), Text('tab 1'), Text('tab 2')],
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'A'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'B'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'C'),
        ],
      ),
    ));

    expect(tester.widget<IndexedStack>(find.byType(IndexedStack)).index, 0);

    await tester.tap(find.text('B'));
    await tester.pumpAndSettle();

    expect(tester.widget<IndexedStack>(find.byType(IndexedStack)).index, 1);
  });

  testWidgets('topBannerFor and floatingActionFor receive the selected index',
      (tester) async {
    await tester.pumpWidget(await _harness(
      TabShellScaffold(
        tabs: const [Text('tab 0'), Text('tab 1')],
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'A'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'B'),
        ],
        topBannerFor: (i) => i == 0 ? const Text('banner') : null,
        floatingActionFor: (i) => i == 1 ? const Text('fab') : null,
      ),
    ));

    expect(find.text('banner'), findsOneWidget);
    expect(find.text('fab'), findsNothing);

    await tester.tap(find.text('B'));
    await tester.pumpAndSettle();

    expect(find.text('banner'), findsNothing);
    expect(find.text('fab'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/tab_shell_scaffold_test.dart`
Expected: FAIL — `Target of URI doesn't exist: 'package:momentum/screens/shell/tab_shell_scaffold.dart'`

- [ ] **Step 3: Write minimal implementation**

```dart
// lib/screens/shell/tab_shell_scaffold.dart
import '../../config.dart';

/// Pure, reusable bottom-navigation shell. Owns the [BottomNavigationBar] and
/// switches between [tabs] via an [IndexedStack] so each tab's scroll position
/// and provider state survive switching. Has no dependency on any specific
/// screen — [MainShellScreen] wires the real app tabs into it.
class TabShellScaffold extends StatefulWidget {
  const TabShellScaffold({
    super.key,
    required this.tabs,
    required this.items,
    this.appBarTitleFor,
    this.topBannerFor,
    this.floatingActionFor,
    this.initialIndex = 0,
  });

  final List<Widget> tabs;
  final List<BottomNavigationBarItem> items;
  final String Function(int index)? appBarTitleFor;
  final Widget? Function(int index)? topBannerFor;
  final Widget? Function(int index)? floatingActionFor;
  final int initialIndex;

  @override
  State<TabShellScaffold> createState() => _TabShellScaffoldState();
}

class _TabShellScaffoldState extends State<TabShellScaffold> {
  late int _index = widget.initialIndex;

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    final banner = widget.topBannerFor?.call(_index);

    return Scaffold(
      backgroundColor: theme.scaffoldBg,
      appBar: widget.appBarTitleFor == null
          ? null
          : AppBar(
              title: Text(widget.appBarTitleFor!(_index),
                  style: appCss.headingBold22.textColor(theme.darkText)),
            ),
      body: Column(
        children: [
          if (banner != null) banner,
          Expanded(
            child: IndexedStack(index: _index, children: widget.tabs),
          ),
        ],
      ),
      floatingActionButton: widget.floatingActionFor?.call(_index),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: theme.cardBg,
        selectedItemColor: theme.primary,
        unselectedItemColor: theme.lightText,
        items: widget.items,
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/tab_shell_scaffold_test.dart`
Expected: PASS (2 tests)

- [ ] **Step 5: Commit**

```bash
git add lib/screens/shell/tab_shell_scaffold.dart test/tab_shell_scaffold_test.dart
git commit -m "feat: add pure TabShellScaffold (bottom-nav + IndexedStack shell)"
```

---

### Task 5: Extract `InsightsBody` and add Habits/Mood quick links

**Files:**
- Modify: `lib/screens/insights/insights_screen.dart` (full rewrite of the file)

**Interfaces:**
- Consumes: `NavRow` (Task 1), `AnalyticsProvider` (existing).
- Produces: `class InsightsBody extends StatelessWidget` (no constructor args) — the Insights tab's root content. `InsightsScreen` becomes a thin `Scaffold` wrapper around it (kept for any direct route push).

**Design note:** the two new quick-link cards (Habits, Mood journal) are shown unconditionally, even when `!p.hasEnoughData` — they're useful entry points before there's enough data for analytics, not just after. Everything else in this file (heatmap, trigger bars, weekly trend, empty state) is carried over unchanged.

- [ ] **Step 1: Rewrite the file**

```dart
// lib/screens/insights/insights_screen.dart
import 'package:fl_chart/fl_chart.dart';

import '../../config.dart';
import '../../data/trigger_labels.dart';
import '../../providers/analytics_provider.dart';
import '../../services/analytics_engine.dart';
import '../../widgets/ad/banner_ad_widget.dart';
import '../../widgets/nav_row.dart';

/// "Make the data meaningful" — descriptive patterns from the event log:
/// gated insight cards, a when-urges-hit heatmap, common triggers, and a weekly
/// trend. Non-crisis screen, so a banner is allowed (still policy-gated).
///
/// Thin wrapper around [InsightsBody] so the route still works if pushed
/// directly; [MainShellScreen] embeds [InsightsBody] as the Insights tab.
class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBg,
      appBar: AppBar(
        title: Text('Insights',
            style: appCss.headingBold22.textColor(theme.darkText)),
      ),
      body: const InsightsBody(),
    );
  }
}

/// The Insights tab's content — patterns/analytics plus quick links to the
/// two other "track yourself" screens (Habits, Mood journal).
class InsightsBody extends StatelessWidget {
  const InsightsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AnalyticsProvider(),
      child: const _InsightsView(),
    );
  }
}

class _InsightsView extends StatelessWidget {
  const _InsightsView();

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    final p = context.watch<AnalyticsProvider>();

    return p.loading
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              NavRow(
                icon: Icons.task_alt_rounded,
                title: 'Habits',
                subtitle: 'Build wins alongside recovery',
                route: routeName.habits,
                theme: theme,
              ),
              const SizedBox(height: 10),
              NavRow(
                icon: Icons.mood_rounded,
                title: 'Mood journal',
                subtitle: 'Notice and name how you feel',
                route: routeName.moodJournal,
                theme: theme,
              ),
              const SizedBox(height: 16),
              if (!p.hasEnoughData)
                _EmptyState(theme: theme)
              else ...[
                if (p.insights.isNotEmpty) ...[
                  for (final i in p.insights)
                    _InsightCard(text: i.text, theme: theme),
                  const SizedBox(height: 12),
                ],
                _Section(
                  title: 'When urges tend to hit',
                  subtitle: 'Darker = more slips logged at that time.',
                  theme: theme,
                  child: _Heatmap(grid: p.lapseHeatmap, theme: theme),
                ),
                if (p.topTriggers.isNotEmpty)
                  _Section(
                    title: 'Most common triggers',
                    theme: theme,
                    child: _TriggerBars(data: p.topTriggers, theme: theme),
                  ),
                _Section(
                  title: 'Slips per week',
                  subtitle: p.weeklyTrend.slope < -0.05
                      ? 'Trending down — the direction that matters. (estimate)'
                      : p.weeklyTrend.slope > 0.05
                          ? 'Ticking up lately — worth a gentle check-in. (estimate)'
                          : 'Holding steady. (estimate)',
                  theme: theme,
                  child: _WeeklyTrend(weekly: p.weeklyLapses, theme: theme),
                ),
              ],
              const SizedBox(height: 12),
              const Center(child: BannerAdWidget()),
            ],
          );
  }
}

// --- sections ---------------------------------------------------------------

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    this.subtitle,
    required this.child,
    required this.theme,
  });
  final String title;
  final String? subtitle;
  final Widget child;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: appCss.titleSemi16.textColor(theme.darkText)),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle!, style: appCss.label12.textColor(theme.lightText)),
          ],
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({required this.text, required this.theme});
  final String text;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.primarySoft,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline_rounded, color: theme.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: appCss.body14.textColor(theme.darkText)),
          ),
        ],
      ),
    );
  }
}

// --- heatmap ----------------------------------------------------------------

class _Heatmap extends StatelessWidget {
  const _Heatmap({required this.grid, required this.theme});
  final List<List<int>> grid;
  final AppTheme theme;

  static const _days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  int get _max {
    var m = 0;
    for (final row in grid) {
      for (final c in row) {
        if (c > m) m = c;
      }
    }
    return m;
  }

  @override
  Widget build(BuildContext context) {
    final max = _max;
    return Column(
      children: [
        for (var d = 0; d < 7; d++)
          Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Row(
              children: [
                SizedBox(
                  width: 16,
                  child: Text(_days[d],
                      style: appCss.label12.textColor(theme.lightText)),
                ),
                const SizedBox(width: 4),
                for (var h = 0; h < 24; h++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.6),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: _cellColor(grid[d][h], max),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final label in ['12a', '6a', '12p', '6p', '11p'])
                Text(label, style: appCss.label12.textColor(theme.lightText)),
            ],
          ),
        ),
      ],
    );
  }

  Color _cellColor(int count, int max) {
    if (count == 0 || max == 0) return theme.fieldBg;
    final t = count / max;
    return theme.primary.withValues(alpha: 0.2 + 0.8 * t);
  }
}

// --- trigger bars -----------------------------------------------------------

class _TriggerBars extends StatelessWidget {
  const _TriggerBars({required this.data, required this.theme});
  final List<TriggerCount> data;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    final max = data.isEmpty ? 1 : data.first.count;
    return Column(
      children: [
        for (final tc in data)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 96,
                  child: Text(triggerLabel(tc.trigger),
                      style: appCss.body14.textColor(theme.darkText)),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: max == 0 ? 0 : tc.count / max,
                      minHeight: 10,
                      backgroundColor: theme.fieldBg,
                      valueColor: AlwaysStoppedAnimation(theme.primary),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text('${tc.count}',
                    style: appCss.label12.textColor(theme.lightText)),
              ],
            ),
          ),
      ],
    );
  }
}

// --- weekly trend (fl_chart) ------------------------------------------------

class _WeeklyTrend extends StatelessWidget {
  const _WeeklyTrend({required this.weekly, required this.theme});
  final List<int> weekly;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    final maxY = (weekly.isEmpty ? 0 : weekly.reduce((a, b) => a > b ? a : b))
        .toDouble();
    return SizedBox(
      height: 140,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: maxY < 3 ? 3 : maxY + 1,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) =>
                FlLine(color: theme.stroke, strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final i = value.toInt();
                  final weeksAgo = weekly.length - 1 - i;
                  final label = weeksAgo == 0 ? 'now' : '-${weeksAgo}w';
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(label,
                        style: appCss.label12.textColor(theme.lightText)),
                  );
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: [
                for (var i = 0; i < weekly.length; i++)
                  FlSpot(i.toDouble(), weekly[i].toDouble()),
              ],
              isCurved: true,
              color: theme.primary,
              barWidth: 3,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: theme.primary.withValues(alpha: 0.12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- empty state ------------------------------------------------------------

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.theme});
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.insights_rounded, size: 48, color: theme.primary),
            const SizedBox(height: 16),
            Text('Patterns are on their way',
                style: appCss.titleSemi18.textColor(theme.darkText)),
            const SizedBox(height: 8),
            Text(
              'Keep logging urges and check-ins. Once there’s enough to be meaningful, your personal patterns show up here — never before, so nothing here is guesswork.',
              textAlign: TextAlign.center,
              style: appCss.body14.textColor(theme.lightText),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Verify it compiles clean**

Run: `flutter analyze lib/screens/insights/insights_screen.dart`
Expected: `No issues found!`

- [ ] **Step 3: Run the full test suite to confirm no regressions**

Run: `flutter test`
Expected: all existing tests still PASS (this file has no dedicated widget test — see the "Testing note" above; `AnalyticsProvider` is Isar-backed).

- [ ] **Step 4: Commit**

```bash
git add lib/screens/insights/insights_screen.dart
git commit -m "refactor: extract InsightsBody, add Habits/Mood quick links"
```

---

### Task 6: Extract `LearnHubBody`

**Files:**
- Modify: `lib/screens/learn/learn_hub_screen.dart` (full rewrite)
- Test: `test/learn_hub_body_test.dart`

**Interfaces:**
- Produces: `class LearnHubBody extends StatelessWidget` (no constructor args). `LearnHubScreen` becomes a thin `Scaffold` wrapper around it.

- [ ] **Step 1: Write the failing test**

```dart
// test/learn_hub_body_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:momentum/common/theme/theme_service.dart';
import 'package:momentum/routes/route_name.dart';
import 'package:momentum/screens/learn/learn_hub_screen.dart';

void main() {
  testWidgets('LearnHubBody lists all seven content hubs and navigates on tap',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final r = RouteName();

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeService(prefs),
        child: MaterialApp(
          home: const LearnHubBody(),
          routes: {
            r.academy: (_) => const Scaffold(body: Text('academy')),
            r.cbt: (_) => const Scaffold(body: Text('cbt')),
            r.alternatives: (_) => const Scaffold(body: Text('alts')),
            r.sessions: (_) => const Scaffold(body: Text('sessions')),
            r.program: (_) => const Scaffold(body: Text('program')),
            r.values: (_) => const Scaffold(body: Text('values')),
            r.motivation: (_) => const Scaffold(body: Text('motivation')),
          },
        ),
      ),
    );

    expect(find.text('Academy'), findsOneWidget);
    expect(find.text('CBT toolkit'), findsOneWidget);
    expect(find.text('Instead of… '), findsOneWidget);
    expect(find.text('Guided sessions'), findsOneWidget);
    expect(find.text('7-day dopamine reset'), findsOneWidget);
    expect(find.text('Your values'), findsOneWidget);
    expect(find.text('Motivation'), findsOneWidget);

    await tester.tap(find.text('CBT toolkit'));
    await tester.pumpAndSettle();
    expect(find.text('cbt'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/learn_hub_body_test.dart`
Expected: FAIL — `LearnHubBody` is not defined.

- [ ] **Step 3: Rewrite the file**

```dart
// lib/screens/learn/learn_hub_screen.dart
import '../../config.dart';
import '../../widgets/ad/banner_ad_widget.dart';

/// The "Learn" hub — entry point to the content library. Non-crisis screen.
///
/// Thin wrapper around [LearnHubBody] so the route still works if pushed
/// directly; [MainShellScreen] embeds [LearnHubBody] as the Learn tab.
class LearnHubScreen extends StatelessWidget {
  const LearnHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBg,
      appBar: AppBar(
        title: Text('Learn',
            style: appCss.headingBold22.textColor(theme.darkText)),
      ),
      body: const LearnHubBody(),
    );
  }
}

/// The Learn tab's content — content-library entry points.
class LearnHubBody extends StatelessWidget {
  const LearnHubBody({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        _HubTile(
          icon: Icons.menu_book_rounded,
          title: 'Academy',
          subtitle: 'Short lessons, plus quizzes to test yourself',
          route: routeName.academy,
          theme: theme,
        ),
        _HubTile(
          icon: Icons.psychology_rounded,
          title: 'CBT toolkit',
          subtitle: 'Worksheets to examine thoughts and triggers',
          route: routeName.cbt,
          theme: theme,
        ),
        _HubTile(
          icon: Icons.bolt_rounded,
          title: 'Instead of… ',
          subtitle: 'Healthy things to do with the time you have',
          route: routeName.alternatives,
          theme: theme,
        ),
        _HubTile(
          icon: Icons.headphones_rounded,
          title: 'Guided sessions',
          subtitle: 'Short, self-paced calming practices',
          route: routeName.sessions,
          theme: theme,
        ),
        _HubTile(
          icon: Icons.restart_alt_rounded,
          title: '7-day dopamine reset',
          subtitle: 'Let your reward system recalibrate',
          route: routeName.program,
          theme: theme,
        ),
        _HubTile(
          icon: Icons.explore_rounded,
          title: 'Your values',
          subtitle: 'What you\'re moving toward',
          route: routeName.values,
          theme: theme,
        ),
        _HubTile(
          icon: Icons.auto_awesome_rounded,
          title: 'Motivation',
          subtitle: 'A daily quote and real success stories',
          route: routeName.motivation,
          theme: theme,
        ),
        const SizedBox(height: 20),
        const Center(child: BannerAdWidget()),
      ],
    );
  }
}

class _HubTile extends StatelessWidget {
  const _HubTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
    required this.theme,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;
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
          onTap: () => Navigator.pushNamed(context, route),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: theme.stroke),
            ),
            child: Row(
              children: [
                Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    color: theme.primarySoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: theme.primary),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: appCss.titleSemi16.textColor(theme.darkText)),
                      const SizedBox(height: 2),
                      Text(subtitle,
                          style: appCss.label12.textColor(theme.lightText)),
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

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/learn_hub_body_test.dart`
Expected: PASS (1 test)

- [ ] **Step 5: Commit**

```bash
git add lib/screens/learn/learn_hub_screen.dart test/learn_hub_body_test.dart
git commit -m "refactor: extract LearnHubBody for the Learn tab"
```

---

### Task 7: Extract `SettingsBody`

**Files:**
- Modify: `lib/screens/settings/settings_screen.dart` (full rewrite)
- Test: `test/settings_body_test.dart`

**Interfaces:**
- Consumes: `SettingsProvider` (existing, `SharedPreferences`-only — confirmed no Isar dependency), `ThemeService`, `LanguageProvider`.
- Produces: `class SettingsBody extends StatelessWidget` (no constructor args). `SettingsScreen` becomes a thin `Scaffold` wrapper around it.

- [ ] **Step 1: Write the failing test**

```dart
// test/settings_body_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:momentum/common/languages/language_provider.dart';
import 'package:momentum/common/theme/theme_service.dart';
import 'package:momentum/config.dart' as cfg;
import 'package:momentum/providers/settings_provider.dart';
import 'package:momentum/screens/settings/settings_screen.dart';

void main() {
  testWidgets('SettingsBody shows privacy, data and support sections',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefsInstance = await SharedPreferences.getInstance();
    cfg.prefs = prefsInstance;

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeService(prefsInstance)),
          ChangeNotifierProvider(
              create: (_) => LanguageProvider(prefsInstance)),
          ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ],
        child: const MaterialApp(home: Scaffold(body: SettingsBody())),
      ),
    );

    expect(find.text('App lock'), findsOneWidget);
    expect(find.text('Discreet mode'), findsOneWidget);
    expect(find.text('Backup & export'), findsOneWidget);
    expect(find.text('Accountability partner'), findsOneWidget);
    expect(find.text('Therapy notes'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/settings_body_test.dart`
Expected: FAIL — `SettingsBody` is not defined.

- [ ] **Step 3: Rewrite the file**

```dart
// lib/screens/settings/settings_screen.dart
import 'package:local_auth/local_auth.dart';

import '../../config.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/ad/banner_ad_widget.dart';
import '../lock/lock_screen.dart';

/// Privacy, security and appearance settings. A non-crisis screen, so a banner
/// is allowed here (still policy-gated).
///
/// Thin wrapper around [SettingsBody] so the route still works if pushed
/// directly; [MainShellScreen] embeds [SettingsBody] as the You tab.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBg,
      appBar: AppBar(
        title: Text(language(context, appFonts.settings),
            style: appCss.headingBold22.textColor(theme.darkText)),
      ),
      body: const SettingsBody(),
    );
  }
}

/// The You tab's content — privacy/security, appearance, reminders, language,
/// data (backup, accountability, therapy notes) and support.
class SettingsBody extends StatelessWidget {
  const SettingsBody({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    final settings = context.watch<SettingsProvider>();
    final themeService = context.watch<ThemeService>();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        _SectionLabel('Privacy & security', theme: theme),
        _SettingCard(
          theme: theme,
          children: [
            _SwitchRow(
              icon: Icons.lock_outline_rounded,
              title: 'App lock',
              subtitle: 'Require a PIN to open Momentum',
              value: settings.appLockEnabled,
              theme: theme,
              onChanged: (v) => _toggleLock(context, settings, v),
            ),
            if (settings.appLockEnabled) ...[
              _Divider(theme: theme),
              _SwitchRow(
                icon: Icons.fingerprint_rounded,
                title: 'Unlock with biometrics',
                subtitle: 'Face ID / fingerprint',
                value: settings.biometricEnabled,
                theme: theme,
                onChanged: (v) => _toggleBiometric(context, settings, v),
              ),
            ],
            _Divider(theme: theme),
            _SwitchRow(
              icon: Icons.visibility_off_outlined,
              title: 'Discreet mode',
              subtitle: 'Show a neutral icon on your home screen',
              value: settings.discreetMode,
              theme: theme,
              onChanged: settings.setDiscreet,
            ),
          ],
        ),
        const SizedBox(height: 20),
        _SectionLabel('Appearance', theme: theme),
        _SettingCard(
          theme: theme,
          children: [
            _ThemePicker(
              index: themeService.themeIndex,
              onChanged: themeService.setThemeIndex,
              theme: theme,
            ),
          ],
        ),
        const SizedBox(height: 20),
        _SectionLabel('Reminders', theme: theme),
        _SettingCard(
          theme: theme,
          children: [
            _SwitchRow(
              icon: Icons.notifications_none_rounded,
              title: 'Smart reminders',
              subtitle:
                  'Gentle, private check-ins timed around your own patterns',
              value: settings.notificationsEnabled,
              theme: theme,
              onChanged: (v) => settings.setNotificationsEnabled(v),
            ),
            if (settings.notificationsEnabled) ...[
              _Divider(theme: theme),
              _LinkRow(
                icon: Icons.schedule_rounded,
                title: 'Daily check-in time',
                trailing: _fmtHour(settings.checkInHour),
                theme: theme,
                onTap: () => _pickCheckInHour(context, settings),
              ),
            ],
          ],
        ),
        const SizedBox(height: 20),
        _SectionLabel('Language', theme: theme),
        _SettingCard(
          theme: theme,
          children: [
            _LanguagePicker(
              current: context.watch<LanguageProvider>().localeCode,
              onChanged: (code) {
                context.read<LanguageProvider>().setLocale(code);
                // Re-localize bundled content (falls back to English per file).
                contentService.reloadForLocale(code);
              },
              theme: theme,
            ),
          ],
        ),
        const SizedBox(height: 20),
        _SectionLabel('Data', theme: theme),
        _SettingCard(
          theme: theme,
          children: [
            _LinkRow(
              icon: Icons.backup_outlined,
              title: 'Backup & export',
              theme: theme,
              onTap: () => route.pushNamed(context, routeName.backup),
            ),
            _Divider(theme: theme),
            _LinkRow(
              icon: Icons.people_alt_outlined,
              title: 'Accountability partner',
              theme: theme,
              onTap: () => route.pushNamed(context, routeName.accountability),
            ),
            _Divider(theme: theme),
            _LinkRow(
              icon: Icons.medical_services_outlined,
              title: 'Therapy notes',
              theme: theme,
              onTap: () =>
                  route.pushNamed(context, routeName.professionalNotes),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _SectionLabel('Support', theme: theme),
        _SettingCard(
          theme: theme,
          children: [
            _LinkRow(
              icon: Icons.support_agent_rounded,
              title: language(context, appFonts.crisisResources),
              theme: theme,
              onTap: () =>
                  route.pushNamed(context, routeName.crisisResources),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: theme.primarySoft,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            language(context, appFonts.notMedicalCare),
            style: appCss.label12.textColor(theme.darkText),
          ),
        ),
        const SizedBox(height: 20),
        const Center(child: BannerAdWidget()),
      ],
    );
  }

  Future<void> _pickCheckInHour(
      BuildContext context, SettingsProvider settings) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: settings.checkInHour, minute: 0),
      helpText: 'Daily check-in time',
    );
    if (picked != null) await settings.setCheckInHour(picked.hour);
  }

  Future<void> _toggleLock(
      BuildContext context, SettingsProvider settings, bool enable) async {
    if (enable) {
      // Launch the PIN-setup flow; the provider flips the flag on success.
      await route.pushNamed(context, routeName.lock,
          args: const LockArgs(setup: true));
    } else {
      await settings.disableLock();
    }
  }

  Future<void> _toggleBiometric(
      BuildContext context, SettingsProvider settings, bool enable) async {
    if (!enable) {
      await settings.setBiometric(false);
      return;
    }
    final auth = LocalAuthentication();
    bool available = false;
    try {
      available = await auth.isDeviceSupported() &&
          await auth.canCheckBiometrics;
    } catch (_) {
      available = false;
    }
    if (!context.mounted) return;
    if (available) {
      await settings.setBiometric(true);
    } else {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(
            content: Text('No biometrics enrolled on this device.')));
    }
  }
}

// --- Building blocks --------------------------------------------------------

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text, {required this.theme});
  final String text;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(text.toUpperCase(),
          style: appCss.label12.textColor(theme.lightText)),
    );
  }
}

class _SettingCard extends StatelessWidget {
  const _SettingCard({required this.children, required this.theme});
  final List<Widget> children;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.stroke),
      ),
      child: Column(children: children),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({required this.theme});
  final AppTheme theme;
  @override
  Widget build(BuildContext context) =>
      Divider(height: 1, thickness: 1, color: theme.stroke, indent: 16, endIndent: 16);
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.theme,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: theme.primary, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: appCss.titleSemi16.textColor(theme.darkText)),
                Text(subtitle,
                    style: appCss.label12.textColor(theme.lightText)),
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: theme.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _LanguagePicker extends StatelessWidget {
  const _LanguagePicker({
    required this.current,
    required this.onChanged,
    required this.theme,
  });
  final String current;
  final ValueChanged<String> onChanged;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final l in LanguageProvider.available)
          InkWell(
            onTap: () => onChanged(l.code),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(l.label,
                        style: appCss.titleSemi16.textColor(theme.darkText)),
                  ),
                  if (l.code == current)
                    Icon(Icons.check_rounded, color: theme.primary),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// 24h hour → a friendly "8:00 PM" label.
String _fmtHour(int hour24) {
  final period = hour24 < 12 ? 'AM' : 'PM';
  var h = hour24 % 12;
  if (h == 0) h = 12;
  return '$h:00 $period';
}

class _LinkRow extends StatelessWidget {
  const _LinkRow({
    required this.icon,
    required this.title,
    required this.onTap,
    required this.theme,
    this.trailing,
  });
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final AppTheme theme;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: theme.primary, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(title,
                  style: appCss.titleSemi16.textColor(theme.darkText)),
            ),
            if (trailing != null) ...[
              Text(trailing!, style: appCss.body14.textColor(theme.primary)),
              const SizedBox(width: 6),
            ],
            Icon(Icons.chevron_right_rounded, color: theme.lightText),
          ],
        ),
      ),
    );
  }
}

class _ThemePicker extends StatelessWidget {
  const _ThemePicker({
    required this.index,
    required this.onChanged,
    required this.theme,
  });
  final int index;
  final ValueChanged<int> onChanged;
  final AppTheme theme;

  static const _labels = ['Light', 'Dark', 'System'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          for (var i = 0; i < _labels.length; i++)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(i),
                child: Container(
                  margin: EdgeInsets.only(right: i < 2 ? 8 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: i == index ? theme.primary : theme.fieldBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _labels[i],
                    textAlign: TextAlign.center,
                    style: appCss.medium14
                        .textColor(i == index ? Colors.white : theme.darkText),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/settings_body_test.dart`
Expected: PASS (1 test)

- [ ] **Step 5: Commit**

```bash
git add lib/screens/settings/settings_screen.dart test/settings_body_test.dart
git commit -m "refactor: extract SettingsBody for the You tab"
```

---

### Task 8: Build `ToolsTabBody`

**Files:**
- Create: `lib/screens/shell/tools_tab_screen.dart`
- Test: `test/tools_tab_body_test.dart`

**Interfaces:**
- Consumes: `NavRow` (Task 1).
- Produces: `class ToolsTabBody extends StatelessWidget` (no constructor args) — the Tools tab's root content.

- [ ] **Step 1: Write the failing test**

```dart
// test/tools_tab_body_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:momentum/common/theme/theme_service.dart';
import 'package:momentum/routes/route_name.dart';
import 'package:momentum/screens/shell/tools_tab_screen.dart';

void main() {
  testWidgets('lists all six tool destinations and navigates on tap',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final r = RouteName();

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeService(prefs),
        child: MaterialApp(
          home: const ToolsTabBody(),
          routes: {
            r.coachHub: (_) => const Scaffold(body: Text('coach hub')),
            r.dailyPlanner: (_) => const Scaffold(body: Text('planner')),
            r.wellbeing: (_) => const Scaffold(body: Text('wellbeing')),
            r.sleepLog: (_) => const Scaffold(body: Text('sleep')),
            r.rewards: (_) => const Scaffold(body: Text('rewards')),
            r.alternatives: (_) => const Scaffold(body: Text('alts')),
          },
        ),
      ),
    );

    expect(find.text('Coach & check-ins'), findsOneWidget);
    expect(find.text('Daily planner'), findsOneWidget);
    expect(find.text('Wellbeing'), findsOneWidget);
    expect(find.text('Sleep'), findsOneWidget);
    expect(find.text('Milestones & rewards'), findsOneWidget);
    expect(find.text('Healthy alternatives'), findsOneWidget);

    await tester.tap(find.text('Sleep'));
    await tester.pumpAndSettle();
    expect(find.text('sleep'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/tools_tab_body_test.dart`
Expected: FAIL — `Target of URI doesn't exist: 'package:momentum/screens/shell/tools_tab_screen.dart'`

- [ ] **Step 3: Write minimal implementation**

```dart
// lib/screens/shell/tools_tab_screen.dart
import '../../config.dart';
import '../../widgets/ad/banner_ad_widget.dart';
import '../../widgets/nav_row.dart';

/// The Tools tab's content — the "things you actively do" cluster: coaching,
/// planning, wellbeing modules, sleep tracking, rewards, and healthy
/// alternatives. All content already exists; this just gives it a home.
class ToolsTabBody extends StatelessWidget {
  const ToolsTabBody({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        NavRow(
          icon: Icons.forum_rounded,
          title: 'Coach & check-ins',
          subtitle: 'Talk it through, reflect, and plan your day',
          route: routeName.coachHub,
          theme: theme,
        ),
        const SizedBox(height: 10),
        NavRow(
          icon: Icons.event_note_rounded,
          title: 'Daily planner',
          subtitle: 'Shape the day ahead',
          route: routeName.dailyPlanner,
          theme: theme,
        ),
        const SizedBox(height: 10),
        NavRow(
          icon: Icons.spa_rounded,
          title: 'Wellbeing',
          subtitle: 'Mindfulness, self-esteem, relationships, and more',
          route: routeName.wellbeing,
          theme: theme,
        ),
        const SizedBox(height: 10),
        NavRow(
          icon: Icons.bedtime_rounded,
          title: 'Sleep',
          subtitle: 'Track rest and get rule-based tips',
          route: routeName.sleepLog,
          theme: theme,
        ),
        const SizedBox(height: 10),
        NavRow(
          icon: Icons.emoji_events_rounded,
          title: 'Milestones & rewards',
          subtitle: 'Badges you\'ve earned and themes to unlock',
          route: routeName.rewards,
          theme: theme,
        ),
        const SizedBox(height: 10),
        NavRow(
          icon: Icons.bolt_rounded,
          title: 'Healthy alternatives',
          subtitle: 'Things to do instead, by how much time you have',
          route: routeName.alternatives,
          theme: theme,
        ),
        const SizedBox(height: 20),
        const Center(child: BannerAdWidget()),
      ],
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/tools_tab_body_test.dart`
Expected: PASS (1 test)

- [ ] **Step 5: Commit**

```bash
git add lib/screens/shell/tools_tab_screen.dart test/tools_tab_body_test.dart
git commit -m "feat: add ToolsTabBody — coach, planner, wellbeing, sleep, rewards, alternatives"
```

---

### Task 9: Extract `HomeTabBody` (drop the old dashboard nav-row list and bottom panic bar)

**Files:**
- Modify: `lib/screens/home/home_screen.dart` (full rewrite)

**Interfaces:**
- Produces: `class HomeTabBody extends StatelessWidget` (no constructor args) — replaces the old `HomeScreen` entirely (deleted; it owned a `Scaffold`/`AppBar`/bottom `_PanicBar` that the shell now owns instead).

**What's removed and why:**
- `HomeScreen`'s `Scaffold`/`AppBar`/settings-gear action — the shell (`MainShellScreen`, Task 10) now owns the app bar and settings lives in the You tab.
- `_PanicBar` — replaced by `SosBar` (Task 3), rendered by the shell above the tab content.
- The 7-row `_NavRow` list (Insights/Habits/Mood/Coach/Rewards/Wellbeing/Learn) — each of those is now its own tab or reachable from a tab landing (Habits/Mood via the Insights tab's quick links, Task 5; Coach/Wellbeing/Rewards via the Tools tab, Task 8; Learn is its own tab). Repeating them here would just duplicate the bottom nav.
- Everything else (`_StreakHero`, scores, `_QuickActions`, `_EmptyState`) is unchanged.

- [ ] **Step 1: Rewrite the file**

```dart
// lib/screens/home/home_screen.dart
import '../../config.dart';
import '../../data/collections/recovery_goal.dart';
import '../../data/enums.dart';
import '../../providers/dashboard_provider.dart';
import '../../services/emergency_flow.dart';
import '../../services/streak_service.dart';
import '../../widgets/ad/banner_ad_widget.dart';
import '../onboarding/assessment_content.dart';
import 'log_sheets.dart';

/// The Home tab's content — the app's core loop surface: see progress at a
/// glance and log an urge / slip / check-in. Hosted inside [MainShellScreen]'s
/// IndexedStack; owns no Scaffold/AppBar of its own — the shell supplies both,
/// plus the pinned [SosBar] above this content.
///
/// [DashboardProvider] is scoped here so returning to this tab (e.g. right
/// after onboarding saves the goal) reloads current data automatically.
class HomeTabBody extends StatelessWidget {
  const HomeTabBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardProvider(),
      child: const _DashboardBody(),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody();

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    final p = context.watch<DashboardProvider>();

    return p.loading
        ? const Center(child: CircularProgressIndicator())
        : p.goal == null
            ? _EmptyState(theme: theme)
            : _Content(goal: p.goal!, stats: p.stats, theme: theme);
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.goal, required this.stats, required this.theme});
  final RecoveryGoal goal;
  final StreakStats? stats;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    final s = stats;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        _StreakHero(goal: goal, stats: s, theme: theme),
        const SizedBox(height: 16),
        if (s != null)
          Row(
            children: [
              Expanded(
                child: _ScoreCard(
                  label: 'Recovery score',
                  value: s.recoveryScore,
                  hint: 'Holds steady through slips',
                  theme: theme,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ScoreCard(
                  label: 'Consistency',
                  value: s.consistencyScore,
                  hint: 'Showing up, last 30 days',
                  theme: theme,
                ),
              ),
            ],
          ),
        const SizedBox(height: 20),
        Text('Quick actions',
            style: appCss.titleSemi16.textColor(theme.darkText)),
        const SizedBox(height: 12),
        _QuickActions(theme: theme),
        const SizedBox(height: 20),
        // Self-censoring: hidden on no-ad routes and during a post-lapse
        // cooldown. Never appears on the emergency/crisis screens.
        const Center(child: BannerAdWidget()),
      ],
    );
  }
}

// --- Streak hero ------------------------------------------------------------

class _StreakHero extends StatelessWidget {
  const _StreakHero(
      {required this.goal, required this.stats, required this.theme});
  final RecoveryGoal goal;
  final StreakStats? stats;
  final AppTheme theme;

  ({int day, String label})? _nextMilestone(int days) {
    for (final m in goal.milestones) {
      if (m.day > days) return (day: m.day, label: m.label);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final days = stats?.daysSinceLastLapse ?? 0;
    final next = _nextMilestone(days);
    final progress =
        next == null ? 1.0 : (days / next.day).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [theme.primary, theme.primary.withValues(alpha: 0.82)],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(goalLabel(goal.type),
              style: appCss.medium14.textColor(Colors.white70)),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('$days',
                  style: appCss.counterBold40.textColor(Colors.white).sized(52)),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text('${_plural(days, 'day')} steady',
                    style: appCss.titleSemi16.textColor(Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation(Colors.white),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            next == null
                ? 'Every milestone reached — incredible.'
                : '${next.day - days} ${_plural(next.day - days, 'day')} to ${next.label.toLowerCase()}',
            style: appCss.label12.textColor(Colors.white70),
          ),
        ],
      ),
    );
  }
}

/// Naive English pluralization for small day counts ("1 day", "2 days").
String _plural(int n, String word) => n == 1 ? word : '${word}s';

class _ScoreCard extends StatelessWidget {
  const _ScoreCard({
    required this.label,
    required this.value,
    required this.hint,
    required this.theme,
  });
  final String label;
  final int value;
  final String hint;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: appCss.medium14.textColor(theme.lightText)),
          const SizedBox(height: 8),
          Text('$value',
              style: appCss.counterBold40.textColor(theme.primary).sized(32)),
          const SizedBox(height: 4),
          Text(hint, style: appCss.label12.textColor(theme.lightText)),
        ],
      ),
    );
  }
}

// --- Quick actions ----------------------------------------------------------

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.theme});
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.7,
      children: [
        _ActionTile(
          icon: Icons.bolt_outlined,
          label: language(context, appFonts.logUrge),
          theme: theme,
          onTap: () => _logUrge(context),
        ),
        _ActionTile(
          icon: Icons.check_circle_outline_rounded,
          label: 'I resisted',
          theme: theme,
          onTap: () => _quickResist(context),
        ),
        _ActionTile(
          icon: Icons.wb_sunny_outlined,
          label: 'Daily check-in',
          theme: theme,
          onTap: () => _checkIn(context),
        ),
        _ActionTile(
          icon: Icons.favorite_border_rounded,
          label: language(context, appFonts.iSlipped),
          theme: theme,
          onTap: () => _slip(context),
        ),
      ],
    );
  }

  /// After a slip is logged, gently open the relapse-reflection coach flow (a
  /// no-ad route). The flow reframes the lapse as learning, never failure.
  Future<void> _logUrge(BuildContext context) async {
    final intensity = await showLogUrgeSheet(context);
    // A peak-intensity urge escalates into the guided emergency sequence — the
    // same tested rule the panic hub uses (EmergencyFlow.shouldEscalate).
    if (intensity != null &&
        EmergencyFlow.shouldEscalate(intensity) &&
        context.mounted) {
      await Navigator.pushNamed(context, routeName.emergencyMode);
    }
  }

  Future<void> _slip(BuildContext context) async {
    final logged = await showSlipSheet(context);
    if (logged == true && context.mounted) {
      await Navigator.pushNamed(
        context,
        routeName.relapseReflection,
        arguments: 'relapse_reflection',
      );
    }
  }

  Future<void> _quickResist(BuildContext context) async {
    await context.read<DashboardProvider>().logUrge(outcome: Outcome.resisted);
    if (context.mounted) _toast(context, 'Logged — that\'s a real win.');
  }

  Future<void> _checkIn(BuildContext context) async {
    await context.read<DashboardProvider>().checkInClean();
    if (context.mounted) _toast(context, 'Checked in for today. 🌱');
  }

  void _toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.theme,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: theme.cardBg,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: theme.stroke),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: theme.primary, size: 26),
              Text(label, style: appCss.titleSemi16.textColor(theme.darkText)),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.theme});
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.spa_rounded, size: 48, color: theme.primary),
            const SizedBox(height: 16),
            Text('Let\'s set up your goal',
                style: appCss.titleSemi18.textColor(theme.darkText)),
            const SizedBox(height: 8),
            Text('Restart onboarding to choose what you\'re working toward.',
                textAlign: TextAlign.center,
                style: appCss.body14.textColor(theme.lightText)),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Verify it compiles clean**

Run: `flutter analyze lib/screens/home/home_screen.dart`
Expected: `No issues found!` — note this will still show an error at this point because `route_method.dart` (Task 10) still references the now-deleted `HomeScreen` class; that's expected and resolved in Task 10. If running analyze on the whole project here, restrict it to this file as shown.

- [ ] **Step 3: Commit**

```bash
git add lib/screens/home/home_screen.dart
git commit -m "refactor: extract HomeTabBody, drop redundant nav-row list and bottom panic bar"
```

---

### Task 10: Build `MainShellScreen` and wire it into the route table

**Files:**
- Create: `lib/screens/shell/main_shell_screen.dart`
- Modify: `lib/routes/route_method.dart`

**Interfaces:**
- Consumes: `TabShellScaffold` (Task 4), `SosBar`/`SosFab` (Task 3), `HomeTabBody` (Task 9), `InsightsBody` (Task 5), `ToolsTabBody` (Task 8), `LearnHubBody` (Task 6), `SettingsBody` (Task 7), the five `appFonts.tabX` keys (Task 2).
- Produces: `class MainShellScreen extends StatelessWidget` — registered at `routeName.home`, replacing the deleted `HomeScreen`.

- [ ] **Step 1: Write `MainShellScreen`**

```dart
// lib/screens/shell/main_shell_screen.dart
import '../../config.dart';
import '../home/home_screen.dart';
import '../insights/insights_screen.dart';
import '../learn/learn_hub_screen.dart';
import '../settings/settings_screen.dart';
import 'sos_widgets.dart';
import 'tab_shell_scaffold.dart';
import 'tools_tab_screen.dart';

/// The app's persistent bottom-nav shell — Home / Insights / Tools / Learn /
/// You. Registered at the `home` route (see route_method.dart), replacing the
/// old single-screen dashboard. See
/// docs/superpowers/specs/2026-07-10-bottom-nav-shell-design.md for the design.
class MainShellScreen extends StatelessWidget {
  const MainShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);

    return TabShellScaffold(
      tabs: const [
        HomeTabBody(),
        InsightsBody(),
        ToolsTabBody(),
        LearnHubBody(),
        SettingsBody(),
      ],
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home_rounded),
          label: language(context, appFonts.tabHome),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.insights_rounded),
          label: language(context, appFonts.tabInsights),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.handyman_rounded),
          label: language(context, appFonts.tabTools),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.menu_book_rounded),
          label: language(context, appFonts.tabLearn),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person_rounded),
          label: language(context, appFonts.tabYou),
        ),
      ],
      appBarTitleFor: (i) => switch (i) {
        0 => language(context, appFonts.dashboard),
        1 => language(context, appFonts.tabInsights),
        2 => language(context, appFonts.tabTools),
        3 => language(context, appFonts.tabLearn),
        _ => language(context, appFonts.settings),
      },
      topBannerFor: (i) => i == 0
          ? SosBar(
              theme: theme,
              onTap: () => route.pushNamed(context, routeName.panic),
            )
          : null,
      floatingActionFor: (i) => i == 0
          ? null
          : SosFab(
              theme: theme,
              onTap: () => route.pushNamed(context, routeName.panic),
            ),
    );
  }
}
```

- [ ] **Step 2: Wire it into the route table**

Edit `lib/routes/route_method.dart` — replace the `home_screen.dart` import and the `_r.home` entry:

```dart
// remove:
import '../screens/home/home_screen.dart';
// add (alphabetical, near the other screens/shell import once it exists):
import '../screens/shell/main_shell_screen.dart';
```

```dart
// change:
        _r.home: (_) => const HomeScreen(),
// to:
        _r.home: (_) => const MainShellScreen(),
```

- [ ] **Step 3: Verify the whole project compiles clean**

Run: `flutter analyze`
Expected: `No issues found!`

- [ ] **Step 4: Run the full test suite**

Run: `flutter test`
Expected: all tests PASS (161 pre-existing + the new tests from Tasks 1, 3, 4, 6, 7, 8 — 6 new test files).

- [ ] **Step 5: Commit**

```bash
git add lib/screens/shell/main_shell_screen.dart lib/routes/route_method.dart
git commit -m "feat: wire MainShellScreen into the home route"
```

---

### Task 11: Manual on-device verification

**Files:** none (verification only — no code changes).

This is the step the base instructions require for any UI change: type-checking and unit tests verify the code compiles and pure logic is correct, but only running the app verifies the *feature* works. A device (OnePlus N200, `cdc8bb52`) was already connected and used earlier this session.

- [ ] **Step 1: Launch on the connected device**

Run: `flutter run -d cdc8bb52`
Expected: builds and launches with no red error screen; lands on the Home tab.

- [ ] **Step 2: Walk the golden path**

Check each of the following on-device, in order:
1. **Home tab** — streak hero, scores, quick actions all render; the full-width red **"I need help right now"** bar is pinned at the top; bottom nav shows 5 items (Home/Insights/Tools/Learn/You) with icon + label.
2. **Insights tab** — tap it; Habits and Mood journal quick-link cards appear above the analytics content (or the empty state if there isn't enough data yet); the small floating shield button appears bottom-right.
3. Tap the **Habits** quick link from Insights → habits screen opens (bottom nav disappears, as expected for a pushed detail screen) → back button returns to the Insights tab with the bottom nav restored and Insights still selected.
4. **Tools tab** — tap it; all 6 cards render (Coach & check-ins, Daily planner, Wellbeing, Sleep, Milestones & rewards, Healthy alternatives); tap one, confirm it opens, confirm back returns to Tools tab.
5. **Learn tab** — tap it; the same 7 content hubs as before render; tap one, confirm it opens and back returns correctly.
6. **You tab** — tap it; Settings content renders including Backup & export, Accountability partner, and Therapy notes links under "Data"; toggle Discreet mode and confirm it still works exactly as before (Phase 7.6 behavior unaffected).
7. **Floating SOS shield** — from Insights, Tools, Learn, and You, tap the floating shield button; confirm each one navigates to the Panic screen; confirm back returns to the same tab that was active.
8. **Home SOS bar** — from Home, tap "I need help right now"; confirm it navigates to the Panic screen.

- [ ] **Step 3: Confirm no regressions in ad/lock behavior**

- Panic/emergency screens still show no ads (unchanged — `AdPolicy.noAdRoutes` untouched).
- If app lock is enabled, backgrounding and resuming the app still shows the lock screen (unchanged — `main.dart`'s resume handling untouched).

- [ ] **Step 4: Final full check**

Run: `flutter analyze && flutter test`
Expected: `No issues found!` and all tests PASS.

If everything above holds, the bottom-nav shell is complete.

---

## Self-Review

**Spec coverage:** every section of `docs/superpowers/specs/2026-07-10-bottom-nav-shell-design.md` maps to a task — Architecture → Tasks 4 & 10; Tab mapping → Tasks 5–9; Panic/SOS placement → Tasks 3 & 10; Compatibility approach → Tasks 5–7 (thin wrappers retained); Testing → the "Testing note" plus Task 11.

**Placeholder scan:** no TBD/TODO markers; every step has complete, runnable code or exact commands with expected output.

**Type consistency:** `TabShellScaffold`'s constructor signature (Task 4) matches its exact usage in `MainShellScreen` (Task 10) — `tabs`, `items`, `appBarTitleFor`, `topBannerFor`, `floatingActionFor` all line up. `NavRow`'s constructor (Task 1) matches its usage in Tasks 5 and 8. `SosBar`/`SosFab` (Task 3) match their usage in Task 10. All five `appFonts.tabX` keys (Task 2) are the exact ones referenced in Task 10.
