/// Plain data models for the bundled JSON content corpus. Kept free of Flutter
/// and Isar so they parse and test trivially; the [ContentService] loads them
/// from `assets/content/**` and the generic renderer screens display them.
///
/// All `fromJson` factories are defensive (missing/renamed fields degrade to
/// sensible defaults) so a small content typo never crashes the app.
library;

/// A healthy alternative activity, surfaced by the "I have N minutes" generator.
class HealthyAlternative {
  const HealthyAlternative({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.minutes,
    required this.icon,
  });

  final String id;
  final String title;
  final String description;
  final String category;

  /// Approximate time the activity takes, in minutes.
  final int minutes;

  /// Icon name, mapped to an IconData in the UI layer.
  final String icon;

  factory HealthyAlternative.fromJson(Map<String, dynamic> j) =>
      HealthyAlternative(
        id: j['id'] as String,
        title: j['title'] as String? ?? '',
        description: j['description'] as String? ?? '',
        category: j['category'] as String? ?? 'general',
        minutes: (j['minutes'] as num?)?.toInt() ?? 5,
        icon: j['icon'] as String? ?? 'bolt',
      );
}

/// One block of an article body. [type] is one of `h` (heading), `p`
/// (paragraph), `list` (bullets in [items]), or `callout` (highlighted note).
class ArticleBlock {
  const ArticleBlock({required this.type, this.text = '', this.items = const []});

  final String type;
  final String text;
  final List<String> items;

  factory ArticleBlock.fromJson(Map<String, dynamic> j) => ArticleBlock(
        type: j['type'] as String? ?? 'p',
        text: j['text'] as String? ?? '',
        items: (j['items'] as List?)?.map((e) => e.toString()).toList() ??
            const [],
      );
}

/// A bundled article (academy lesson, success story, values piece, …). The same
/// model + reader powers every long-form text screen.
class ContentArticle {
  const ContentArticle({
    required this.id,
    required this.title,
    required this.category,
    required this.summary,
    required this.readMinutes,
    required this.blocks,
    this.videoUrl,
  });

  final String id;
  final String title;
  final String category;
  final String summary;
  final int readMinutes;
  final List<ArticleBlock> blocks;

  /// Optional external video (e.g. YouTube) opened via url_launcher — keeps the
  /// app content-rich at zero hosting cost.
  final String? videoUrl;

  factory ContentArticle.fromJson(Map<String, dynamic> j) => ContentArticle(
        id: j['id'] as String,
        title: j['title'] as String? ?? '',
        category: j['category'] as String? ?? 'general',
        summary: j['summary'] as String? ?? '',
        readMinutes: (j['readMinutes'] as num?)?.toInt() ?? 3,
        videoUrl: j['videoUrl'] as String?,
        blocks: (j['blocks'] as List?)
                ?.map((e) =>
                    ArticleBlock.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
      );
}

/// A short motivational quote.
class Quote {
  const Quote({required this.text, this.author});

  final String text;
  final String? author;

  factory Quote.fromJson(Map<String, dynamic> j) => Quote(
        text: j['text'] as String? ?? '',
        author: j['author'] as String?,
      );
}
