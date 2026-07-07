import 'dart:convert';

import '../config.dart';
import '../data/enums.dart';
import '../data/repositories/assessment_repo.dart';
import '../data/repositories/recovery_goal_repo.dart';
import '../services/assessment_engine.dart';

/// Drives the onboarding flow: collects questionnaire answers, runs the pure
/// [AssessmentEngine], lets the user confirm/override the recommended goal, and
/// on [finish] persists the assessment + active goal and flips the onboarded
/// flag. All state lives here so the screens stay declarative.
class OnboardingProvider extends ChangeNotifier {
  // --- Raw answers (mutated by the questionnaire screens) ---
  List<int> adhd = [0, 0, 0];
  List<int> anxiety = [0, 0];
  List<int> depression = [0, 0];
  int sleep = 0;
  int stress = 0;
  int frequency = 0;
  BehaviorTarget focus = BehaviorTarget.porn;
  bool wantsToQuit = true;

  // --- Derived / chosen ---
  AssessmentScores? scores;
  GoalType chosenGoal = GoalType.quitPorn;
  int chosenTargetDays = 30;

  void setScaleItem(List<int> list, int index, int value) {
    list[index] = value;
    notifyListeners();
  }

  void setSleep(int v) => _set(() => sleep = v);
  void setStress(int v) => _set(() => stress = v);
  void setFrequency(int v) => _set(() => frequency = v);
  void setFocus(BehaviorTarget v) => _set(() => focus = v);
  void setWantsToQuit(bool v) => _set(() => wantsToQuit = v);
  void setChosenGoal(GoalType v) => _set(() => chosenGoal = v);
  void setChosenTargetDays(int v) => _set(() => chosenTargetDays = v);

  AssessmentAnswers get _answers => AssessmentAnswers(
        adhd: adhd,
        anxiety: anxiety,
        depression: depression,
        sleep: sleep,
        stress: stress,
        frequency: frequency,
        focus: focus,
        wantsToQuit: wantsToQuit,
      );

  /// Run scoring and seed the goal picker with the recommendation. Call when
  /// entering the results step.
  AssessmentScores computeScores() {
    final s = AssessmentEngine.score(_answers);
    scores = s;
    chosenGoal = s.suggestedGoal;
    chosenTargetDays = s.suggestedTargetDays;
    notifyListeners();
    return s;
  }

  /// Persist the assessment + active goal, then mark onboarding complete.
  /// Returns once storage is durable so the caller can safely navigate home.
  Future<void> finish() async {
    final now = DateTime.now();
    final s = scores ?? computeScores();

    // 1) Store the screening snapshot (history, never overwritten).
    final result = AssessmentRepo.fromScores(
      s,
      rawAnswersJson: _encodeAnswers(),
      at: now,
    );
    await assessmentRepo.save(result);

    // 2) Store the active recovery goal with its milestone ladder.
    final goal = RecoveryGoalRepo.build(
      type: chosenGoal,
      target: _targetForGoal(chosenGoal, focus),
      targetDays: chosenTargetDays,
      startDate: now,
    );
    final goalId = await goalRepo.saveActive(goal);

    // 3) Flip the scalar flags SharedPreferences owns.
    await prefs.setInt(session.activeGoalId, goalId);
    await prefs.setString(session.lastAssessmentDate, now.toIso8601String());
    await prefs.setBool(session.isOnboarded, true);
  }

  void _set(void Function() change) {
    change();
    notifyListeners();
  }

  /// Which behavior the goal tracks, kept coherent with the chosen goal type.
  static BehaviorTarget _targetForGoal(GoalType goal, BehaviorTarget focus) {
    switch (goal) {
      case GoalType.quitPorn:
        return BehaviorTarget.porn;
      case GoalType.quitMasturbation:
        return BehaviorTarget.masturbation;
      case GoalType.reduceFrequency:
      case GoalType.healthyHabits:
        return focus;
    }
  }

  String _encodeAnswers() => jsonEncode({
        'adhd': adhd,
        'anxiety': anxiety,
        'depression': depression,
        'sleep': sleep,
        'stress': stress,
        'frequency': frequency,
        'focus': focus.name,
        'wantsToQuit': wantsToQuit,
      });
}
