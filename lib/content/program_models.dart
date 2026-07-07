import 'content_models.dart';

/// One day of a multi-day program. Reuses [ArticleBlock] for the day's reading,
/// plus a single concrete [action] to do that day.
class ProgramDay {
  const ProgramDay({
    required this.day,
    required this.title,
    required this.blocks,
    required this.action,
  });

  final int day;
  final String title;
  final List<ArticleBlock> blocks;
  final String action;

  factory ProgramDay.fromJson(Map<String, dynamic> j) => ProgramDay(
        day: (j['day'] as num?)?.toInt() ?? 1,
        title: j['title'] as String? ?? '',
        action: j['action'] as String? ?? '',
        blocks: (j['blocks'] as List?)
                ?.map((e) => ArticleBlock.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
      );
}

/// A structured multi-day program (e.g. the dopamine reset).
class Program {
  const Program({
    required this.id,
    required this.title,
    required this.intro,
    required this.days,
  });

  final String id;
  final String title;
  final String intro;
  final List<ProgramDay> days;

  factory Program.fromJson(Map<String, dynamic> j) => Program(
        id: j['id'] as String,
        title: j['title'] as String? ?? '',
        intro: j['intro'] as String? ?? '',
        days: (j['days'] as List?)
                ?.map((e) => ProgramDay.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
      );
}

/// A single value in the values module.
class ValueItem {
  const ValueItem({required this.id, required this.label, required this.description});

  final String id;
  final String label;
  final String description;

  factory ValueItem.fromJson(Map<String, dynamic> j) => ValueItem(
        id: j['id'] as String,
        label: j['label'] as String? ?? '',
        description: j['description'] as String? ?? '',
      );
}
