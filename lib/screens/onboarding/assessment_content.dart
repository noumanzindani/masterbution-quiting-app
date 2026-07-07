import '../../data/enums.dart';

/// A single Likert-style screening item: a prompt plus ordered response labels
/// (index 0 = lowest severity). This is authored content, kept out of the UI so
/// Phase 7 can move it into the localized content packs without touching
/// screens. The scoring maxima in [AssessmentEngine] assume these lengths.
class ScaleQuestion {
  const ScaleQuestion(this.prompt, this.options);
  final String prompt;
  final List<String> options;
}

/// 0–4 frequency band shared by the ASRS-style and single-item screens.
const List<String> _freq5 = [
  'Never',
  'Rarely',
  'Sometimes',
  'Often',
  'Very often',
];

/// 0–3 PHQ/GAD "over the last two weeks" band.
const List<String> _twoWeek4 = [
  'Not at all',
  'Several days',
  'More than half the days',
  'Nearly every day',
];

/// ADHD (ASRS-style) — 3 items, each 0–4 → matches [AssessmentEngine._adhdMax].
const List<ScaleQuestion> adhdQuestions = [
  ScaleQuestion(
    'How often do you have trouble finishing the final details of a task once the hard parts are done?',
    _freq5,
  ),
  ScaleQuestion(
    'How often is it hard to keep your attention on boring or repetitive work?',
    _freq5,
  ),
  ScaleQuestion(
    'How often do you act on impulse or find it hard to resist a strong urge?',
    _freq5,
  ),
];

/// Anxiety (GAD-2) — 2 items, each 0–3.
const List<ScaleQuestion> anxietyQuestions = [
  ScaleQuestion('Feeling nervous, anxious, or on edge?', _twoWeek4),
  ScaleQuestion('Not being able to stop or control worrying?', _twoWeek4),
];

/// Depression (PHQ-2) — 2 items, each 0–3.
const List<ScaleQuestion> depressionQuestions = [
  ScaleQuestion('Little interest or pleasure in doing things?', _twoWeek4),
  ScaleQuestion('Feeling down, depressed, or hopeless?', _twoWeek4),
];

const ScaleQuestion sleepQuestion = ScaleQuestion(
  'How often is your sleep poor or unrefreshing?',
  _freq5,
);

const ScaleQuestion stressQuestion = ScaleQuestion(
  'How often do you feel overwhelmed by stress?',
  _freq5,
);

/// Behavioral frequency — 0–5 (six options) → [AssessmentEngine._frequencyMax].
const ScaleQuestion frequencyQuestion = ScaleQuestion(
  'How often do you currently do the thing you want to change?',
  [
    'Rarely',
    'About monthly',
    'About weekly',
    'A few times a week',
    'Daily',
    'Several times a day',
  ],
);

/// The behavior-focus options offered at onboarding.
const List<({BehaviorTarget target, String label})> focusOptions = [
  (target: BehaviorTarget.porn, label: 'Porn'),
  (target: BehaviorTarget.masturbation, label: 'Masturbation'),
  (target: BehaviorTarget.both, label: 'Both'),
];

/// Human labels for the four goal types (English; localized in Phase 7).
String goalLabel(GoalType t) {
  switch (t) {
    case GoalType.quitPorn:
      return 'Quit porn';
    case GoalType.quitMasturbation:
      return 'Quit masturbation';
    case GoalType.reduceFrequency:
      return 'Cut down / reduce';
    case GoalType.healthyHabits:
      return 'Build healthier habits';
  }
}

/// Selectable goal lengths (days) with friendly labels.
const List<({int days, String label})> goalDurations = [
  (days: 7, label: '7 days'),
  (days: 30, label: '30 days'),
  (days: 90, label: '90 days'),
  (days: 180, label: '180 days'),
];
