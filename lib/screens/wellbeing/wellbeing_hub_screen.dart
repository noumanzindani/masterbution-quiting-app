import '../../config.dart';
import '../../content/wellbeing_models.dart';
import '../../widgets/ad/banner_ad_widget.dart';

/// The "Wellbeing" hub — lists the wellbeing modules (mindfulness, self-esteem,
/// relationships, anxiety, low mood, sleep). Each opens a generic module screen
/// that reuses the existing article reader + session player.
class WellbeingHubScreen extends StatelessWidget {
  const WellbeingHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    final modules = contentService.wellbeingModules;

    return Scaffold(
      backgroundColor: theme.scaffoldBg,
      appBar: AppBar(
        title: Text('Wellbeing',
            style: appCss.headingBold22.textColor(theme.darkText)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Text('Skills for the whole of you — not just the habit.',
              style: appCss.body14.textColor(theme.lightText)),
          const SizedBox(height: 20),
          for (final m in modules) _ModuleTile(module: m, theme: theme),
          const SizedBox(height: 12),
          const Center(child: BannerAdWidget()),
        ],
      ),
    );
  }
}

/// Maps a module's icon name to an IconData. Shared with the module screen.
IconData wellbeingIcon(String name) => switch (name) {
      'self_improvement' => Icons.self_improvement_rounded,
      'favorite' => Icons.favorite_rounded,
      'people' => Icons.people_rounded,
      'air' => Icons.air_rounded,
      'wb_cloudy' => Icons.wb_cloudy_rounded,
      'bedtime' => Icons.bedtime_rounded,
      _ => Icons.spa_rounded,
    };

class _ModuleTile extends StatelessWidget {
  const _ModuleTile({required this.module, required this.theme});
  final WellbeingModule module;
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
          onTap: () => Navigator.pushNamed(context, routeName.wellbeingModule,
              arguments: module.id),
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
                  child: Icon(wellbeingIcon(module.icon), color: theme.primary),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(module.title,
                          style: appCss.titleSemi16.textColor(theme.darkText)),
                      const SizedBox(height: 2),
                      Text(module.subtitle,
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
