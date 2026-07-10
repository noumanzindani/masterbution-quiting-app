import 'package:flutter/services.dart';

/// Switches the app's home-screen icon (and, on Android, its launcher name) to
/// a neutral "disguise" and back, so the app can hide in plain sight.
///
/// This is the Dart half of a platform channel; the real work happens natively:
///  - **iOS** flips between the primary icon and an `AppIcon-Disguise` alternate
///    icon via `UIApplication.setAlternateIconName`. iOS cannot rename an app at
///    runtime, so only the icon changes there.
///  - **Android** enables a disguised `<activity-alias>` (its own label + icon)
///    and disables the default launcher component, so both name and icon change.
///
/// The persisted `discreetMode` preference is the source of truth; if a device
/// can't switch icons (older OS, unsupported, or the unit-test harness), we
/// degrade silently rather than let the settings toggle throw.
class DisguiseService {
  const DisguiseService();

  static const MethodChannel _channel =
      MethodChannel('com.tideapp.momentum/disguise');

  /// Apply the disguise ([enabled] true) or restore the default ([enabled]
  /// false). Never throws — platform failures are swallowed.
  Future<void> apply(bool enabled) async {
    try {
      await _channel.invokeMethod<void>('setDiscreet', {'enabled': enabled});
    } catch (_) {
      // Unsupported platform / no native handler — the pref still holds, so the
      // UI stays correct and we simply skip the cosmetic icon change.
    }
  }
}
