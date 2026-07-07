import 'package:isar_community/isar.dart';

import '../../services/assessment_engine.dart';
import '../collections/assessment_result.dart';

/// Stores onboarding (and future periodic re-)assessments. Append-only: each
/// assessment is kept as history so the user can watch their screening scores
/// move over time — we never overwrite a prior result.
class AssessmentRepo {
  AssessmentRepo(this._isar);

  final Isar _isar;

  IsarCollection<AssessmentResult> get _results => _isar.assessmentResults;

  Future<int> save(AssessmentResult result) =>
      _isar.writeTxn(() => _results.put(result));

  Future<AssessmentResult?> latest() =>
      _results.where().sortByTimestampUtcDesc().findFirst();

  /// Map a pure [AssessmentScores] result plus the raw answer JSON into the
  /// persisted row.
  static AssessmentResult fromScores(
    AssessmentScores s, {
    required String rawAnswersJson,
    required DateTime at,
  }) {
    return AssessmentResult()
      ..timestampUtc = at.toUtc()
      ..adhdScore = s.adhdScore
      ..anxietyScore = s.anxietyScore
      ..depressionScore = s.depressionScore
      ..frequencyScore = s.frequencyScore
      ..sleepScore = s.sleepScore
      ..stressScore = s.stressScore
      ..recoveryDifficultyScore = s.recoveryDifficultyScore
      ..suggestedGoal = s.suggestedGoal
      ..planId = s.planId
      ..rawAnswersJson = rawAnswersJson;
  }
}
