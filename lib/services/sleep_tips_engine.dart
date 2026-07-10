/// One night of sleep, reduced to the three signals the tips engine reasons
/// about. Kept free of Isar/DateTime so the engine stays a pure function that
/// is trivial to test.
///
/// [bedtimeMinutes] is the local minute-of-day the person went to bed (0–1439,
/// e.g. 23:00 → 1380, 01:00 → 60).
class SleepNight {
  const SleepNight({
    required this.durationMinutes,
    required this.bedtimeMinutes,
    required this.quality,
  });

  /// Total time asleep, in minutes.
  final int durationMinutes;

  /// Bedtime as a local minute-of-day (0–1439).
  final int bedtimeMinutes;

  /// Self-rated quality, 1 (poor) – 5 (great).
  final int quality;
}

/// A single non-shaming, actionable sleep recommendation.
class SleepTip {
  const SleepTip(this.id, this.title, this.body);

  final String id;
  final String title;
  final String body;
}

/// Rule-based (no-AI) sleep coaching. Turns a handful of logged nights into a
/// short, prioritised list of gentle recommendations using descriptive
/// statistics only — the same "statistics, not AI" contract as
/// `AnalyticsEngine`.
///
/// Design notes:
/// - **Min-sample gate:** with fewer than [_minNights] nights the engine won't
///   infer a pattern; it returns one encouraging "keep logging" tip. This is a
///   clinical guardrail — no shaming conclusions drawn from one rough night.
/// - **Circular bedtime:** a bedtime before noon belongs to the *early morning*
///   of the sleep-day, so it is anchored to the next day (+1440). This makes an
///   evening→morning window monotonic, so "how late" and "how spread out" are
///   plain numeric comparisons rather than circular statistics.
class SleepTipsEngine {
  const SleepTipsEngine._();

  /// Below this many logged nights, only the starter tip is shown.
  static const int _minNights = 3;

  /// Adequate sleep floor: 7 hours.
  static const int _shortSleepMinutes = 420;

  /// Severely short: 6 hours — a firmer message, same tip id.
  static const int _veryShortSleepMinutes = 360;

  /// A bedtime spread wider than this (minutes) reads as an irregular schedule.
  static const int _consistencySpreadMinutes = 90;

  /// Anchored bedtime later than 00:30 (24:30 → 1470) reads as "late".
  static const int _lateBedtimeAnchored = 1470;

  /// Average quality at or below this (of 5) reads as poor.
  static const int _lowQuality = 2;

  static List<SleepTip> tips(List<SleepNight> nights) {
    if (nights.length < _minNights) {
      return const [
        SleepTip(
          'log_more',
          'Log a few nights',
          'Track your sleep for a few nights and personalised tips will appear '
              'here. There\'s no streak to break — just gentle patterns.',
        ),
      ];
    }

    final avgDuration = _avg(nights.map((n) => n.durationMinutes));
    final avgQuality = _avg(nights.map((n) => n.quality));
    final anchored = nights.map((n) => _anchor(n.bedtimeMinutes)).toList();
    final spread = _spread(anchored);
    final avgBedtime = _avg(anchored);

    final out = <SleepTip>[];

    if (avgDuration < _shortSleepMinutes) {
      final hours = (avgDuration / 60).toStringAsFixed(1);
      out.add(SleepTip(
        'short_sleep',
        'Aim for a little more sleep',
        avgDuration < _veryShortSleepMinutes
            ? 'You\'re averaging about $hours hours. Most adults do best on '
                '7–9 hours — even 20 extra minutes tonight helps.'
            : 'You\'re averaging about $hours hours, just under the 7–9 hours '
                'most adults need. Try an earlier wind-down.',
      ));
    }

    if (avgBedtime > _lateBedtimeAnchored) {
      out.add(const SleepTip(
        'late_bedtime',
        'Wind down a bit earlier',
        'Your bedtime tends to run late. A calm wind-down routine — dim '
            'lights, no screens, a short breathing session — makes an earlier '
            'bedtime feel natural.',
      ));
    }

    if (spread > _consistencySpreadMinutes) {
      out.add(const SleepTip(
        'consistency',
        'Keep a steadier schedule',
        'Your bedtime varies quite a bit night to night. A consistent sleep '
            'and wake time — even on weekends — is one of the strongest levers '
            'for better rest.',
      ));
    }

    if (avgQuality <= _lowQuality) {
      out.add(const SleepTip(
        'quality',
        'Improve your sleep quality',
        'Your rest hasn\'t felt great lately. Small sleep-hygiene changes — a '
            'cooler, darker room and cutting caffeine after midday — often make '
            'a real difference.',
      ));
    }

    if (out.isEmpty) {
      out.add(const SleepTip(
        'on_track',
        'Your sleep looks solid',
        'Consistent timing, enough hours, and decent quality — keep it up. '
            'Protecting your sleep protects your recovery.',
      ));
    }

    return out;
  }

  /// Anchors a pre-noon bedtime to the following day so an evening→morning
  /// window is monotonically increasing.
  static int _anchor(int minuteOfDay) =>
      minuteOfDay < 720 ? minuteOfDay + 1440 : minuteOfDay;

  static double _avg(Iterable<int> xs) {
    final list = xs.toList();
    if (list.isEmpty) return 0;
    return list.reduce((a, b) => a + b) / list.length;
  }

  static int _spread(List<int> xs) {
    if (xs.isEmpty) return 0;
    final lo = xs.reduce((a, b) => a < b ? a : b);
    final hi = xs.reduce((a, b) => a > b ? a : b);
    return hi - lo;
  }
}
