import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

/// Passphrase-based encryption for the local backup file. AES-256-**GCM**, so a
/// wrong passphrase or a tampered file fails the authentication tag and throws —
/// no home-rolled MAC, and no silent garbage on the wrong password.
///
/// Payload layout (all base64-encoded together): `salt(16) || iv(12) || ct+tag`.
/// The key is stretched from the passphrase with an iterated SHA-256 KDF and a
/// random per-export salt. This is a casual-backup threat model (a file the user
/// chooses to export and store), not high-security key management.
class ExportCrypto {
  const ExportCrypto._();

  static const _saltLen = 16;
  static const _ivLen = 12; // standard GCM nonce
  static const _kdfIterations = 20000;

  static String encrypt(String plaintext, String passphrase) {
    final salt = Key.fromSecureRandom(_saltLen).bytes;
    final key = Key(_deriveKey(passphrase, salt));
    final iv = IV.fromSecureRandom(_ivLen);
    final encrypter = Encrypter(AES(key, mode: AESMode.gcm));

    final encrypted = encrypter.encrypt(plaintext, iv: iv);
    final combined = Uint8List.fromList([...salt, ...iv.bytes, ...encrypted.bytes]);
    return base64.encode(combined);
  }

  /// Returns the decrypted plaintext, or throws a single clear [Exception] on a
  /// wrong passphrase or a corrupt/garbage payload (all failure modes unified so
  /// the UI can show one honest message).
  static String decrypt(String payload, String passphrase) {
    try {
      final raw = base64.decode(payload.trim());
      if (raw.length < _saltLen + _ivLen + 16) {
        throw const FormatException('payload too short');
      }
      final salt = raw.sublist(0, _saltLen);
      final ivBytes = raw.sublist(_saltLen, _saltLen + _ivLen);
      final cipher = raw.sublist(_saltLen + _ivLen);

      final key = Key(_deriveKey(passphrase, salt));
      final encrypter = Encrypter(AES(key, mode: AESMode.gcm));
      return encrypter.decrypt(
        Encrypted(Uint8List.fromList(cipher)),
        iv: IV(Uint8List.fromList(ivBytes)),
      );
    } catch (_) {
      throw Exception('Wrong passphrase or corrupt backup.');
    }
  }

  /// Iterated SHA-256 stretch → a 32-byte AES-256 key.
  static Uint8List _deriveKey(String passphrase, List<int> salt) {
    var digest = sha256.convert([...utf8.encode(passphrase), ...salt]).bytes;
    for (var i = 0; i < _kdfIterations; i++) {
      digest = sha256.convert([...digest, ...salt]).bytes;
    }
    return Uint8List.fromList(digest);
  }
}
