/// Central barrel hub (EzHand convention). Import this one file in any
/// screen/provider to get Flutter, common packages, theme, routes, and the
/// global singletons + context helpers below.
library;

import 'common/app_fonts.dart';
import 'common/session.dart';
import 'common/theme/app_css.dart';
import 'common/theme/app_theme.dart';
import 'common/theme/theme_service.dart';
import 'common/languages/language_provider.dart';
import 'content/content_service.dart';
import 'data/isar_service.dart';
import 'data/repositories/assessment_repo.dart';
import 'data/repositories/cbt_repo.dart';
import 'data/repositories/habit_repo.dart';
import 'data/repositories/journal_repo.dart';
import 'data/repositories/mood_repo.dart';
import 'data/repositories/recovery_goal_repo.dart';
import 'data/repositories/tracker_event_repo.dart';
import 'helper/navigation_class.dart';
import 'packages_list.dart';
import 'services/ad_service.dart';

// Re-exports so `import 'config.dart'` is enough for most files.
export 'packages_list.dart';
export 'common/app_fonts.dart';
export 'common/theme/app_css.dart';
export 'common/theme/app_theme.dart';
export 'common/theme/theme_service.dart';
export 'common/languages/language_provider.dart';
export 'common/session.dart';
export 'routes/index.dart';
export 'helper/navigation_class.dart';

// --- Global singletons -------------------------------------------------------

final AppFonts appFonts = AppFonts();
final AppCss appCss = AppCss();
final NavigationClass route = NavigationClass();

/// Root navigator key — lets non-widget code (e.g. the app-lifecycle handler
/// that re-locks the app on resume) drive navigation.
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

/// SharedPreferences handle, assigned once during startup before `runApp`.
late SharedPreferences prefs;
final Session session = Session();

/// The opened Isar database. Assigned once during startup (main.dart) before
/// `runApp`, so repositories can reference it directly (mirrors EzHand's
/// `late SharedPreferences sharedPreferences`).
late IsarService isarService;

// --- Data repositories (assigned in AppInit once Isar is open) ---------------

late TrackerEventRepo trackerRepo;
late RecoveryGoalRepo goalRepo;
late AssessmentRepo assessmentRepo;
late JournalRepo journalRepo;
late HabitRepo habitRepo;
late MoodRepo moodRepo;
late CbtRepo cbtRepo;

/// The single ad gateway. Constructed eagerly (cheap); `init()` runs in
/// [AppInit]. Every ad decision routes through its tested [AdPolicy].
final AdService adService = AdService();

/// Bundled content corpus (articles, quotes, alternatives). Preloaded in
/// [AppInit]; screens read from it synchronously.
final ContentService contentService = ContentService();

// --- Context helpers ---------------------------------------------------------

/// Resolved palette for the current theme + platform brightness.
AppTheme appColor(BuildContext context) =>
    context.watch<ThemeService>().appThemeFor(context);

/// Non-listening variant for use in callbacks/build-once contexts.
AppTheme appColorRead(BuildContext context) =>
    context.read<ThemeService>().appThemeFor(context);

bool isDark(BuildContext context) => appColor(context).isDark;

/// Translate a key via the active language map.
String language(BuildContext context, String key) =>
    context.watch<LanguageProvider>().translate(key);

bool rtl(BuildContext context) => context.watch<LanguageProvider>().isRtl;
