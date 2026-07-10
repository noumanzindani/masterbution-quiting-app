import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/services/export_crypto.dart';

void main() {
  const passphrase = 'correct horse battery staple';
  const plaintext = '{"version":1,"hello":"world with unicode ☂ é"}';

  group('ExportCrypto round-trip', () {
    test('decrypt(encrypt(x)) with the right passphrase returns x', () {
      final payload = ExportCrypto.encrypt(plaintext, passphrase);
      expect(ExportCrypto.decrypt(payload, passphrase), plaintext);
    });

    test('an empty passphrase still round-trips (no crash)', () {
      final payload = ExportCrypto.encrypt(plaintext, '');
      expect(ExportCrypto.decrypt(payload, ''), plaintext);
    });
  });

  group('ExportCrypto security properties', () {
    test('the wrong passphrase throws rather than returning garbage', () {
      final payload = ExportCrypto.encrypt(plaintext, passphrase);
      expect(() => ExportCrypto.decrypt(payload, 'wrong'), throwsException);
    });

    test('a corrupt/garbage payload throws', () {
      expect(() => ExportCrypto.decrypt('not-a-real-payload', passphrase),
          throwsException);
    });

    test('encrypting the same text twice yields different ciphertext', () {
      final a = ExportCrypto.encrypt(plaintext, passphrase);
      final b = ExportCrypto.encrypt(plaintext, passphrase);
      expect(a, isNot(equals(b)));
    });
  });
}
