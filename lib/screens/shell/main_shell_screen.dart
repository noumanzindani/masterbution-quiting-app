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
