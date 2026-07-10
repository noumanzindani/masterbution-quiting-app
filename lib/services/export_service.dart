import 'dart:io';

import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../config.dart';
import '../data/collections/assessment_result.dart';
import '../data/collections/cbt_entry.dart';
import '../data/collections/habit_definition.dart';
import '../data/collections/habit_tick.dart';
import '../data/collections/journal_entry.dart';
import '../data/collections/mood_entry.dart';
import '../data/collections/recovery_goal.dart';
import '../data/collections/sleep_entry.dart';
import '../data/collections/tracker_event.dart';
import '../data/enums.dart';
import 'export_codec.dart';
import 'export_crypto.dart';

/// Section keys used in the backup envelope and the sharing-scope controls.
class ExportSections {
  static const tracker = 'tracker';
  static const goals = 'goals';
  static const assessments = 'assessments';
  static const journal = 'journal';
  static const habits = 'habits';
  static const habitTicks = 'habitTicks';
  static const mood = 'mood';
  static const cbt = 'cbt';
  static const sleep = 'sleep';
  static const prefs = 'prefs';

  /// Everything, in a stable order.
  static const all = <String>[
    tracker, goals, assessments, journal, habits, habitTicks, mood, cbt, sleep,
    prefs,
  ];
}

/// The scalar preferences worth carrying in a backup (progress + settings, never
/// the PIN hash/salt — secrets must not travel in an exportable file).
const _prefKeys = <String>[
  'dopamineProgress', 'chosenValues', 'valuesReflection', 'dailyPlan',
  'unlockedAchievements', 'rewardCoinsFromAds', 'rewardCoinsSpent',
  'unlockedAccents', 'chosenAccent', 'firstLaunchDate',
  'notificationsEnabled', 'notifCheckInHour', 'notifQuietStart', 'notifQuietEnd',
];

/// Reads the whole local database + selected prefs into a portable, encrypted
/// backup, and restores one. The wire format ([ExportCodec]) and encryption
/// ([ExportCrypto]) are pure + unit-tested; this class does the Isar/file I/O.
///
/// Never exports the app-lock PIN hash/salt — secrets must not leave in a file
/// the user may share.
class ExportService {
  const ExportService._();

  static String _iso(DateTime d) => d.toUtc().toIso8601String();
  static DateTime _dt(Object? s) =>
      DateTime.tryParse(s?.toString() ?? '')?.toUtc() ?? DateTime.utc(1970);
  static T _enumAt<T>(List<T> values, Object? i, T fallback) {
    final idx = i is int ? i : int.tryParse('$i');
    return (idx != null && idx >= 0 && idx < values.length)
        ? values[idx]
        : fallback;
  }

  // --- gather (Isar → maps) ---

  static Future<Map<String, dynamic>> _gatherAll() async {
    final isar = isarService.isar;
    return {
      ExportSections.tracker: [
        for (final e in await isar.trackerEvents.where().sortByDateEpochDay().findAll())
          {
            'id': e.id,
            'ts': _iso(e.timestampUtc),
            'logType': e.logType.index,
            'outcome': e.outcome.index,
            'target': e.target.index,
            'hourOfDay': e.hourOfDay,
            'weekday': e.weekday,
            'dateEpochDay': e.dateEpochDay,
            'emotion': e.emotion,
            'note': e.note,
            'triggers': e.triggers,
          }
      ],
      ExportSections.goals: [
        for (final g in await isar.recoveryGoals.where().sortByTargetDays().findAll())
          {
            'id': g.id,
            'type': g.type.index,
            'target': g.target.index,
            'targetDays': g.targetDays,
            'startDate': _iso(g.startDate),
            'active': g.active,
            'milestones': [
              for (final m in g.milestones)
                {
                  'day': m.day,
                  'label': m.label,
                  'reached': m.reached,
                  'reachedAt': m.reachedAt == null ? null : _iso(m.reachedAt!),
                }
            ],
          }
      ],
      ExportSections.assessments: [
        for (final a in await isar.assessmentResults.where().sortByTimestampUtc().findAll())
          {
            'id': a.id,
            'ts': _iso(a.timestampUtc),
            'adhd': a.adhdScore,
            'anxiety': a.anxietyScore,
            'depression': a.depressionScore,
            'frequency': a.frequencyScore,
            'sleep': a.sleepScore,
            'stress': a.stressScore,
            'recoveryDifficulty': a.recoveryDifficultyScore,
            'suggestedGoal': a.suggestedGoal.index,
            'planId': a.planId,
            'rawAnswersJson': a.rawAnswersJson,
          }
      ],
      ExportSections.journal: [
        for (final j in await isar.journalEntrys.where().sortByDateEpochDay().findAll())
          {
            'id': j.id,
            'ts': _iso(j.timestampUtc),
            'dateEpochDay': j.dateEpochDay,
            'kind': j.kind.index,
            'text': j.text,
            'emotion': j.emotion,
          }
      ],
      ExportSections.habits: [
        for (final h in await isar.habitDefinitions.where().sortByCreatedEpochDay().findAll())
          {
            'id': h.id,
            'type': h.type.index,
            'title': h.title,
            'active': h.active,
            'createdEpochDay': h.createdEpochDay,
          }
      ],
      ExportSections.habitTicks: [
        for (final t in await isar.habitTicks.where().sortByDateEpochDay().findAll())
          {'id': t.id, 'habitId': t.habitId, 'dateEpochDay': t.dateEpochDay}
      ],
      ExportSections.mood: [
        for (final m in await isar.moodEntrys.where().sortByDateEpochDay().findAll())
          {
            'id': m.id,
            'ts': _iso(m.timestampUtc),
            'dateEpochDay': m.dateEpochDay,
            'mood': m.mood,
            'tags': m.tags,
            'note': m.note,
          }
      ],
      ExportSections.cbt: [
        for (final c in await isar.cbtEntrys.where().sortByDateEpochDay().findAll())
          {
            'id': c.id,
            'ts': _iso(c.timestampUtc),
            'dateEpochDay': c.dateEpochDay,
            'exercise': c.exercise.index,
            'worksheetId': c.worksheetId,
            'title': c.title,
            'responsesJson': c.responsesJson,
          }
      ],
      ExportSections.sleep: [
        for (final s in await isar.sleepEntrys.where().sortByDateEpochDay().findAll())
          {
            'id': s.id,
            'ts': _iso(s.timestampUtc),
            'dateEpochDay': s.dateEpochDay,
            'bedtimeMinutes': s.bedtimeMinutes,
            'wakeMinutes': s.wakeMinutes,
            'quality': s.quality,
            'note': s.note,
          }
      ],
      ExportSections.prefs: {
        for (final k in _prefKeys)
          if (prefs.get(k) != null) k: prefs.get(k),
      },
    };
  }

