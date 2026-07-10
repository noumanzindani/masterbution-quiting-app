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
