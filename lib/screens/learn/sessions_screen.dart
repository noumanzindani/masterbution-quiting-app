import '../../config.dart';
import '../../content/session_models.dart';
import '../../data/enums.dart';
import '../../widgets/ad/banner_ad_widget.dart';

/// Guided text sessions library. Each opens the self-paced player.
class SessionsScreen extends StatelessWidget {
  const SessionsScreen({super.key});

  static String _typeLabel(SessionType t) {
    switch (t) {
      case SessionType.mindfulness:
        return 'Mindfulness';
      case SessionType.acceptance:
        return 'Acceptance';
      case SessionType.compassion:
        return 'Self-compassion';
      case SessionType.act:
        return 'ACT';
      case SessionType.cbt:
        return 'CBT';
      case SessionType.positivePsych:
        return 'Positive psychology';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    final sessions = contentService.sessions;

    return Scaffold(
      backgroundColor: theme.scaffoldBg,
      appBar: AppBar(
        title: Text('Guided sessions',
            style: appCss.headingBold22.textColor(theme.darkText)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Text('Short, self-paced practices to settle your mind and ride out hard moments.',
              style: appCss.body14.textColor(theme.lightText)),
          const SizedBox(height: 20),
          for (final s in sessions)
            _SessionCard(session: s, label: _typeLabel(s.type), theme: theme),
          const SizedBox(height: 12),
          const Center(child: BannerAdWidget()),
        ],
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  const _SessionCard(
      {required this.session, required this.label, required this.theme});
  final GuidedSession session;
  final String label;
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
          onTap: () => Navigator.pushNamed(context, routeName.sessionPlayer,
              arguments: session),
          child: Container(
            padding: const EdgeInsets.all(16),
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
                  child: Icon(Icons.headphones_rounded, color: theme.primary),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(session.title,
                          style:
                              appCss.titleSemi16.textColor(theme.darkText)),
                      const SizedBox(height: 2),
                      Text('$label · ${session.minutes} min',
                          style: appCss.label12.textColor(theme.lightText)),
                    ],
                  ),
                ),
                Icon(Icons.play_arrow_rounded, color: theme.primary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
