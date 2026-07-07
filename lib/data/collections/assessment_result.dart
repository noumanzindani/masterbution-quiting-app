import 'package:isar_community/isar.dart';

import '../enums.dart';

part 'assessment_result.g.dart';

/// A snapshot of one onboarding (or periodic re-)assessment. Kept as history so
/// the user can see their screening scores change over time — we never
/// overwrite a previous assessment.
///
/// Screening subscores use validated-questionnaire-style scoring computed by a
/// local formula (no AI). They are screening indicators, NOT diagnoses — the UI
/// must always present them with the "not a diagnosis / not a substitute for
/// professional care" disclaimer.
@collection
class AssessmentResult {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime timestampUtc;

  // --- Computed screening subscores (raw scale totals) ---
  late int adhdScore;
  late int anxietyScore; // GAD-style
  late int depressionScore; // PHQ-style
  late int frequencyScore; // porn/masturbation frequency severity
  late int sleepScore;
  late int stressScore;

  /// Composite 0–100 "how hard will recovery likely be" indicator, used to pick
  /// a starting plan intensity. Higher = more support scaffolding.
  late int recoveryDifficultyScore;

  /// The goal the assessment recommends (the user can still override it).
  @enumerated
  late GoalType suggestedGoal;

  /// Id of the rule-based plan template selected from `plans/plan_rules.json`.
  late String planId;

  /// Raw answers, stored as JSON so the exact questionnaire responses are
  /// recoverable without a column per question.
  late String rawAnswersJson;
}
