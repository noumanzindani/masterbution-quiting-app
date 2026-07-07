import '../../config.dart';
import '../../widgets/primary_button.dart';
import 'emergency_scaffold.dart';

/// The Panic hub — the calm landing reached from the dashboard's always-visible
/// "I need help right now" bar. Offers the in-the-moment tools; each is its own
/// NO-AD route pushed on top of this one.
class PanicScreen extends StatelessWidget {
  const PanicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    return EmergencyScaffold(
      child: ListView(
        children: [
          const SizedBox(height: 8),
          Icon(Icons.waves_rounded, size: 56, color: theme.primary),
          const SizedBox(height: 20),
          Text(
            language(context, appFonts.panicSubtitle),
            textAlign: TextAlign.center,
            style: appCss.headingBold22.textColor(theme.darkText),
          ),
          const SizedBox(height: 8),
          Text(
            'Pick anything below. You don\'t have to act on the urge — you only have to let it pass.',
            textAlign: TextAlign.center,
            style: appCss.body14.textColor(theme.lightText),
          ),
          const SizedBox(height: 24),
          _ToolCard(
            icon: Icons.air_rounded,
            title: 'Breathe with me',
            subtitle: 'A slow 4-4-6 rhythm to settle your body',
            theme: theme,
            onTap: () => route.pushNamed(context, routeName.breathing),
          ),
          _ToolCard(
            icon: Icons.surfing_rounded,
            title: 'Ride the wave',
            subtitle: 'A 3-minute urge-surfing timer',
            theme: theme,
            onTap: () => route.pushNamed(context, routeName.urgeSurf),
          ),
          _ToolCard(
            icon: Icons.spa_rounded,
            title: 'Ground yourself',
            subtitle: '5-4-3-2-1: come back to right now',
            theme: theme,
            onTap: () => route.pushNamed(context, routeName.grounding),
          ),
          _ToolCard(
            icon: Icons.edit_note_rounded,
            title: 'Write it out',
            subtitle: 'Get the urge out of your head and onto the page',
            theme: theme,
            onTap: () => route.pushNamed(context, routeName.emergencyJournal),
          ),
          _ToolCard(
            icon: Icons.support_agent_rounded,
            title: 'Reach out for support',
            subtitle: 'Crisis lines and helplines, any time',
            theme: theme,
            onTap: () => route.pushNamed(context, routeName.crisisResources),
          ),
          const SizedBox(height: 12),
          PrimaryButton(
            label: 'I feel steadier now',
            onPressed: () => route.pop(context),
          ),
        ],
      ),
    );
  }
}

class _ToolCard extends StatelessWidget {
  const _ToolCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.theme,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
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
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
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
                          style:
                              appCss.titleSemi16.textColor(theme.darkText)),
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
