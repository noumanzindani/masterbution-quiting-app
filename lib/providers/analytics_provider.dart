import '../config.dart';
import '../data/collections/tracker_event.dart';
import '../data/enums.dart';
import '../data/time_buckets.dart';
import '../services/analytics_engine.dart';

/// Loads the event history and derives every descriptive statistic the Insights
/// screen shows, via the pure [AnalyticsEngine]. Scoped to the Insights screen.
class AnalyticsProvider extends ChangeNotifier {
  AnalyticsProvider() {
    load();
  }

  static const int weeksBack = 8;

  bool loading = true;
  BehaviorTarget target = BehaviorTarget.both;

  int lapseCount = 0;
  int totalRelevant = 0;
  List<List<int>> lapseHeatmap = List.generate(7, (_) => List.filled(24, 0));
  List<TriggerCount> topTriggers = const [];
  List<Insight> insights = const [];
  List<int> weeklyLapses = List.filled(weeksBack, 0);
  TrendResult weeklyTrend = (slope: 0.0, projectedNext: 0.0);

  /// Not enough logged yet to say anything meaningful — drives the empty state.
  bool get hasEnoughData => totalRelevant >= AnalyticsEngine.minSampleSize;

  Future<void> load() async {
    loading = true;
    notifyListeners();

    final events = await trackerRepo.all();
    final goal = await goalRepo.getActive();
    target = goal?.target ?? BehaviorTarget.both;

    final relevant = AnalyticsEngine.forTarget(events, target);
    final lapses = AnalyticsEngine.lapsesOnly(relevant);

    totalRelevant = relevant.length;
    lapseCount = lapses.length;
    lapseHeatmap = AnalyticsEngine.heatmap(lapses);
    topTriggers = AnalyticsEngine.topTriggers(relevant, limit: 5);
    insights = AnalyticsEngine.insights(relevant);

    weeklyLapses = _weeklyCounts(lapses);
    weeklyTrend = AnalyticsEngine.trend(weeklyLapses);

    loading = false;
    notifyListeners();
  }

  /// Lapse counts for the last [weeksBack] weeks, oldest → newest.
  List<int> _weeklyCounts(List<TrackerEvent> events) {
    final today = TimeBuckets.todayEpochDay();
    final weeks = List<int>.filled(weeksBack, 0);
    for (final e in events) {
      final w = (today - e.dateEpochDay) ~/ 7;
      if (w >= 0 && w < weeksBack) weeks[weeksBack - 1 - w]++;
    }
    return weeks;
  }
}
