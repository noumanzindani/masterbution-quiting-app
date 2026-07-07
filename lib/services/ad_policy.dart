import '../routes/route_name.dart';

/// The single source of truth for *whether* an ad may show. Pure and
/// device-free so it can be exhaustively unit-tested — [AdService] holds the
/// SDK, but every show decision defers here.
///
/// Defence-in-depth guardrail (see the plan): a no-ad route denylist, a consent
/// gate (nothing before consent resolves), and a post-lapse cooldown. The
/// crisis/urge surfaces must NEVER carry an ad, and a person who just logged a
/// slip must not be monetised in that vulnerable moment.
class AdPolicy {
  const AdPolicy();

  /// Routes where no ad may ever render. Kept in sync with [RouteName]; the
  /// lock screen is included so ads never sit behind the PIN pad.
  static final Set<String> noAdRoutes = () {
    final r = RouteName();
    return {
      r.panic,
      r.urgeSurf,
      r.breathing,
      r.grounding,
      r.emergencyJournal,
      r.emergencyMode,
      r.crisisResources,
      r.relapseReflection,
      r.lock,
    };
  }();

  /// Whether *any* ad (banner/interstitial) may show right now.
  bool canShowAds({
    required String? currentRoute,
    required bool consentResolved,
    required DateTime now,
    DateTime? cooldownUntil,
  }) {
    if (!consentResolved) return false;
    if (currentRoute == null) return false; // unknown route → play safe
    if (noAdRoutes.contains(currentRoute)) return false;
    if (cooldownUntil != null && now.isBefore(cooldownUntil)) return false;
    return true;
  }

  /// Whether an interstitial may show now — [canShowAds] plus cadence limits so
  /// we never nag: a per-session cap and a minimum gap since the last one.
  bool canShowInterstitial({
    required String? currentRoute,
    required bool consentResolved,
    required DateTime now,
    required DateTime? lastShownAt,
    required int sessionCount,
    DateTime? cooldownUntil,
    int sessionCap = 3,
    Duration minGap = const Duration(minutes: 4),
  }) {
    if (!canShowAds(
      currentRoute: currentRoute,
      consentResolved: consentResolved,
      now: now,
      cooldownUntil: cooldownUntil,
    )) {
      return false;
    }
    if (sessionCount >= sessionCap) return false;
    if (lastShownAt != null && now.difference(lastShownAt) < minGap) {
      return false;
    }
    return true;
  }
}
