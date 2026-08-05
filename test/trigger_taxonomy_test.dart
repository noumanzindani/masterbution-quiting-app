import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/data/enums.dart';
import 'package:momentum/data/trigger_labels.dart';

/// The trigger taxonomy is a persistence contract: Isar stores TriggerType by
/// index, and the urge sheet can only offer what `quickTriggers` lists. These
/// tests pin both halves.
void main() {
  test('every TriggerType has a non-empty label', () {
    for (final t in TriggerType.values) {
      expect(triggerLabel(t), isNotEmpty, reason: '$t has no label');
    }
  });

  test('existing TriggerType indices are unchanged', () {
    // Isar persists @enumerated by index — inserting a value before any of
    // these silently rewrites the meaning of every stored TrackerEvent.
    expect(TriggerType.time.index, 0);
    expect(TriggerType.stress.index, 5);
    expect(TriggerType.boredom.index, 6);
    expect(TriggerType.loneliness.index, 7);
    expect(TriggerType.socialMedia.index, 11);
  });

  test('tiredness is appended after the original twelve', () {
    expect(TriggerType.tiredness.index, 12);
  });

  test('tiredness is taggable in the quick log sheet', () {
    // A trigger the sheet can't offer can never match a coping plan.
    expect(quickTriggers, contains(TriggerType.tiredness));
  });

  test('quickTriggers has no duplicates', () {
    expect(quickTriggers.toSet().length, quickTriggers.length);
  });
}
