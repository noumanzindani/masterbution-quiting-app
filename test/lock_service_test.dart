import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/services/lock_service.dart';

void main() {
  group('PIN hashing', () {
    test('same pin + salt is deterministic', () {
      final salt = LockService.generateSalt();
      expect(LockService.hashPin('1234', salt), LockService.hashPin('1234', salt));
    });

    test('the stored hash is never the plaintext pin', () {
      final salt = LockService.generateSalt();
      final hash = LockService.hashPin('1234', salt);
      expect(hash, isNot(contains('1234')));
      expect(hash.length, greaterThan(16));
    });

    test('verify accepts the correct pin and rejects a wrong one', () {
      final salt = LockService.generateSalt();
      final hash = LockService.hashPin('1234', salt);
      expect(LockService.verify('1234', salt, hash), isTrue);
      expect(LockService.verify('9999', salt, hash), isFalse);
    });

    test('the same pin under a different salt yields a different hash', () {
      final a = LockService.generateSalt();
      final b = LockService.generateSalt();
      expect(a, isNot(b)); // salts are unique
      expect(LockService.hashPin('1234', a),
          isNot(LockService.hashPin('1234', b)));
    });
  });
}
