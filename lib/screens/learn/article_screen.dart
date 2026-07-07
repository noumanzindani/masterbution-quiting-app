import 'package:url_launcher/url_launcher.dart';

import '../../config.dart';
import '../../content/content_models.dart';
import '../../widgets/ad/banner_ad_widget.dart';
import '../../widgets/content_blocks.dart';

/// Generic long-form reader — renders any [ContentArticle]'s blocks. Reused by
/// the academy, success stories, and (later) values/dopamine content, so new
/// text needs zero new code. Passed the article via route arguments.
class ArticleScreen extends StatelessWidget {
  const ArticleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    final article = ModalRoute.of(context)?.settings.arguments as ContentArticle?;

    if (article == null) {
      return Scaffold(
        backgroundColor: theme.scaffoldBg,
        appBar: AppBar(),
        body: Center(
          child: Text('Content unavailable.',
              style: appCss.body14.textColor(theme.lightText)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBg,
      appBar: AppBar(
        title: Text(contentService.categoryLabel(article.category),
            style: appCss.titleSemi16.textColor(theme.lightText)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        children: [
          Text(article.title,
              style: appCss.displayBold28.textColor(theme.darkText)),
          const SizedBox(height: 8),
          Text('${article.readMinutes} min read',
              style: appCss.label12.textColor(theme.lightText)),
          const SizedBox(height: 20),
          ContentBlocks(blocks: article.blocks),
          if (article.videoUrl != null) ...[
            const SizedBox(height: 8),
            _VideoButton(url: article.videoUrl!, theme: theme),
          ],
          const SizedBox(height: 24),
          const Center(child: BannerAdWidget()),
        ],
      ),
    );
  }
}


class _VideoButton extends StatelessWidget {
  const _VideoButton({required this.url, required this.theme});
  final String url;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        foregroundColor: theme.primary,
        side: BorderSide(color: theme.primary),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: const Icon(Icons.play_circle_outline_rounded),
      label: Text('Watch a related video',
          style: appCss.buttonSemi16.textColor(theme.primary)),
      onPressed: () => launchUrl(Uri.parse(url),
          mode: LaunchMode.externalApplication),
    );
  }
}
