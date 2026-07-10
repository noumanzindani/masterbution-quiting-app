import '../config.dart';
import 'risk_engine.dart';
import 'smart_scheduler.dart';

/// Bridges the app's stored settings + logged data to the pure scheduler and the
/// side-effecting [NotificationService]. Kept out of the service so the service
/// stays plugin-only and the provider/AppInit share one gather→plan→schedule
/// path (no duplicated logic).
class NotificationScheduling {
  const NotificationScheduling._();

  /// Read the user's notification preferences from SharedPreferences.
  static NotificationPrefs readPrefs() => NotificationPrefs(
        enabled: prefs.getBool(session.notificationsEnabled) ?? false,
        checkInHour: prefs.getInt(session.notifCheckInHour) ?? 20,
        quietStartHour: prefs.getInt(session.notifQuietStart) ?? 22,
        quietEndHour: prefs.getInt(session.notifQuietEnd) ?? 7,
      );

  /// Recompute the risk profile from logged events and (re)schedule all
  /// reminders. Called at launch and whenever settings change, so the schedule
  /// adapts as patterns and preferences evolve. A no-op-safe path when disabled.
  static Future<void> refresh() async {
    final p = readPrefs();
    if (!p.enabled) {
      await notificationService.cancelAll();
      return;
    }
    final events = await trackerRepo.all();
    final specs = SmartScheduler.plan(RiskEngine.profile(events), p);
    await notificationService.reschedule(specs);
  }
}
