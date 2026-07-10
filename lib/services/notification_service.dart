import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'smart_scheduler.dart';

/// Thin wrapper over `flutter_local_notifications`. The *decision* of what to
/// schedule lives in the pure, tested [SmartScheduler]; this class only performs
/// the side effects (init, permission, schedule, cancel) and, like `AdService`,
/// degrades to a silent no-op if the platform can't oblige — the app must run
/// fine without notifications.
///
/// Timezone approach (no `flutter_timezone` dependency): a reminder's desired
/// *local* wall-clock time is converted to a concrete UTC instant and scheduled
/// in `tz.UTC` with `matchDateTimeComponents`, so it repeats at the same instant
/// each day/week. Re-scheduled on every launch, so a DST change self-corrects on
/// next open (worst case a ≤1h drift until then).
class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _ready = false;

  static const _channelId = 'reminders';
  static const _channelName = 'Reminders';

  Future<void> init() async {
    try {
      tzdata.initializeTimeZones();
      const android = AndroidInitializationSettings('@mipmap/ic_launcher');
      const ios = DarwinInitializationSettings(
        // Permission is requested explicitly when the user opts in, not on boot.
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );
      await _plugin.initialize(
        settings: const InitializationSettings(android: android, iOS: ios),
      );
      _ready = true;
    } catch (_) {
      _ready = false;
    }
  }

  /// Ask the OS for permission (iOS always; Android 13+). Returns whether it's
  /// granted. Safe to call repeatedly.
  Future<bool> requestPermission() async {
    if (!_ready) return false;
    try {
      final ios = await _plugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      final android = await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
      return ios ?? android ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Replace all scheduled reminders with [specs] (cancel-all then re-add, which
  /// is why [ReminderSpec.id]s are stable).
  Future<void> reschedule(List<ReminderSpec> specs) async {
    if (!_ready) return;
    try {
      await _plugin.cancelAll();
      for (final s in specs) {
        await _scheduleOne(s);
      }
    } catch (_) {
      // Never let a scheduling failure surface to the user.
    }
  }

  Future<void> cancelAll() async {
    if (!_ready) return;
    try {
      await _plugin.cancelAll();
    } catch (_) {}
  }

  Future<void> _scheduleOne(ReminderSpec s) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: 'Gentle check-ins and heads-ups',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _plugin.zonedSchedule(
      id: s.id,
      title: s.title,
      body: s.body,
      scheduledDate: _nextInstance(s.hour, s.minute, s.weekday),
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: s.weekday == null
          ? DateTimeComponents.time // daily
          : DateTimeComponents.dayOfWeekAndTime, // weekly
    );
  }

  /// The next future instant matching the given local time (and weekday, if
  /// weekly), expressed in `tz.UTC` so the repeat fires at a stable instant.
  tz.TZDateTime _nextInstance(int localHour, int localMinute, int? isoWeekday) {
    final now = DateTime.now();
    var target =
        DateTime(now.year, now.month, now.day, localHour, localMinute);

    if (isoWeekday == null) {
      if (!target.isAfter(now)) target = target.add(const Duration(days: 1));
    } else {
      while (target.weekday != isoWeekday || !target.isAfter(now)) {
        target = target.add(const Duration(days: 1));
      }
    }
    // Convert this local instant to its UTC representation for scheduling.
    return tz.TZDateTime.from(target.toUtc(), tz.UTC);
  }
}
