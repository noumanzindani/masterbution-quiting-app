import '../data/collections/tracker_event.dart';
import '../data/enums.dart';
import '../data/trigger_labels.dart';

/// A single trigger with its occurrence count.
typedef TriggerCount = ({TriggerType trigger, int count});

/// Least-squares fit result over an evenly-spaced series.
typedef TrendResult = ({double slope, double projectedNext});

/// A surfaced, human-readable pattern. [id] is stable for testing/deduping;
/// [text] is the shown copy.
class Insight {
  const Insight(this.id, this.text);
  final String id;
  final String text;
}

/// The Bucketed Aggregation Engine — pure descriptive statistics over the
/// denormalized time-bucket columns on [TrackerEvent]. No AI: "72% of slips
/// after midnight" is a counted fraction, not a prediction.
///
/// Everything here is device-free and synchronous so it is fully unit-testable;
/// repositories fetch the events and hand them in. (Data volumes are personal
/// and small; if they ever grow, swap the in-memory passes for Isar `.count()`
/// aggregates in an isolate — the public API can stay the same.)
class AnalyticsEngine {
  /// Below this many relevant events we surface NO insight — a pattern drawn
  /// from a handful of points is noise, and a wrong "pattern" can feel like a
  /// verdict in a recovery context.
  static const int minSampleSize = 5;

  /// Hours considered "after midnight / late night" for the late-night insight.
  static const Set<int> lateNightHours = {0, 1, 2, 3};

  // --- filters ---

  static bool _matches(BehaviorTarget query, BehaviorTarget t) =>
      query == BehaviorTarget.both ||
      t == BehaviorTarget.both ||
      t == query;

  static List<TrackerEvent> forTarget(
          List<TrackerEvent> events, BehaviorTarget target) =>
      events.where((e) => _matches(target, e.target)).toList();

  static List<TrackerEvent> lapsesOnly(List<TrackerEvent> events) =>
      events.where((e) => e.outcome == Outcome.lapse).toList();

  // --- histograms ---

  static List<int> hourHistogram(List<TrackerEvent> events) {
    final bins = List<int>.filled(24, 0);
    for (final e in events) {
      if (e.hourOfDay >= 0 && e.hourOfDay < 24) bins[e.hourOfDay]++;
    }
    return bins;
  }

  /// Monday..Sunday as index 0..6 (from ISO [TrackerEvent.weekday] 1..7).
  static List<int> weekdayHistogram(List<TrackerEvent> events) {
    final bins = List<int>.filled(7, 0);
    for (final e in events) {
      if (e.weekday >= 1 && e.weekday <= 7) bins[e.weekday - 1]++;
    }
    return bins;
  }

  /// `[weekday 0..6][hour 0..23]` occurrence grid.
  static List<List<int>> heatmap(List<TrackerEvent> events) {
    final grid = List.generate(7, (_) => List<int>.filled(24, 0));
    for (final e in events) {
      if (e.weekday >= 1 && e.weekday <= 7 && e.hourOfDay >= 0 && e.hourOfDay < 24) {
        grid[e.weekday - 1][e.hourOfDay]++;
      }
    }
    return grid;
  }

  // --- triggers ---

  static List<TriggerCount> topTriggers(List<TrackerEvent> events,
      {int limit = 5}) {
    final counts = <TriggerType, int>{};
    for (final e in events) {
      for (final idx in e.triggers) {
        if (idx >= 0 && idx < TriggerType.values.length) {
          final t = TriggerType.values[idx];
          counts[t] = (counts[t] ?? 0) + 1;
        }
      }
    }
    final list = counts.entries
        .map((e) => (trigger: e.key, count: e.value))
        .toList()
      ..sort((a, b) => b.count.compareTo(a.count));
    return list.take(limit).toList();
  }

  // --- shares / trend ---

  static double shareInHours(List<TrackerEvent> events, Set<int> hours) {
    if (events.isEmpty) return 0.0;
    final inHours = events.where((e) => hours.contains(e.hourOfDay)).length;
    return inHours / events.length;
  }

  /// Ordinary least-squares fit of [series] against x = 0,1,2,… returning the
  /// slope and the value projected at the next x. Labelled as an estimate in
  /// the UI — descriptive, not predictive.
  static TrendResult trend(List<num> series) {
    final n = series.length;
    if (n < 2) return (slope: 0.0, projectedNext: n == 1 ? series[0].toDouble() : 0.0);
    final xs = List<int>.generate(n, (i) => i);
    final sumX = xs.reduce((a, b) => a + b).toDouble();
    final sumY = series.fold<double>(0, (a, b) => a + b);
    final sumXY = [for (var i = 0; i < n; i++) xs[i] * series[i]]
        .fold<double>(0, (a, b) => a + b);
    final sumX2 = xs.fold<double>(0, (a, b) => a + b * b);
    final denom = n * sumX2 - sumX * sumX;
    if (denom == 0) return (slope: 0.0, projectedNext: sumY / n);
    final slope = (n * sumXY - sumX * sumY) / denom;
    final intercept = (sumY - slope * sumX) / n;
    return (slope: slope, projectedNext: intercept + slope * n);
  }

  // --- insights (gated) ---

  /// Surface only well-supported, non-shaming patterns. Each rule is gated by
  /// [minSample] so nothing appears until there is enough evidence.
  static List<Insight> insights(List<TrackerEvent> events,
      {int minSample = minSampleSize}) {
    final out = <Insight>[];
    final lapses = lapsesOnly(events);

    if (lapses.length >= minSample) {
      final lateShare = shareInHours(lapses, lateNightHours);
      if (lateShare >= 0.4) {
        out.add(Insight(
          'late_night',
          '${(lateShare * 100).round()}% of your slips happen after midnight — a wind-down routine could help most there.',
        ));
      }

      final wk = weekdayHistogram(lapses);
      final peak = _argmax(wk);
      if (peak != null && wk[peak] >= 2) {
        out.add(Insight(
          'tough_weekday',
          '${_weekdayName(peak)} tends to be your toughest day. Worth planning a little extra support.',
        ));
      }
    }

    final triggered = events.where((e) => e.triggers.isNotEmpty).length;
    if (triggered >= minSample) {
      final top = topTriggers(events, limit: 1);
      if (top.isNotEmpty) {
        out.add(Insight(
          'top_trigger',
          '"${triggerLabel(top.first.trigger)}" shows up most often before an urge. Naming it is the first step.',
        ));
      }
    }

    return out;
  }

  static int? _argmax(List<int> xs) {
    if (xs.isEmpty) return null;
    var best = 0;
    for (var i = 1; i < xs.length; i++) {
      if (xs[i] > xs[best]) best = i;
    }
    return xs[best] == 0 ? null : best;
  }

  static String _weekdayName(int index0Mon) => const [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday',
      ][index0Mon];
}
