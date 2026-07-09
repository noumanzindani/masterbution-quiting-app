/// Named-route string constants. Screens navigate via
/// `Navigator.pushNamed(context, routeName.x)` or the `route` helper.
///
/// The names in [AdService]'s no-ad denylist MUST match these exactly, so keep
/// this the single source of truth for route strings.
class RouteName {
  final String splash = '/';
  final String onboarding = 'onboarding';
  final String home = 'home';
  final String lock = 'lock';

  // No-ad zones (crisis / urge). Keep in sync with AdService denylist.
  final String panic = 'panic';
  final String urgeSurf = 'urgeSurf';
  final String breathing = 'breathing';
  final String grounding = 'grounding';
  final String emergencyJournal = 'emergencyJournal';
  final String emergencyMode = 'emergencyMode';
  final String crisisResources = 'crisisResources';
  final String relapseReflection = 'relapseReflection';

  // Logging
  final String logUrge = 'logUrge';

  final String insights = 'insights';
  final String habits = 'habits';
  final String moodJournal = 'moodJournal';

  // Learn / content
  final String learn = 'learn';
  final String academy = 'academy';
  final String article = 'article';
  final String motivation = 'motivation';
  final String alternatives = 'alternatives';
  final String cbt = 'cbt';
  final String worksheet = 'worksheet';
  final String cbtEntry = 'cbtEntry';
  final String quiz = 'quiz';
  final String sessions = 'sessions';
  final String sessionPlayer = 'sessionPlayer';
  final String program = 'program';
  final String programDay = 'programDay';
  final String values = 'values';

  // Coach & check-ins
  final String coachHub = 'coachHub';
  final String coach = 'coach'; // generic CoachFlowScreen (non-crisis flows)
  final String dailyPlanner = 'dailyPlanner';

  // Rewards / gamification
  final String rewards = 'rewards';

  final String settings = 'settings';
}
