import '../../config.dart';
import '../../content/content_models.dart';
import '../../content/session_models.dart';
import '../../content/wellbeing_models.dart';
import '../../widgets/ad/banner_ad_widget.dart';

/// Generic screen for one [WellbeingModule]. Resolves the module's referenced
/// articles + sessions and reuses the existing article reader / session player,
/// so every module is pure content. Shows a prominent disclaimer when the module
/// declares one (the low-mood module).
class WellbeingModuleScreen extends StatelessWidget {
  const WellbeingModuleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    final id = ModalRoute.of(context)?.settings.arguments as String?;
    final module =
        id == null ? null : contentService.wellbeingModuleById(id);

    if (module == null) {
      return Scaffold(
        backgroundColor: theme.scaffoldBg,
        appBar: AppBar(),
        body: Center(
          child: Text('This module isn\'t available right now.',
              style: appCss.body14.textColor(theme.lightText)),
        ),
      );
    }

    final articles = module.articleIds
        .map(contentService.wellbeingArticleById)
        .whereType<ContentArticle>()
        .toList();
    final sessions = module.sessionIds
        .map(contentService.wellbeingSessionById)
        .whereType<GuidedSession>()
        .toList();

    return Scaffold(
      backgroundColor: theme.scaffoldBg,
      appBar: AppBar(
        title: Text(module.title,
            style: appCss.headingBold22.textColor(theme.darkText).sized(20)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Text(module.subtitle,
              style: appCss.body14.textColor(theme.lightText)),
          if (module.disclaimer != null) ...[
            const SizedBox(height: 16),
            _Disclaimer(text: module.disclaimer!, theme: theme),
          ],
          if (sessions.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text('Practices',
                style: appCss.titleSemi16.textColor(theme.darkText)),
            const SizedBox(height: 12),
            for (final s in sessions) _SessionRow(session: s, theme: theme),
          ],
          if (articles.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text('Read',
                style: appCss.titleSemi16.textColor(theme.darkText)),
            const SizedBox(height: 12),
            for (final a in articles) _ArticleRow(article: a, theme: theme),
          ],
          const SizedBox(height: 16),
          const Center(child: BannerAdWidget()),
        ],
      ),
    );
  }
}

class _Disclaimer extends StatelessWidget {
  const _Disclaimer({required this.text, required this.theme});
  final String text;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.warning.withValues(alpha: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: theme.warning, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text,
                style: appCss.label12.textColor(theme.darkText).sized(13)),
          ),
        ],
      ),
    );
  }
}

class _SessionRow extends StatelessWidget {
  const _SessionRow({required this.session, required this.theme});
  final GuidedSession session;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return _ContentCard(
      icon: Icons.headphones_rounded,
      title: session.title,
      subtitle: session.intro,
      meta: '${session.minutes} min',
      theme: theme,
      onTap: () => Navigator.pushNamed(context, routeName.sessionPlayer,
          arguments: session),
    );
  }
}

class _ArticleRow extends StatelessWidget {
  const _ArticleRow({required this.article, required this.theme});
  final ContentArticle article;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return _ContentCard(
      icon: Icons.menu_book_rounded,
      title: article.title,
      subtitle: article.summary,
      meta: '${article.readMinutes} min read',
      theme: theme,
      onTap: () => Navigator.pushNamed(context, routeName.article,
          arguments: article),
    );
  }
}

class _ContentCard extends StatelessWidget {
  const _ContentCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.meta,
    required this.theme,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final String meta;
  final AppTheme theme;
  final VoidCallback onTap;

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
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: theme.stroke),
            ),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: theme.primarySoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: theme.primary, size: 20),
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
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: appCss.label12.textColor(theme.lightText)),
                      const SizedBox(height: 4),
                      Text(meta,
                          style: appCss.label12.textColor(theme.primary)),
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
