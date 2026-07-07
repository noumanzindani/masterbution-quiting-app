import '../../config.dart';
import '../../data/time_buckets.dart';
import '../../widgets/ad/banner_ad_widget.dart';
import '../../widgets/article_card.dart';

/// Motivation center: a daily quote, more encouragement, and success stories
/// (rendered by the shared [ArticleCard] + reader).
class MotivationScreen extends StatelessWidget {
  const MotivationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    final today = TimeBuckets.todayEpochDay();
    final daily = contentService.quoteForDay(today);
    final quotes = contentService.quotes;
    final stories = contentService.stories;

    // A few more quotes, rotated by day so they change but stay stable within it.
    final extras = quotes.length <= 1
        ? const []
        : [for (var i = 1; i <= 3; i++) quotes[(today + i) % quotes.length]];

    return Scaffold(
      backgroundColor: theme.scaffoldBg,
      appBar: AppBar(
        title: Text('Motivation',
            style: appCss.headingBold22.textColor(theme.darkText)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Container(
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
                Icon(Icons.format_quote_rounded,
                    color: Colors.white70, size: 32),
                const SizedBox(height: 8),
                Text(daily.text,
                    style: appCss.headingBold22.textColor(Colors.white)),
                if (daily.author != null) ...[
                  const SizedBox(height: 10),
                  Text('— ${daily.author}',
                      style: appCss.body14.textColor(Colors.white70)),
                ],
              ],
            ),
          ),
          if (extras.isNotEmpty) ...[
            const SizedBox(height: 24),
            for (final q in extras)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.stroke),
                ),
                child: Text(q.text,
                    style: appCss.body16.textColor(theme.darkText)),
              ),
          ],
          if (stories.isNotEmpty) ...[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 12),
              child: Text('SUCCESS STORIES',
                  style: appCss.label12.textColor(theme.lightText)),
            ),
            for (final story in stories) ArticleCard(article: story),
          ],
          const SizedBox(height: 12),
          const Center(child: BannerAdWidget()),
        ],
      ),
    );
  }
}
