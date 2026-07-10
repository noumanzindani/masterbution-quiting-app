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
