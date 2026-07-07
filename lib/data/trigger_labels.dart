import 'enums.dart';

/// Human labels for [TriggerType] (English; localized in Phase 7).
String triggerLabel(TriggerType t) {
  switch (t) {
    case TriggerType.time:
      return 'Late night';
    case TriggerType.location:
      return 'Being alone';
    case TriggerType.emotion:
      return 'Strong emotion';
    case TriggerType.device:
      return 'Phone in bed';
    case TriggerType.website:
      return 'A website';
    case TriggerType.stress:
      return 'Stress';
    case TriggerType.boredom:
      return 'Boredom';
    case TriggerType.loneliness:
      return 'Loneliness';
    case TriggerType.anger:
      return 'Anger';
    case TriggerType.rejection:
      return 'Rejection';
    case TriggerType.alcohol:
      return 'Alcohol';
    case TriggerType.socialMedia:
      return 'Social media';
  }
}

/// The subset of triggers most useful to surface in the quick log sheet, in a
/// sensible order. (The full taxonomy still exists for analytics.)
const List<TriggerType> quickTriggers = [
  TriggerType.stress,
  TriggerType.boredom,
  TriggerType.loneliness,
  TriggerType.anger,
  TriggerType.time,
  TriggerType.device,
  TriggerType.socialMedia,
  TriggerType.website,
  TriggerType.alcohol,
  TriggerType.rejection,
];
