import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'collections/assessment_result.dart';
import 'collections/cbt_entry.dart';
import 'collections/habit_definition.dart';
import 'collections/habit_tick.dart';
import 'collections/journal_entry.dart';
import 'collections/mood_entry.dart';
import 'collections/recovery_goal.dart';
import 'collections/tracker_event.dart';

/// Owns the single [Isar] instance for the whole app.
///
/// Isar must be opened (native lib loaded + schemas registered) BEFORE any
/// repository/provider reads from it, so [open] is awaited during app startup
/// alongside `SharedPreferences.getInstance()` — see `main.dart`.
class IsarService {
  IsarService._(this.isar);

  final Isar isar;

  /// Opens Isar in the app documents directory. Registering every collection
  /// schema here is the one place the full schema list lives; add new
  /// collections to this list as later phases introduce them.
  static Future<IsarService> open() async {
    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(
      [
        TrackerEventSchema,
        RecoveryGoalSchema,
        AssessmentResultSchema,
        JournalEntrySchema,
        HabitDefinitionSchema,
        HabitTickSchema,
        MoodEntrySchema,
        CbtEntrySchema,
      ],
      directory: dir.path,
      // A stable name keeps the DB file predictable for export/import later.
      name: 'momentum',
    );
    return IsarService._(isar);
  }
}
