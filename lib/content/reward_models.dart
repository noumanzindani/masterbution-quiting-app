/// Plain data model for a gamification achievement (badge). Authored as JSON in
/// `assets/content/rewards/achievements.json`; a badge unlocks when a single
/// progress [metric] reaches [atLeast]. All achievements are earned from real,
/// monotonic progress and are never revoked — see the reward engine + provider.
class Achievement {
  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.metric,
    required this.atLeast,
    required this.coins,
  });

  final String id;
  final String title;
  final String description;

  /// Icon name, mapped to an IconData in the UI layer.
  final String icon;

  /// Which progress metric gates this badge (e.g. `streakDays`, `positiveDays`,
  /// `reflections`, `daysActive`). Keys are produced by the RewardsProvider.
  final String metric;

  /// Threshold the metric must reach for the badge to unlock.
  final int atLeast;

  /// Coins granted (once) when the badge unlocks. Coins are positive
  /// reinforcement only — never deducted for a lapse.
  final int coins;

  factory Achievement.fromJson(Map<String, dynamic> j) => Achievement(
        id: j['id'] as String,
        title: j['title'] as String? ?? '',
        description: j['description'] as String? ?? '',
        icon: j['icon'] as String? ?? 'star',
        metric: j['metric'] as String? ?? '',
        atLeast: (j['atLeast'] as num?)?.toInt() ?? 0,
        coins: (j['coins'] as num?)?.toInt() ?? 0,
      );
}
