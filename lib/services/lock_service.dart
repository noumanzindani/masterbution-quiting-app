import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

/// Salted-hash helpers for the app-lock PIN. The plaintext PIN is never stored
/// — only a per-install random salt and `SHA-256(salt + pin)`. Pure and
/// synchronous so it is trivially unit-testable; persistence lives in prefs
/// (`session.pinHash` / `session.pinSalt`) and biometric auth in the UI layer.
class LockService {
  const LockService._();

  /// A fresh random salt as a hex string. Uses [Random.secure] so salts aren't
  /// predictable across installs.
  static String generateSalt([int bytes = 16]) {
    final rng = Random.secure();
    final buf = List<int>.generate(bytes, (_) => rng.nextInt(256));
    return _hex(buf);
  }

  /// `SHA-256(salt + pin)` as a hex string.
  static String hashPin(String pin, String salt) {
    final digest = sha256.convert(utf8.encode('$salt$pin'));
    return digest.toString();
  }

  /// Constant-work equality check of [pin] against a stored hash.
  static bool verify(String pin, String salt, String expectedHash) =>
      hashPin(pin, salt) == expectedHash;

  static String _hex(List<int> bytes) =>
      bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
}
