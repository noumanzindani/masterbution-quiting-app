import '../data/collections/tracker_event.dart';
import 'analytics_engine.dart';

/// The numeric risk pattern behind proactive help: when (hour of day, weekday)
/// slips cluster. Where [AnalyticsEngine.insights] produces prose for the
/// screen, a [RiskProfile] produces *numbers* the notification scheduler can
/// turn into reminder times.
class RiskProfile {
  const RiskProfile({this.peakRiskHour, this.toughestWeekday});

  /// Local hour (0–23) that slips cluster in, or null if there's no clear
  /// pattern yet.
  final int? peakRiskHour;

  /// ISO weekday (1=Mon..7=Sun) that slips cluster on, or null.
  final int? toughestWeekday;

  bool get hasSignal => peakRiskHour != null || toughestWeekday != null;

  static const empty = RiskProfile();
}

/// Derives a [RiskProfile] from logged events — pure statistics, no AI, gated so
/// a handful of points never becomes a "verdict" in a recovery context.
class RiskEngine {
  const RiskEngine._();

  /// A pattern is surfaced only when there are at least this many lapses AND the
  /// peak bin holds at least [_minCluster] of them — enough to be a real cluster
  /// rather than noise.
  static const int minSample = AnalyticsEngine.minSampleSize;
  static const int _minCluster = 2;

  static RiskProfile profile(List<TrackerEvent> events, {int minSample = minSample}) {
    final lapses = AnalyticsEngine.lapsesOnly(events);
    if (lapses.length < minSample) return RiskProfile.empty;

    final hourPeak = _clusterPeak(AnalyticsEngine.hourHistogram(lapses));
    final wkPeak = _clusterPeak(AnalyticsEngine.weekdayHistogram(lapses));

    return RiskProfile(
      peakRiskHour: hourPeak, // histogram index == hour
      toughestWeekday: wkPeak == null ? null : wkPeak + 1, // 0..6 → ISO 1..7
    );
  }

  /// Index of the largest bin, but only if it reaches [_minCluster]; else null.
  static int? _clusterPeak(List<int> bins) {
    if (bins.isEmpty) return null;
    var best = 0;
    for (var i = 1; i < bins.length; i++) {
      if (bins[i] > bins[best]) best = i;
    }
    return bins[best] >= _minCluster ? best : null;
  }
}
