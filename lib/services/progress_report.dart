/// Builds a short, shareable progress snapshot — plain text so it works in any
/// share target (message, email, notes). Non-shaming by construction: it speaks
/// to effort and showing up, never to "failure", and reads supportively even at
/// a zero streak.
class ProgressReport {
  const ProgressReport._();

  static String build({
    required int streakDays,
    required int recoveryScore,
    required int daysActive,
    required int cleanCheckins,
    String? goalLabel,
  }) {
    final lines = <String>[
      'My Momentum progress',
      if (goalLabel != null && goalLabel.trim().isNotEmpty) '🎯 $goalLabel',
      streakDays > 0
          ? '🔥 $streakDays ${_plural(streakDays, 'day')} steady right now'
          : '🌱 Back at it today — every fresh start counts',
      '💪 Recovery score: $recoveryScore/100 (holds steady through slips)',
      '📅 Showing up for $daysActive ${_plural(daysActive, 'day')}',
      if (cleanCheckins > 0)
        '✅ $cleanCheckins clean ${_plural(cleanCheckins, 'check-in')} logged',
      '',
      'One moment at a time.',
    ];
    return lines.join('\n');
  }

  static String _plural(int n, String word) => n == 1 ? word : '${word}s';
}
