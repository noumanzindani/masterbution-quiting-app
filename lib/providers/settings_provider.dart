import '../config.dart';
import '../services/lock_service.dart';

/// Owns the privacy/security + misc scalar settings (all SharedPreferences).
/// Theme is handled by [ThemeService]; this covers app-lock, biometrics and
/// discreet mode.
class SettingsProvider extends ChangeNotifier {
  bool get appLockEnabled => prefs.getBool(session.appLockEnabled) ?? false;
  bool get biometricEnabled =>
      prefs.getBool('${session.appLockType}_biometric') ?? false;
  bool get discreetMode => prefs.getBool(session.discreetModeEnabled) ?? false;

  /// Store a new PIN as a salted hash and enable the lock. The plaintext PIN is
  /// never persisted — see [LockService].
  Future<void> setPin(String pin) async {
    final salt = LockService.generateSalt();
    await prefs.setString(session.pinSalt, salt);
    await prefs.setString(session.pinHash, LockService.hashPin(pin, salt));
    await prefs.setBool(session.appLockEnabled, true);
    notifyListeners();
  }

  /// Verify an entered PIN against the stored hash.
  bool verifyPin(String pin) {
    final salt = prefs.getString(session.pinSalt);
    final hash = prefs.getString(session.pinHash);
    if (salt == null || hash == null) return false;
    return LockService.verify(pin, salt, hash);
  }

  Future<void> disableLock() async {
    await prefs.remove(session.pinSalt);
    await prefs.remove(session.pinHash);
    await prefs.setBool(session.appLockEnabled, false);
    await setBiometric(false);
    notifyListeners();
  }

  Future<void> setBiometric(bool on) async {
    await prefs.setBool('${session.appLockType}_biometric', on);
    notifyListeners();
  }

  Future<void> setDiscreet(bool on) async {
    await prefs.setBool(session.discreetModeEnabled, on);
    notifyListeners();
  }
}
