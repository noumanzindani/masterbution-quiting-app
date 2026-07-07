import '../../config.dart';
import '../../content/quiz_models.dart';
import '../../widgets/ad/banner_ad_widget.dart';
import '../../widgets/article_card.dart';

/// Browse the article library grouped by category. Each card opens the generic
/// [ArticleScreen] reader.
class AcademyScreen extends StatelessWidget {
  const AcademyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    final categories = contentService.categories;

    return Scaffold(
      backgroundColor: theme.scaffoldBg,
      appBar: AppBar(
        title: Text('Academy',
            style: appCss.headingBold22.textColor(theme.darkText)),
      ),
      body: categories.isEmpty
          ? Center(
              child: Text('Lessons are on the way.',
                  style: appCss.body14.textColor(theme.lightText)),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                Text('Understanding what\'s happening makes it easier to change.',
                    style: appCss.body14.textColor(theme.lightText)),
                const SizedBox(height: 20),
                for (final category in categories) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 12),
                    child: Text(
                        contentService.categoryLabel(category).toUpperCase(),
                        style: appCss.label12.textColor(theme.lightText)),
                  ),
                  for (final article
                      in contentService.articlesByCategory(category))
                    ArticleCard(article: article),
                  const SizedBox(height: 16),
                ],
                if (contentService.quizzes.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 12),
                    child: Text('TEST YOURSELF',
                        style: appCss.label12.textColor(theme.lightText)),
                  ),
                  for (final quiz in contentService.quizzes)
                    _QuizCard(quiz: quiz, theme: theme),
                  const SizedBox(height: 16),
                ],
                const Center(child: BannerAdWidget()),
              ],
            ),
    );
  }
}

class _QuizCard extends StatelessWidget {
  const _QuizCard({required this.quiz, required this.theme});
  final Quiz quiz;
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
          onTap: () =>
              Navigator.pushNamed(context, routeName.quiz, arguments: quiz),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: theme.stroke),
            ),
            child: Row(
              children: [
                Icon(Icons.quiz_outlined, color: theme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('Quiz: ${quiz.title}',
                      style: appCss.titleSemi16.textColor(theme.darkText)),
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
