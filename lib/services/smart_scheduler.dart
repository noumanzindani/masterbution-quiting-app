import 'risk_engine.dart';

/// User-controlled notification preferences. All opt-in: [enabled] defaults to
/// false so nothing is scheduled until the person turns reminders on.
class NotificationPrefs {
  const NotificationPrefs({
    this.enabled = false,
    this.checkInHour = 20,
    this.quietStartHour = 22,
    this.quietEndHour = 7,
  });

  final bool enabled;

  /// Preferred daily check-in hour (0–23).
  final int checkInHour;

  /// Quiet window [quietStartHour, quietEndHour) in local hours — may wrap
  /// midnight (default 22:00–07:00). No reminder ever fires inside it.
  final int quietStartHour;
  final int quietEndHour;
}

/// A single local reminder to schedule. [id] is a stable numeric handle for the
/// notification plugin (so rescheduling replaces cleanly); [key] is the stable
/// string used in reasoning/tests. [weekday] null means a daily repeat; an ISO
/// weekday (1=Mon..7=Sun) means weekly on that day.
class ReminderSpec {
  const ReminderSpec({
    required this.id,
    required this.key,
    required this.hour,
    required this.minute,
    required this.title,
    required this.body,
    this.weekday,
  });

  final int id;
  final String key;
  final int hour;
  final int minute;
  final int? weekday;
  final String title;
  final String body;
}

/// Turns a [RiskProfile] + [NotificationPrefs] into a deterministic set of local
/// reminders — rule-based scheduling, no AI. Every candidate is filtered through
/// the quiet-hours guardrail, so the app never disturbs the person in a window
/// they've marked off.
class SmartScheduler {
  const SmartScheduler._();

  // Stable ids so a reschedule (cancel-all + re-add) maps 1:1.
  static const _idCheckIn = 1;
  static const _idHeadsUp = 2;
  static const _idToughDay = 3;

  /// Morning hour for the tough-day nudge.
  static const _toughDayHour = 9;

  static List<ReminderSpec> plan(RiskProfile profile, NotificationPrefs prefs) {
    if (!prefs.enabled) return const [];

    final candidates = <ReminderSpec>[
      ReminderSpec(
        id: _idCheckIn,
        key: 'daily_checkin',
        hour: prefs.checkInHour,
        minute: 0,
        title: 'How are you doing?',
        body: 'A quick, no-pressure check-in. Notice how today has felt.',
      ),
      if (profile.peakRiskHour != null)
        ReminderSpec(
          id: _idHeadsUp,
          key: 'risk_heads_up',
          hour: (profile.peakRiskHour! - 1 + 24) % 24,
          minute: 0,
          title: 'You\'ve got this',
          body: 'Your tougher window tends to come up around now. Have a plan '
              'ready — a walk, a call, a breathing session.',
        ),
      if (profile.toughestWeekday != null)
        ReminderSpec(
          id: _idToughDay,
          key: 'tough_day',
          hour: _toughDayHour,
          minute: 0,
          weekday: profile.toughestWeekday,
          title: 'Extra support today',
          body: 'This day can be a little harder. Line up something good for '
              'yourself early.',
        ),
    ];

    return candidates
        .where((s) => !_inQuietHours(s.hour, s.minute, prefs))
        .toList();
  }

  /// True if [hour]:[minute] falls in the (possibly midnight-wrapping) quiet
  /// window [quietStartHour, quietEndHour).
  static bool _inQuietHours(int hour, int minute, NotificationPrefs prefs) {
    final t = hour * 60 + minute;
    final start = prefs.quietStartHour * 60;
    final end = prefs.quietEndHour * 60;
    if (start == end) return false; // no quiet window
    return start < end
        ? (t >= start && t < end) // same-day window
        : (t >= start || t < end); // wraps midnight
  }
}