  /// Build an encrypted backup string for the chosen [include] sections.
  static Future<String> buildEncryptedBackup({
    required Set<String> include,
    required String passphrase,
    required DateTime now,
  }) async {
    final all = await _gatherAll();
    final data = ExportCodec.filter(all, include);
    final json = ExportCodec.encode(data: data, exportedAt: _iso(now));
    return ExportCrypto.encrypt(json, passphrase);
  }

  /// Write the backup to a temp file and hand it to the OS share sheet.
  static Future<void> shareBackup({
    required Set<String> include,
    required String passphrase,
    required DateTime now,
  }) async {
    final payload =
        await buildEncryptedBackup(include: include, passphrase: passphrase, now: now);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/momentum-backup.momentumbackup');
    await file.writeAsString(payload);
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        subject: 'Momentum backup',
        text: 'Your encrypted Momentum backup. Keep your passphrase safe — '
            'without it this file can\'t be restored.',
      ),
    );
  }

  /// Decrypt + validate a pasted backup and restore it, replacing the current
  /// contents of each section present. Returns the number of rows restored.
  static Future<int> restoreFromPayload(String payload, String passphrase) async {
    final json = ExportCrypto.decrypt(payload, passphrase); // throws if wrong
    final bundle = ExportCodec.decode(json); // throws if not a backup
    final data = bundle.data;
    final isar = isarService.isar;
    var restored = 0;

    await isar.writeTxn(() async {
      if (data[ExportSections.tracker] case final List rows) {
        await isar.trackerEvents.clear();
        await isar.trackerEvents.putAll([
          for (final r in rows.cast<Map>())
            TrackerEvent()
              ..id = r['id'] as int
              ..timestampUtc = _dt(r['ts'])
              ..logType = _enumAt(LogType.values, r['logType'], LogType.urge)
              ..outcome = _enumAt(Outcome.values, r['outcome'], Outcome.neutral)
              ..target = _enumAt(BehaviorTarget.values, r['target'], BehaviorTarget.both)
              ..hourOfDay = r['hourOfDay'] as int
              ..weekday = r['weekday'] as int
              ..dateEpochDay = r['dateEpochDay'] as int
              ..emotion = r['emotion'] as String?
              ..note = r['note'] as String?
              ..triggers = (r['triggers'] as List).map((e) => e as int).toList()
        ]);
        restored += rows.length;
      }
      if (data[ExportSections.goals] case final List rows) {
        await isar.recoveryGoals.clear();
        await isar.recoveryGoals.putAll([
          for (final r in rows.cast<Map>())
            RecoveryGoal()
              ..id = r['id'] as int
              ..type = _enumAt(GoalType.values, r['type'], GoalType.values.first)
              ..target = _enumAt(BehaviorTarget.values, r['target'], BehaviorTarget.both)
              ..targetDays = r['targetDays'] as int
              ..startDate = _dt(r['startDate'])
              ..active = r['active'] as bool? ?? false
              ..milestones = [
                for (final m in (r['milestones'] as List? ?? const []).cast<Map>())
                  Milestone()
                    ..day = m['day'] as int
                    ..label = m['label'] as String? ?? ''
                    ..reached = m['reached'] as bool? ?? false
                    ..reachedAt = m['reachedAt'] == null ? null : _dt(m['reachedAt'])
              ]
        ]);
        restored += rows.length;
      }
      if (data[ExportSections.journal] case final List rows) {
        await isar.journalEntrys.clear();
        await isar.journalEntrys.putAll([
          for (final r in rows.cast<Map>())
            JournalEntry()
              ..id = r['id'] as int
              ..timestampUtc = _dt(r['ts'])
              ..dateEpochDay = r['dateEpochDay'] as int
              ..kind = _enumAt(JournalKind.values, r['kind'], JournalKind.dailyReflection)
              ..text = r['text'] as String? ?? ''
              ..emotion = r['emotion'] as String?
        ]);
        restored += rows.length;
      }
      if (data[ExportSections.mood] case final List rows) {
        await isar.moodEntrys.clear();
        await isar.moodEntrys.putAll([
          for (final r in rows.cast<Map>())
            MoodEntry()
              ..id = r['id'] as int
              ..timestampUtc = _dt(r['ts'])
              ..dateEpochDay = r['dateEpochDay'] as int
              ..mood = r['mood'] as int
              ..tags = (r['tags'] as List? ?? const []).map((e) => '$e').toList()
              ..note = r['note'] as String?
        ]);
        restored += rows.length;
      }
      if (data[ExportSections.habits] case final List rows) {
        await isar.habitDefinitions.clear();
        await isar.habitDefinitions.putAll([
          for (final r in rows.cast<Map>())
            HabitDefinition()
              ..id = r['id'] as int
              ..type = _enumAt(HabitType.values, r['type'], HabitType.values.first)
              ..title = r['title'] as String? ?? ''
              ..active = r['active'] as bool? ?? true
              ..createdEpochDay = r['createdEpochDay'] as int
        ]);
        restored += rows.length;
      }
      if (data[ExportSections.habitTicks] case final List rows) {
        await isar.habitTicks.clear();
        await isar.habitTicks.putAll([
          for (final r in rows.cast<Map>())
            HabitTick()
              ..id = r['id'] as int
              ..habitId = r['habitId'] as int
              ..dateEpochDay = r['dateEpochDay'] as int
        ]);
        restored += rows.length;
      }
      if (data[ExportSections.cbt] case final List rows) {
        await isar.cbtEntrys.clear();
        await isar.cbtEntrys.putAll([
          for (final r in rows.cast<Map>())
            CbtEntry()
              ..id = r['id'] as int
              ..timestampUtc = _dt(r['ts'])
              ..dateEpochDay = r['dateEpochDay'] as int
              ..exercise = _enumAt(CbtExercise.values, r['exercise'], CbtExercise.values.first)
              ..worksheetId = r['worksheetId'] as String? ?? ''
              ..title = r['title'] as String? ?? ''
              ..responsesJson = r['responsesJson'] as String? ?? '{}'
        ]);
        restored += rows.length;
      }
      if (data[ExportSections.sleep] case final List rows) {
        await isar.sleepEntrys.clear();
        await isar.sleepEntrys.putAll([
          for (final r in rows.cast<Map>())
            SleepEntry()
              ..id = r['id'] as int
              ..timestampUtc = _dt(r['ts'])
              ..dateEpochDay = r['dateEpochDay'] as int
              ..bedtimeMinutes = r['bedtimeMinutes'] as int
              ..wakeMinutes = r['wakeMinutes'] as int
              ..quality = r['quality'] as int
              ..note = r['note'] as String?
        ]);
        restored += rows.length;
      }
      if (data[ExportSections.assessments] case final List rows) {
        await isar.assessmentResults.clear();
        await isar.assessmentResults.putAll([
          for (final r in rows.cast<Map>())
            AssessmentResult()
              ..id = r['id'] as int
              ..timestampUtc = _dt(r['ts'])
              ..adhdScore = r['adhd'] as int
              ..anxietyScore = r['anxiety'] as int
              ..depressionScore = r['depression'] as int
              ..frequencyScore = r['frequency'] as int
              ..sleepScore = r['sleep'] as int
              ..stressScore = r['stress'] as int
              ..recoveryDifficultyScore = r['recoveryDifficulty'] as int
              ..suggestedGoal = _enumAt(GoalType.values, r['suggestedGoal'], GoalType.values.first)
              ..planId = r['planId'] as String? ?? ''
              ..rawAnswersJson = r['rawAnswersJson'] as String? ?? '{}'
        ]);
        restored += rows.length;
      }
    });

    // Prefs restored outside the Isar txn.
    if (data[ExportSections.prefs] case final Map p) {
      for (final entry in p.entries) {
        await _restorePref('${entry.key}', entry.value);
      }
    }
    return restored;
  }

  static Future<void> _restorePref(String key, Object? value) async {
    switch (value) {
      case bool b:
        await prefs.setBool(key, b);
      case int i:
        await prefs.setInt(key, i);
      case double d:
        await prefs.setDouble(key, d);
      case String s:
        await prefs.setString(key, s);
      case List l:
        await prefs.setStringList(key, l.map((e) => '$e').toList());
    }
  }
}
