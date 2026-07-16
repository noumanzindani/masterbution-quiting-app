import 'dart:convert';

import '../config.dart';
import '../data/time_buckets.dart';

/// One intention on today's plan.
class DailyPlanItem {
  DailyPlanItem(this.text, this.done);

  final String text;
  bool done;

  Map<String, dynamic> toJson() => {'t': text, 'd': done};

  factory DailyPlanItem.fromJson(Map<String, dynamic> j) =>
      DailyPlanItem(j['t'] as String? ?? '', j['d'] as bool? ?? false);
}

/// Read/write access to today's plan.
///
/// A single current-day scalar that resets each morning, so per the
/// prefs-vs-Isar rule it lives in SharedPreferences as one JSON blob rather
/// than the database. Extracted from `DailyPlannerScreen` so the coach flow's
/// practice-run echo can append to the same list the planner renders.
class DailyPlanStore {
  const DailyPlanStore._();

  /// Today's items, or empty — a plan from a previous day starts fresh, and a
  /// corrupt blob degrades to empty rather than crashing the planner.
  static List<DailyPlanItem> load() {
    final raw = prefs.getString(session.dailyPlan);
    if (raw == null) return [];
    try {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      if ((data['day'] as num?)?.toInt() != TimeBuckets.todayEpochDay()) {
        return [];
      }
      final items = (data['items'] as List?) ?? const [];
      return items
          .map((e) => DailyPlanItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> save(List<DailyPlanItem> items) {
    final data = {
      'day': TimeBuckets.todayEpochDay(),
      'items': items.map((e) => e.toJson()).toList(),
    };
    return prefs.setString(session.dailyPlan, jsonEncode(data));
  }

  /// Append an intention to today, unless it's blank or already there.
  /// De-duping matters because the coach offers the practice run on every
  /// reflection — a rough week shouldn't stack five identical rows.
  static Future<void> addIntention(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    final items = load();
    final exists = items.any(
      (e) => e.text.trim().toLowerCase() == trimmed.toLowerCase(),
    );
    if (exists) return;
    items.add(DailyPlanItem(trimmed, false));
    await save(items);
  }
}
