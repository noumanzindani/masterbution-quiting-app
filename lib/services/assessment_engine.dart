import 'dart:math' as math;

import '../data/enums.dart';

/// Immutable answer set collected during onboarding. Each list holds the raw
/// Likert responses for a short screener; the single ints are one-item scales.
///
/// Response scales (higher = more severe / more frequent):
///  * [adhd]        — ASRS-style items, each 0–4  (3 items → 0–12)
///  * [anxiety]     — GAD-2 items, each 0–3       (2 items → 0–6)
///  * [depression]  — PHQ-2 items, each 0–3       (2 items → 0–6)
///  * [sleep]       — sleep-difficulty, 0–4
///  * [stress]      — perceived stress, 0–4
///  * [frequency]   — how often the behavior occurs, 0–5
///  * [focus]       — which behavior the user wants to work on
///  * [wantsToQuit] — quit outright (true) vs cut down (false)
class AssessmentAnswers {
  const AssessmentAnswers({
    required this.adhd,
    required this.anxiety,
    required this.depression,
    required this.sleep,
    required this.stress,
    required this.frequency,
    required this.focus,
    required this.wantsToQuit,
  });

  final List<int> adhd;
  final List<int> anxiety;
  final List<int> depression;
  final int sleep;
  final int stress;
  final int frequency;
  final BehaviorTarget focus;
  final bool wantsToQuit;

  AssessmentAnswers copyWith({
    List<int>? adhd,
    List<int>? anxiety,
    List<int>? depression,
    int? sleep,
    int? stress,
    int? frequency,
    BehaviorTarget? focus,
    bool? wantsToQuit,
  }) {
    return AssessmentAnswers(
      adhd: adhd ?? this.adhd,
      anxiety: anxiety ?? this.anxiety,
      depression: depression ?? this.depression,
      sleep: sleep ?? this.sleep,
      stress: stress ?? this.stress,
      frequency: frequency ?? this.frequency,
      focus: focus ?? this.focus,
      wantsToQuit: wantsToQuit ?? this.wantsToQuit,
    );
  }
}

/// Computed output of a scoring pass. Subscores are raw scale totals (shown to
/// the user as screening indicators with a "not a diagnosis" disclaimer); the
/// composite and recommendations drive plan selection.
class AssessmentScores {
  const AssessmentScores({
    required this.adhdScore,
    required this.anxietyScore,
    required this.depressionScore,
    required this.frequencyScore,
    required this.sleepScore,
    required this.stressScore,
    required this.recoveryDifficultyScore,
    required this.suggestedGoal,
    required this.planId,
    required this.suggestedTargetDays,
  });

  final int adhdScore;
  final int anxietyScore;
  final int depressionScore;
  final int frequencyScore;
  final int sleepScore;
  final int stressScore;

  /// 0–100 composite: how much support scaffolding to start with.
  final int recoveryDifficultyScore;

  final GoalType suggestedGoal;
  final String planId;
  final int suggestedTargetDays;
}

/// Pure, on-device screening + plan selection. No AI, no network — just the
/// weighted sums the paper questionnaires already are, plus a composite whose
/// weights encode clinical priorities (tune [_weights] to change how forgiving
/// or cautious the starting plan is).
class AssessmentEngine {
  // Max possible raw total for each subscore, used to normalize to 0..1 before
  // weighting. Kept beside the engine so questionnaire length changes here.
  static const int _adhdMax = 12; // 3 items × 4
  static const int _anxietyMax = 6; // 2 items × 3
  static const int _depressionMax = 6; // 2 items × 3
  static const int _sleepMax = 4;
  static const int _stressMax = 4;
  static const int _frequencyMax = 5;

  /// Composite weights (sum to 1.0). Frequency dominates because behavioral
  /// entrenchment is the strongest predictor of relapse difficulty; mood and
  /// impulsivity load follow. THIS is the clinical dial to retune.
  static const Map<String, double> _weights = {
    'frequency': 0.30,
    'anxiety': 0.15,
    'depression': 0.15,
    'adhd': 0.15,
    'stress': 0.15,
    'sleep': 0.10,
  };

  static AssessmentScores score(AssessmentAnswers a) {
    final adhd = _sum(a.adhd);
    final anxiety = _sum(a.anxiety);
    final depression = _sum(a.depression);

    // Normalize each subscore to 0..1, then weight into a 0..100 composite.
    final composite = _weights['frequency']! * (a.frequency / _frequencyMax) +
        _weights['anxiety']! * (anxiety / _anxietyMax) +
        _weights['depression']! * (depression / _depressionMax) +
        _weights['adhd']! * (adhd / _adhdMax) +
        _weights['stress']! * (a.stress / _stressMax) +
        _weights['sleep']! * (a.sleep / _sleepMax);
    final difficulty = (composite * 100).round().clamp(0, 100);

    final planId = _planFor(difficulty);

    return AssessmentScores(
      adhdScore: adhd,
      anxietyScore: anxiety,
      depressionScore: depression,
      frequencyScore: a.frequency,
      sleepScore: a.sleep,
      stressScore: a.stress,
      recoveryDifficultyScore: difficulty,
      suggestedGoal: _goalFor(a),
      planId: planId,
      suggestedTargetDays: _targetDaysFor(planId),
    );
  }

  static int _sum(List<int> xs) => xs.fold(0, (t, x) => t + x);

  static String _planFor(int difficulty) {
    if (difficulty > 66) return 'intensive-support';
    if (difficulty >= 34) return 'steady';
    return 'gentle-start';
  }

  /// Higher difficulty → a shorter, more winnable first goal (build early wins
  /// rather than set up for an overwhelming target).
  static int _targetDaysFor(String planId) =>
      planId == 'intensive-support' ? 7 : 30;

  static GoalType _goalFor(AssessmentAnswers a) {
    if (a.wantsToQuit) {
      return a.focus == BehaviorTarget.masturbation
          ? GoalType.quitMasturbation
          : GoalType.quitPorn;
    }
    // Not quitting: distinguish "already light, just build habits" from
    // "engaging often, aim to cut down".
    return a.frequency <= 1 ? GoalType.healthyHabits : GoalType.reduceFrequency;
  }

  /// The behavior target a goal should carry, derived from the user's focus.
  static BehaviorTarget targetForFocus(BehaviorTarget focus) => focus;

  /// Small helper for callers that want a bounded 0–10 display band from a
  /// 0–100 difficulty (kept here so UI never re-derives the scale).
  static int difficultyBand10(int difficulty) =>
      math.min(10, (difficulty / 10).round());
}
