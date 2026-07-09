import '../content/reward_models.dart';

/// Pure achievement/coin math over a snapshot of progress [metrics] (a map of
/// metric-name → value). Kept device-free and side-effect-free so it is
/// trivially unit-testable; the RewardsProvider gathers the metrics and owns the
/// sticky "once unlocked, always unlocked" persistence.
class RewardEngine {
  const RewardEngine._();

  /// A badge is earned when its metric meets its threshold. A missing metric is
  /// treated as zero (never a crash).
  static bool isEarned(Achievement a, Map<String, int> metrics) =>
      (metrics[a.metric] ?? 0) >= a.atLeast;

  /// Ids of all achievements currently satisfied by [metrics].
  static Set<String> earnedIds(
    List<Achievement> defs,
    Map<String, int> metrics,
  ) =>
      {for (final a in defs) if (isEarned(a, metrics)) a.id};

  /// Total coins granted by the given set of unlocked ids. Unknown ids (e.g. an
  /// achievement later removed from the corpus) are ignored.
  static int coinsForUnlocked(
    List<Achievement> defs,
    Set<String> unlockedIds,
  ) =>
      defs
          .where((a) => unlockedIds.contains(a.id))
          .fold(0, (sum, a) => sum + a.coins);
}
