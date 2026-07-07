/// Converts a local moment into the denormalized time-bucket columns stored on
/// every [TrackerEvent]: local hour, local ISO weekday, and a local calendar-day
/// index.
///
/// Correctness note: [dateEpochDay] must be the same for two events on the same
/// local calendar day and differ by exactly one across midnight — including
/// across Daylight-Saving nights. We therefore reduce the local date to its
/// (year, month, day) and measure the gap between *UTC* midnights, so no DST
/// hour ever leaks into the day arithmetic. This is the single primitive both
/// the event writers and the streak reader rely on to agree on "which day".
class TimeBuckets {
  const TimeBuckets({
    required this.hourOfDay,
    required this.weekday,
    required this.dateEpochDay,
  });

  /// Local hour of day, 0–23.
  final int hourOfDay;

  /// Local ISO weekday, 1 (Mon) – 7 (Sun).
  final int weekday;

  /// Local calendar days since 1970-01-01.
  final int dateEpochDay;

  factory TimeBuckets.fromLocal(DateTime local) => TimeBuckets(
        hourOfDay: local.hour,
        weekday: local.weekday,
        dateEpochDay: epochDayForLocal(local),
      );

  /// Local calendar-day index for [local] — DST-safe (see class docs).
  static int epochDayForLocal(DateTime local) {
    final localMidnightAsUtc = DateTime.utc(local.year, local.month, local.day);
    return localMidnightAsUtc.difference(DateTime.utc(1970, 1, 1)).inDays;
  }

  /// Convenience: today's local calendar-day index. Callers pass this to the
  /// streak service as `todayEpochDay`.
  static int todayEpochDay() => epochDayForLocal(DateTime.now());
}
