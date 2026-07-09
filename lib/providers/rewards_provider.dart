import 'dart:convert';

import '../common/theme/accent_palette.dart';
import '../config.dart';
import '../content/reward_models.dart';
import '../data/enums.dart';
import '../data/time_buckets.dart';
import '../services/reward_engine.dart';
import '../services/streak_service.dart';

/// Owns the gamification state: earned achievements (sticky), the coin balance,
/// and unlocked accent themes. All persistence is in SharedPreferences (current
/// scalars/small sets — no history to chart, so no Isar per the prefs-vs-Isar
/// rule).
///
/// Clinical guardrails enforced here:
/// - Achievements are **sticky**: once earned they're stored and never removed,
///   so a lapse (which resets the day-counter) never revokes a badge.
/// - Coins are earned-only; nothing here ever deducts coins for a slip.
class RewardsProvider extends ChangeNotifier {
  RewardsProvider() {
    refresh();
  }

  bool loading = true;
  bool busyAd = false;

  /// Spendable coin balance = achievement coins + ad coins − coins spent.
  int coins = 0;
  Set<String> _unlocked = {};
  Set<String> _unlockedAccents = {AccentPalettes.defaultId};

  List<Achievement> get achievements => contentService.achievements;
  bool isAchievementUnlocked(String id) => _unlocked.contains(id);
  bool isAccentUnlocked(String id) => _unlockedAccents.contains(id);
  int get unlockedCount => _unlocked.length;

  Future<void> refresh() async {
    loading = true;
    notifyListeners();

    final defs = contentService.achievements;
    final metrics = await _gatherMetrics();

    // Sticky merge: union newly-earned into the stored set, never subtract.
    final stored = _readIdSet(session.unlockedAchievements);
    final merged = {...stored, ...RewardEngine.earnedIds(defs, metrics)};
    if (merged.length != stored.length) {
      await _writeIdSet(session.unlockedAchievements, merged);
    }
    _unlocked = merged;
    _unlockedAccents = _readAccentSet();
    coins = _balance(defs, merged);

    loading = false;
    notifyListeners();
  }

  /// Watch an opt-in rewarded ad for coins. No-op if already busy; only credits
  /// coins if the ad actually reported the reward.
  Future<void> watchAdForCoins({int reward = 10}) async {
    if (busyAd) return;
    busyAd = true;
    notifyListeners();

    final earned = await adService.showRewardedForCoins();
    if (earned) {
      final cur = prefs.getInt(session.rewardCoinsFromAds) ?? 0;
      await prefs.setInt(session.rewardCoinsFromAds, cur + reward);
    }

    busyAd = false;
    await refresh();
  }

  /// Unlock an accent with coins. Returns true if now unlocked (or already was),
  /// false if the balance is too low.
  Future<bool> unlockAccent(AccentPalette accent) async {
    if (_unlockedAccents.contains(accent.id)) return true;
    if (coins < accent.cost) return false;

    final spent = prefs.getInt(session.rewardCoinsSpent) ?? 0;
    await prefs.setInt(session.rewardCoinsSpent, spent + accent.cost);
    await _writeIdSet(session.unlockedAccents, {..._unlockedAccents, accent.id});
    await refresh();
    return true;
  }

  int _balance(List<Achievement> defs, Set<String> unlocked) {
    final fromAchievements = RewardEngine.coinsForUnlocked(defs, unlocked);
    final fromAds = prefs.getInt(session.rewardCoinsFromAds) ?? 0;
    final spent = prefs.getInt(session.rewardCoinsSpent) ?? 0;
    return fromAchievements + fromAds - spent;
  }

  Future<Map<String, int>> _gatherMetrics() async {
    final events = await trackerRepo.all();
    final goal = await goalRepo.getActive();
    final today = TimeBuckets.todayEpochDay();

    var streakDays = 0;
    if (goal != null) {
      streakDays = StreakService.compute(
        events,
        todayEpochDay: today,
        startEpochDay: TimeBuckets.epochDayForLocal(goal.startDate),
        target: goal.target,
        goalTargetDays: goal.targetDays,
      ).daysSinceLastLapse;
    }
    final target = goal?.target ?? BehaviorTarget.both;

    final reflections =
        await journalRepo.countOfKind(JournalKind.dailyReflection) +
            await journalRepo.countOfKind(JournalKind.relapseReflection);

    var daysActive = 1;
    final firstLaunch = prefs.getString(session.firstLaunchDate);
    if (firstLaunch != null) {
      final d = DateTime.tryParse(firstLaunch);
      if (d != null) {
        daysActive = today - TimeBuckets.epochDayForLocal(d) + 1;
      }
    }

    return {
      'streakDays': streakDays,
      'positiveDays': StreakService.positiveDays(events, target),
      'reflections': reflections,
      'daysActive': daysActive,
    };
  }

  // --- prefs helpers ---

  Set<String> _readIdSet(String key) {
    final raw = prefs.getString(key);
    if (raw == null) return {};
    try {
      return (jsonDecode(raw) as List).map((e) => e.toString()).toSet();
    } catch (_) {
      return {};
    }
  }

  Future<void> _writeIdSet(String key, Set<String> ids) =>
      prefs.setString(key, jsonEncode(ids.toList()));

  Set<String> _readAccentSet() =>
      _readIdSet(session.unlockedAccents)..add(AccentPalettes.defaultId);
}
