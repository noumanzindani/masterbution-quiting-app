import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/routes/route_name.dart';
import 'package:momentum/services/ad_policy.dart';

void main() {
  const policy = AdPolicy();
  // A fixed "now" so cooldown math is deterministic.
  final now = DateTime.utc(2026, 7, 7, 12, 0);

  group('canShowAds — no-ad zones', () {
    test('every crisis/urge route blocks ads', () {
      for (final route in AdPolicy.noAdRoutes) {
        expect(
          policy.canShowAds(
              currentRoute: route, consentResolved: true, now: now),
          isFalse,
          reason: '$route must be a no-ad zone',
        );
      }
    });

    // Iterating noAdRoutes proves the listed routes block ads — it cannot
    // notice a route dropping off the list. These are the surfaces reachable
    // from inside a crisis (the panic hub links straight to the coping plans),
    // so pin their membership explicitly.
    test('every crisis-reachable route is on the denylist', () {
      final r = RouteName();
      for (final route in [
        r.panic,
        r.emergencyMode,
        r.crisisResources,
        r.copingPlan,
        r.relapseReflection,
      ]) {
        expect(AdPolicy.noAdRoutes, contains(route));
      }
    });

    test('a normal route (home) allows ads once consent is resolved', () {
      expect(
        policy.canShowAds(currentRoute: 'home', consentResolved: true, now: now),
        isTrue,
      );
    });
  });

  group('canShowAds — gates', () {
    test('no ads until consent is resolved', () {
      expect(
        policy.canShowAds(
            currentRoute: 'home', consentResolved: false, now: now),
        isFalse,
      );
    });

    test('no ads during the post-lapse cooldown window', () {
      expect(
        policy.canShowAds(
          currentRoute: 'home',
          consentResolved: true,
          now: now,
          cooldownUntil: now.add(const Duration(minutes: 10)),
        ),
        isFalse,
      );
    });

    test('ads resume once the cooldown has passed', () {
      expect(
        policy.canShowAds(
          currentRoute: 'home',
          consentResolved: true,
          now: now,
          cooldownUntil: now.subtract(const Duration(minutes: 1)),
        ),
        isTrue,
      );
    });

    test('a null route is treated as unsafe (no ad)', () {
      expect(
        policy.canShowAds(currentRoute: null, consentResolved: true, now: now),
        isFalse,
      );
    });
  });

  group('canShowInterstitial — cadence cap', () {
    test('blocked when the session cap is already reached', () {
      expect(
        policy.canShowInterstitial(
          currentRoute: 'home',
          consentResolved: true,
          now: now,
          lastShownAt: null,
          sessionCount: 3,
          sessionCap: 3,
        ),
        isFalse,
      );
    });

    test('blocked when shown too recently (min gap not elapsed)', () {
      expect(
        policy.canShowInterstitial(
          currentRoute: 'home',
          consentResolved: true,
          now: now,
          lastShownAt: now.subtract(const Duration(minutes: 1)),
          sessionCount: 0,
          minGap: const Duration(minutes: 4),
        ),
        isFalse,
      );
    });

    test('allowed when under cap, gap elapsed, and outside no-ad zones', () {
      expect(
        policy.canShowInterstitial(
          currentRoute: 'home',
          consentResolved: true,
          now: now,
          lastShownAt: now.subtract(const Duration(minutes: 10)),
          sessionCount: 1,
          minGap: const Duration(minutes: 4),
        ),
        isTrue,
      );
    });

    test('never shows an interstitial inside a no-ad zone', () {
      expect(
        policy.canShowInterstitial(
          currentRoute: 'panic',
          consentResolved: true,
          now: now,
          lastShownAt: null,
          sessionCount: 0,
        ),
        isFalse,
      );
    });
  });
}
