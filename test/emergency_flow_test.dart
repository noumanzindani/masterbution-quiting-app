import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/services/emergency_flow.dart';

void main() {
  group('EmergencyFlow.shouldEscalate', () {
    test('a 10/10 urge escalates', () {
      expect(EmergencyFlow.shouldEscalate(10), isTrue);
    });

    test('a 9/10 urge escalates (the >9 boundary is inclusive of 9)', () {
      expect(EmergencyFlow.shouldEscalate(9), isTrue);
    });

    test('an 8/10 urge does not escalate', () {
      expect(EmergencyFlow.shouldEscalate(8), isFalse);
    });

    test('a mild urge does not escalate', () {
      expect(EmergencyFlow.shouldEscalate(3), isFalse);
    });
  });

  group('EmergencyFlow.steps', () {
    test('is a non-empty, ordered sequence', () {
      expect(EmergencyFlow.steps, isNotEmpty);
    });

    test('opens by settling the body and ends with a calm close', () {
      expect(EmergencyFlow.steps.first, EmergencyStep.breathe);
      expect(EmergencyFlow.steps.last, EmergencyStep.close);
    });

    test('walks through the core in-the-moment tools before closing', () {
      // Grounding and urge-surfing must both appear between breathe and close.
      expect(EmergencyFlow.steps.contains(EmergencyStep.ground), isTrue);
      expect(EmergencyFlow.steps.contains(EmergencyStep.surf), isTrue);
    });

    test('has no duplicate steps', () {
      expect(EmergencyFlow.steps.toSet().length, EmergencyFlow.steps.length);
    });
  });
}
