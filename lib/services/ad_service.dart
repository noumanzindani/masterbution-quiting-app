import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../config.dart';
import 'ad_policy.dart';

/// The ONLY code path that talks to the ad SDK. Every show decision defers to
/// the pure, unit-tested [AdPolicy]; this class just owns SDK objects and the
/// bits of runtime state the policy needs (current route, consent, cooldown).
///
/// Test ad unit IDs are hard-coded — swap for real units before release, and
/// wire real UMP consent + iOS ATT then (see [_consentResolved]).
class AdService {
  final AdPolicy _policy = const AdPolicy();

  bool _sdkReady = false;
  bool _consentResolved = false;

  /// Updated by [AdGuardObserver] on every navigation so the policy always
  /// knows which screen is on top.
  String? currentRoute;

  InterstitialAd? _interstitial;

  // --- Google's official TEST ad units ---
  static String get bannerUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';
  static String get interstitialUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-3940256099942544/4411468910';

  Future<void> init() async {
    try {
      await MobileAds.instance.initialize();
      _sdkReady = true;
      // TODO(pre-release): gate this behind real UMP consent + iOS ATT before
      // using a production ad unit. Test ads need no consent, so we resolve it.
      _consentResolved = true;
      _loadInterstitial();
    } catch (_) {
      // Ads are strictly optional — the app must run fine without them.
      _sdkReady = false;
    }
  }

  /// May any ad show right now? Combines SDK readiness with the pure policy.
  bool canShowAds() =>
      _sdkReady &&
      _policy.canShowAds(
        currentRoute: currentRoute,
        consentResolved: _consentResolved,
        now: DateTime.now(),
        cooldownUntil: _cooldownUntil(),
      );

  /// Show an interstitial IF the cadence policy allows. Neutral call-sites only
  /// (never near crisis/urge flows — the policy also enforces this).
  Future<void> maybeShowInterstitial() async {
    final ad = _interstitial;
    if (ad == null) return;
    final allowed = _policy.canShowInterstitial(
      currentRoute: currentRoute,
      consentResolved: _consentResolved,
      now: DateTime.now(),
      lastShownAt: _lastInterstitialAt(),
      sessionCount: prefs.getInt(session.sessionInterstitialCount) ?? 0,
      cooldownUntil: _cooldownUntil(),
    );
    if (!allowed) return;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (a) {
        a.dispose();
        _interstitial = null;
        _loadInterstitial(); // preload the next one
      },
      onAdFailedToShowFullScreenContent: (a, _) {
        a.dispose();
        _interstitial = null;
        _loadInterstitial();
      },
    );
    await ad.show();
    _interstitial = null;
    _recordInterstitialShown();
  }

  /// Begin a no-ad window after a lapse — a person who just logged a slip is
  /// never monetised in that moment.
  void tripPostLapseCooldown({Duration window = const Duration(minutes: 30)}) {
    prefs.setInt(
      session.adCooldownUntil,
      DateTime.now().add(window).millisecondsSinceEpoch,
    );
  }

  // --- internals ---

  void _loadInterstitial() {
    if (!_sdkReady) return;
    InterstitialAd.load(
      adUnitId: interstitialUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitial = ad,
        onAdFailedToLoad: (_) => _interstitial = null,
      ),
    );
  }

  DateTime? _cooldownUntil() {
    final ms = prefs.getInt(session.adCooldownUntil);
    return ms == null ? null : DateTime.fromMillisecondsSinceEpoch(ms);
  }

  DateTime? _lastInterstitialAt() {
    final ms = prefs.getInt(session.interstitialLastShownAt);
    return ms == null ? null : DateTime.fromMillisecondsSinceEpoch(ms);
  }

  void _recordInterstitialShown() {
    prefs.setInt(
      session.interstitialLastShownAt,
      DateTime.now().millisecondsSinceEpoch,
    );
    prefs.setInt(
      session.sessionInterstitialCount,
      (prefs.getInt(session.sessionInterstitialCount) ?? 0) + 1,
    );
  }
}
