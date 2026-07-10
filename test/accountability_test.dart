import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/services/accountability.dart';

void main() {
  group('AccountabilityMessages templates', () {
    test('progress message names the partner and the streak', () {
      final m = AccountabilityMessages.progress(partnerName: 'Sam', streakDays: 9);
      expect(m.contains('Sam'), isTrue);
      expect(m.contains('9'), isTrue);
    });

    test('messages work without a partner name', () {
      expect(AccountabilityMessages.progress(streakDays: 3).trim(), isNotEmpty);
      expect(AccountabilityMessages.sos().trim(), isNotEmpty);
    });

    test('SOS message is non-shaming and asks for support', () {
      final s = AccountabilityMessages.sos(partnerName: 'Alex').toLowerCase();
      expect(s.contains('alex'), isTrue);
      expect(s.contains('fail'), isFalse);
    });
  });

  group('AccountabilityMessages URIs', () {
    test('sms URI carries the body as a query parameter', () {
      final uri = AccountabilityMessages.smsUri('+1 555 0100', 'hi there');
      expect(uri.scheme, 'sms');
      expect(uri.queryParameters['body'], 'hi there');
    });

    test('whatsapp URI strips formatting to bare digits', () {
      final uri = AccountabilityMessages.whatsappUri('+1 (555) 010-0', 'hi');
      expect(uri.host, 'wa.me');
      expect(uri.path.contains('15550100'), isTrue);
    });
  });
}
