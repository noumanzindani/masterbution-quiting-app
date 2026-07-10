import 'package:flutter/material.dart';

import '../screens/cbt/cbt_entry_view_screen.dart';
import '../screens/cbt/cbt_hub_screen.dart';
import '../screens/cbt/quiz_screen.dart';
import '../screens/cbt/worksheet_screen.dart';
import '../screens/coach/coach_flow_screen.dart';
import '../screens/coach/coach_hub_screen.dart';
import '../screens/coach/daily_planner_screen.dart';
import '../screens/emergency/breathing_screen.dart';
import '../screens/emergency/crisis_resources_screen.dart';
import '../screens/emergency/emergency_journal_screen.dart';
import '../screens/emergency/grounding_screen.dart';
import '../screens/emergency/emergency_mode_screen.dart';
import '../screens/emergency/panic_screen.dart';
import '../screens/emergency/urge_surf_screen.dart';
import '../screens/habits/habits_screen.dart';
import '../screens/insights/insights_screen.dart';
import '../screens/learn/academy_screen.dart';
import '../screens/learn/alternatives_screen.dart';
import '../screens/learn/article_screen.dart';
import '../screens/learn/learn_hub_screen.dart';
import '../screens/learn/motivation_screen.dart';
import '../screens/learn/program_day_screen.dart';
import '../screens/learn/program_screen.dart';
import '../screens/learn/session_player_screen.dart';
import '../screens/learn/sessions_screen.dart';
import '../screens/learn/values_screen.dart';
import '../screens/lock/lock_screen.dart';
import '../screens/mood/mood_journal_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/rewards/rewards_screen.dart';
import '../screens/settings/backup_screen.dart';
import '../screens/social/accountability_screen.dart';
import '../screens/social/professional_notes_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/shell/main_shell_screen.dart';
import '../screens/sleep/sleep_log_screen.dart';
import '../screens/wellbeing/wellbeing_hub_screen.dart';
import '../screens/wellbeing/wellbeing_module_screen.dart';
import '../screens/splash/splash_screen.dart';
import 'route_name.dart';

/// Maps route names → screen builders. Wired into `MaterialApp.routes`.
/// New screens register here (add the name to [RouteName] first).
class AppRoute {
  final RouteName _r = RouteName();

  Map<String, WidgetBuilder> get routes => {
        _r.splash: (_) => const SplashScreen(),
        _r.onboarding: (_) => const OnboardingScreen(),
        _r.home: (_) => const MainShellScreen(),
        // Emergency / crisis — all NO-AD zones (see AdPolicy.noAdRoutes).
        _r.panic: (_) => const PanicScreen(),
        _r.emergencyMode: (_) => const EmergencyModeScreen(),
        _r.breathing: (_) => const BreathingScreen(),
        _r.urgeSurf: (_) => const UrgeSurfScreen(),
        _r.grounding: (_) => const GroundingScreen(),
        _r.emergencyJournal: (_) => const EmergencyJournalScreen(),
        _r.crisisResources: (_) => const CrisisResourcesScreen(),
        // Relapse reflection is a coach flow on a NO-AD route (AdPolicy denylist).
        _r.relapseReflection: (_) => const CoachFlowScreen(),
        _r.lock: (_) => const LockScreen(),
        _r.settings: (_) => const SettingsScreen(),
        _r.insights: (_) => const InsightsScreen(),
        _r.habits: (_) => const HabitsScreen(),
        _r.moodJournal: (_) => const MoodJournalScreen(),
        // Learn / content
        _r.learn: (_) => const LearnHubScreen(),
        _r.academy: (_) => const AcademyScreen(),
        _r.article: (_) => const ArticleScreen(),
        _r.motivation: (_) => const MotivationScreen(),
        _r.alternatives: (_) => const AlternativesScreen(),
        _r.cbt: (_) => const CbtHubScreen(),
        _r.worksheet: (_) => const WorksheetScreen(),
        _r.cbtEntry: (_) => const CbtEntryViewScreen(),
        _r.quiz: (_) => const QuizScreen(),
        _r.sessions: (_) => const SessionsScreen(),
        _r.sessionPlayer: (_) => const SessionPlayerScreen(),
        _r.program: (_) => const ProgramScreen(),
        _r.programDay: (_) => const ProgramDayScreen(),
        _r.values: (_) => const ValuesScreen(),
        // Coach & check-ins
        _r.coachHub: (_) => const CoachHubScreen(),
        _r.coach: (_) => const CoachFlowScreen(),
        _r.dailyPlanner: (_) => const DailyPlannerScreen(),
        _r.rewards: (_) => const RewardsScreen(),
        _r.wellbeing: (_) => const WellbeingHubScreen(),
        _r.wellbeingModule: (_) => const WellbeingModuleScreen(),
        _r.sleepLog: (_) => const SleepLogScreen(),
        _r.backup: (_) => const BackupScreen(),
        _r.accountability: (_) => const AccountabilityScreen(),
        _r.professionalNotes: (_) => const ProfessionalNotesScreen(),
      };
}
