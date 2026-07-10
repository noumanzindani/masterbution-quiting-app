/// Localization KEY holder (the name mirrors EzHand's confusingly-named class:
/// it holds string keys for UI text, not font config).
///
/// Screens reference `language(context, appFonts.someKey)`; the key resolves to
/// a translated string via the active language map. Add keys here as screens
/// need them; add the matching entries to every `languages/<locale>.dart` map.
class AppFonts {
  // App-level
  final String appName = 'appName';
  final String continueLabel = 'continueLabel';
  final String back = 'back';
  final String skip = 'skip';
  final String next = 'next';
  final String done = 'done';
  final String save = 'save';
  final String cancel = 'cancel';

  // Onboarding / assessment
  final String welcomeTitle = 'welcomeTitle';
  final String welcomeSubtitle = 'welcomeSubtitle';
  final String getStarted = 'getStarted';
  final String notADiagnosis = 'notADiagnosis';

  // Goals
  final String goalQuitPorn = 'goalQuitPorn';
  final String goalQuitMasturbation = 'goalQuitMasturbation';
  final String goalReduce = 'goalReduce';
  final String goalHealthy = 'goalHealthy';

  // Dashboard
  final String dashboard = 'dashboard';
  final String currentStreak = 'currentStreak';
  final String days = 'days';
  final String logUrge = 'logUrge';
  final String iSlipped = 'iSlipped';

  // Emergency / tools
  final String panic = 'panic';
  final String panicSubtitle = 'panicSubtitle';
  final String breathe = 'breathe';
  final String urgeSurf = 'urgeSurf';
  final String grounding = 'grounding';
  final String callSomeone = 'callSomeone';

  // Crisis / safety
  final String crisisResources = 'crisisResources';
  final String notMedicalCare = 'notMedicalCare';

  // Settings
  final String settings = 'settings';
  final String appLock = 'appLock';
  final String privacy = 'privacy';
  final String theme = 'theme';

  // Bottom-nav tab labels
  final String tabHome = 'tabHome';
  final String tabInsights = 'tabInsights';
  final String tabTools = 'tabTools';
  final String tabLearn = 'tabLearn';
  final String tabYou = 'tabYou';
}
