/// Message templates + deep-link URIs for the accountability partner. No server
/// and no contacts-plugin permission: the partner is a name + number the user
/// types, and messages go out through the OS via `sms:` / WhatsApp links, so
/// nothing leaves the device except the message the user chooses to send.
class AccountabilityMessages {
  const AccountabilityMessages._();

  static String _hi(String? name) =>
      (name != null && name.trim().isNotEmpty) ? 'Hey ${name.trim()}' : 'Hey';

  /// A warm progress update.
  static String progress({String? partnerName, required int streakDays}) {
    final streak = streakDays > 0
        ? "I'm $streakDays ${streakDays == 1 ? 'day' : 'days'} steady right now"
        : "I'm starting fresh today";
    return '${_hi(partnerName)}, quick update: $streak on the goal we talked '
        'about. Thanks for having my back. 🙏';
  }

  /// A non-shaming SOS — a request for a distraction or a chat, not a confession.
  static String sos({String? partnerName}) {
    return '${_hi(partnerName)}, I\'m having a tough moment and could use a '
        'distraction or a quick chat if you\'re around. No details needed.';
  }

  /// `sms:` URI with the message pre-filled in the body.
  static Uri smsUri(String phone, String body) =>
      Uri(scheme: 'sms', path: phone.trim(), queryParameters: {'body': body});

  /// `https://wa.me/<digits>?text=…` — WhatsApp needs a bare-digits number.
  static Uri whatsappUri(String phone, String body) {
    final digits = phone.replaceAll(RegExp(r'[^0-9]'), '');
    return Uri.https('wa.me', '/$digits', {'text': body});
  }
}
