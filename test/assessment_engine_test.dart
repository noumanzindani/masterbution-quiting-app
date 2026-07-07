import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/data/enums.dart';
import 'package:momentum/services/assessment_engine.dart';

/// A neutral baseline answer set (everything at its lowest severity) that
/// individual tests mutate via copyWith.
AssessmentAnswers _base() => const AssessmentAnswers(
      adhd: [0, 0, 0],
      anxiety: [0, 0],
      depression: [0, 0],
      sleep: 0,
      stress: 0,
      frequency: 0,
      focus: BehaviorTarget.porn,
      wantsToQuit: true,
    );

void main() {
  group('subscore totals', () {
    test('sum each questionnaire group into its raw total', () {
      final scores = AssessmentEngine.score(
        _base().copyWith(
          adhd: const [4, 3, 2],
          anxiety: const [3, 3],
          depression: const [2, 1],
          sleep: 3,
          stress: 4,
          frequency: 5,
        ),
      );
      expect(scores.adhdScore, 9);
      expect(scores.anxietyScore, 6);
      expect(scores.depressionScore, 3);
      expect(scores.sleepScore, 3);
      expect(scores.stressScore, 4);
      expect(scores.frequencyScore, 5);
    });
  });

  group('recovery-difficulty composite', () {
    test('all-lowest answers give difficulty 0 and the gentlest plan', () {
      final s = AssessmentEngine.score(_base());
      expect(s.recoveryDifficultyScore, 0);
      expect(s.planId, 'gentle-start');
    });

    test('all-highest answers give difficulty 100 and intensive support', () {
      final s = AssessmentEngine.score(
        _base().copyWith(
          adhd: const [4, 4, 4],
          anxiety: const [3, 3],
          depression: const [3, 3],
          sleep: 4,
          stress: 4,
          frequency: 5,
        ),
      );
      expect(s.recoveryDifficultyScore, 100);
      expect(s.planId, 'intensive-support');
      // When recovery looks hard, start with a short, winnable first goal.
      expect(s.suggestedTargetDays, 7);
    });

    test('difficulty always lands within 0..100', () {
      final s = AssessmentEngine.score(
        _base().copyWith(anxiety: const [3, 3], frequency: 4),
      );
      expect(s.recoveryDifficultyScore, inInclusiveRange(0, 100));
    });
  });

  group('suggested goal', () {
    test('quitting + masturbation focus suggests quitMasturbation', () {
      final s = AssessmentEngine.score(
        _base().copyWith(focus: BehaviorTarget.masturbation, wantsToQuit: true),
      );
      expect(s.suggestedGoal, GoalType.quitMasturbation);
    });

    test('quitting + porn focus suggests quitPorn', () {
      final s = AssessmentEngine.score(_base().copyWith(wantsToQuit: true));
      expect(s.suggestedGoal, GoalType.quitPorn);
    });

    test('not quitting, low frequency and low load suggests healthy habits', () {
      final s = AssessmentEngine.score(
        _base().copyWith(wantsToQuit: false, frequency: 0),
      );
      expect(s.suggestedGoal, GoalType.healthyHabits);
    });

    test('not quitting but engaging often suggests reducing', () {
      final s = AssessmentEngine.score(
        _base().copyWith(wantsToQuit: false, frequency: 4),
      );
      expect(s.suggestedGoal, GoalType.reduceFrequency);
    });
  });
}
