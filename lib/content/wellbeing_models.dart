/// A wellbeing module groups a set of existing content pieces (articles +
/// guided sessions, referenced by id) under one theme — mindfulness,
/// self-esteem, relationships, anxiety, depression, sleep. It's pure metadata:
/// the module screen resolves the ids and reuses the existing article reader and
/// session player, so a new module is just JSON.
class WellbeingModule {
  const WellbeingModule({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.articleIds,
    required this.sessionIds,
    this.disclaimer,
  });

  final String id;
  final String title;
  final String subtitle;

  /// Icon name, mapped to an IconData in the UI layer.
  final String icon;

  final List<String> articleIds;
  final List<String> sessionIds;

  /// Optional prominent notice shown atop the module (used by the depression
  /// module for the "not a substitute for professional care" message).
  final String? disclaimer;

  factory WellbeingModule.fromJson(Map<String, dynamic> j) => WellbeingModule(
        id: j['id'] as String,
        title: j['title'] as String? ?? '',
        subtitle: j['subtitle'] as String? ?? '',
        icon: j['icon'] as String? ?? 'spa',
        disclaimer: j['disclaimer'] as String?,
        articleIds: (j['articles'] as List?)?.map((e) => e.toString()).toList() ??
            const [],
        sessionIds: (j['sessions'] as List?)?.map((e) => e.toString()).toList() ??
            const [],
      );
}
