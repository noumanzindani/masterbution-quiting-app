// Phase 0 smoke test placeholder. Real widget/unit tests (streak math,
// analytics GROUP-BY, AdService guardrail, onboarding flow) arrive with the
// TDD work in Phase 1.
import 'package:flutter_test/flutter_test.dart';

import 'package:momentum/data/enums.dart';

void main() {
  test('Outcome enum keeps lapse-tolerance value order stable', () {
    // Guard against accidental reordering: Isar persists @enumerated by index,
    // so this order is part of the on-disk contract.
    expect(Outcome.values.indexOf(Outcome.resisted), 0);
    expect(Outcome.values.indexOf(Outcome.lapse), 3);
  });
}
