import '../config.dart';
import '../content/content_models.dart';
import '../routes/route_name.dart';

/// Tappable card summarising a [ContentArticle], opening the generic reader.
/// Shared by the academy and the motivation stories list.
class ArticleCard extends StatelessWidget {
  const ArticleCard({super.key, required this.article});

  final ContentArticle article;

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: theme.cardBg,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => Navigator.pushNamed(context, RouteName().article,
              arguments: article),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: theme.stroke),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(article.title,
                    style: appCss.titleSemi16.textColor(theme.darkText)),
                const SizedBox(height: 6),
                Text(article.summary,
                    style: appCss.body14.textColor(theme.lightText)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.schedule_rounded,
                        size: 14, color: theme.lightText),
                    const SizedBox(width: 4),
                    Text('${article.readMinutes} min',
                        style: appCss.label12.textColor(theme.lightText)),
                    const Spacer(),
                    Icon(Icons.arrow_forward_rounded,
                        size: 18, color: theme.primary),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
