/// Central holder of SharedPreferences key strings.
///
/// The prefs-vs-Isar rule: single current scalars/flags live here; anything you
/// would chart, GROUP BY, or keep history for lives in Isar instead.
///
/// Accessed via the global `session` singleton declared in `config.dart`.
class Session {
  // --- Onboarding / app state ---
  final String isOnboarded = 'isOnboarded';
  final String firstLaunchDate = 'firstLaunchDate';
  final String activeGoalId = 'activeGoalId';
  final String lastAssessmentDate = 'lastAssessmentDate';

  // --- Theme / locale ---
  final String isDarkMode = 'isDarkMode';
  final String themeIndex = 'themeIndex'; // 0 light, 1 dark, 2 follow system
  final String locale = 'locale';

  // --- App lock ---
  final String appLockEnabled = 'appLockEnabled';
  final String appLockType = 'appLockType'; // 'pin' | 'biometric' | 'both'
  final String pinHash = 'pinHash'; // salted hash — never plaintext
  final String pinSalt = 'pinSalt';
  final String autoLockGraceSecs = 'autoLockGraceSecs';
  final String lastPausedAt = 'lastPausedAt';

  // --- Ads / consent (owned by AdService) ---
  final String umpConsentDone = 'umpConsentDone';
  final String attStatus = 'attStatus';
  final String interstitialLastShownAt = 'interstitialLastShownAt';
  final String sessionInterstitialCount = 'sessionInterstitialCount';
  final String adCooldownUntil = 'adCooldownUntil'; // post-lapse no-ad window

  // --- Content progress ---
  final String dopamineProgress = 'dopamineProgress'; // JSON list of done days
  final String chosenValues = 'chosenValues'; // JSON list of value ids
  final String valuesReflection = 'valuesReflection';
  final String dailyPlan = 'dailyPlan'; // JSON {epochDay, items:[{t,d}]} for today

  // --- Rewards / gamification ---
  final String unlockedAchievements = 'unlockedAchievements'; // JSON list of ids
  final String rewardCoinsFromAds = 'rewardCoinsFromAds'; // int, earned via ads
  final String rewardCoinsSpent = 'rewardCoinsSpent'; // int, spent on accents
  final String unlockedAccents = 'unlockedAccents'; // JSON list of accent ids
  final String chosenAccent = 'chosenAccent'; // selected accent id

  // --- Privacy / misc ---
  final String discreetModeEnabled = 'discreetModeEnabled';
  final String notificationsEnabled = 'notificationsEnabled';
  final String panicContactId = 'panicContactId';
  final String contentPackVersion = 'contentPackVersion';
  final String coinsBalanceCache = 'coinsBalanceCache';
}
