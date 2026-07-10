import 'package:isar_community/isar.dart';

part 'sleep_entry.g.dart';

/// One night's sleep log: when you went to bed, when you woke, and how it felt.
///
/// Times are stored as local minute-of-day (0–1439) rather than DateTimes so
/// the "23:00 → 07:00" wrap across midnight is a plain arithmetic concern, not a
/// timezone one. [dateEpochDay] is the local day of the *morning* you woke, so
/// history reads chronologically and a night is only logged once per day.
@collection
class SleepEntry {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime timestampUtc;

  @Index()
  late int dateEpochDay;

  /// Bedtime as a local minute-of-day (0–1439). 23:00 → 1380, 01:00 → 60.
  late int bedtimeMinutes;

  /// Wake time as a local minute-of-day (0–1439).
  late int wakeMinutes;

  /// Self-rated quality, 1 (poor) – 5 (great).
  late int quality;

  String? note;

  /// Total time asleep in minutes, resolving the wrap past midnight. Not
  /// persisted — derived from the two stored times.
  @ignore
  int get durationMinutes {
    var wake = wakeMinutes;
    if (wake <= bedtimeMinutes) wake += 1440;
    return wake - bedtimeMinutes;
  }
}
