import '../../config.dart';
import '../../content/content_models.dart';
import '../../services/alternatives_engine.dart';
import '../../widgets/ad/banner_ad_widget.dart';

/// Map a content icon name to a Material icon.
IconData altIcon(String name) {
  switch (name) {
    case 'water':
      return Icons.water_drop_outlined;
    case 'breathe':
      return Icons.air_rounded;
    case 'fitness':
      return Icons.fitness_center_rounded;
    case 'shower':
      return Icons.shower_outlined;
    case 'outside':
      return Icons.park_outlined;
    case 'stretch':
      return Icons.accessibility_new_rounded;
    case 'chat':
      return Icons.chat_bubble_outline_rounded;
    case 'tea':
      return Icons.local_cafe_outlined;
    case 'walk':
      return Icons.directions_walk_rounded;
    case 'write':
      return Icons.edit_note_rounded;
    case 'call':
      return Icons.call_outlined;
    case 'clean':
      return Icons.cleaning_services_outlined;
    case 'spa':
      return Icons.spa_rounded;
    case 'music':
      return Icons.music_note_rounded;
    case 'run':
      return Icons.directions_run_rounded;
    case 'people':
      return Icons.groups_rounded;
    default:
      return Icons.bolt_rounded;
  }
}

/// "I have N minutes — what could I do instead?" A rule-based generator that
/// suggests time-appropriate healthy activities.
class AlternativesScreen extends StatefulWidget {
  const AlternativesScreen({super.key});

  @override
  State<AlternativesScreen> createState() => _AlternativesScreenState();
}

class _AlternativesScreenState extends State<AlternativesScreen> {
  static const _options = [5, 15, 30, 60];
  int _minutes = 15;

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    final suggestions = AlternativesEngine.suggest(
      contentService.alternatives,
      maxMinutes: _minutes,
      count: 4,
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBg,
      appBar: AppBar(
        title: Text('Instead of…',
            style: appCss.headingBold22.textColor(theme.darkText)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Text('How much time do you have right now?',
              style: appCss.titleSemi16.textColor(theme.darkText)),
          const SizedBox(height: 12),
          Row(
            children: [
              for (final m in _options)
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _minutes = m),
                    child: Container(
                      margin: EdgeInsets.only(right: m == _options.last ? 0 : 8),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: _minutes == m ? theme.primary : theme.fieldBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        m == 60 ? '60+' : '$m',
                        textAlign: TextAlign.center,
                        style: appCss.buttonSemi16.textColor(
                            _minutes == m ? Colors.white : theme.darkText),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text('minutes',
              textAlign: TextAlign.center,
              style: appCss.label12.textColor(theme.lightText)),
          const SizedBox(height: 24),
          if (suggestions.isEmpty)
            Text('No ideas fit that time yet.',
                style: appCss.body14.textColor(theme.lightText))
          else
            for (final a in suggestions)
              _AlternativeCard(alt: a, theme: theme),
          const SizedBox(height: 12),
          const Center(child: BannerAdWidget()),
        ],
      ),
    );
  }
}

class _AlternativeCard extends StatelessWidget {
  const _AlternativeCard({required this.alt, required this.theme});
  final HealthyAlternative alt;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.stroke),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: theme.primarySoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(altIcon(alt.icon), color: theme.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(alt.title,
                          style: appCss.titleSemi16.textColor(theme.darkText)),
                    ),
                    Text('${alt.minutes} min',
                        style: appCss.label12.textColor(theme.lightText)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(alt.description,
                    style: appCss.body14.textColor(theme.lightText)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
