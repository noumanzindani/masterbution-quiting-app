import '../data/trigger_labels.dart';
import 'coping_plan_engine.dart';

/// Turns a coach flow's collected variables into the readable, labelled body of
/// a saved reflection.
///
/// Pure, so the copy a user actually reads back months later is unit-tested
/// rather than buried in a widget's private method.
class ReflectionComposer {
  const ReflectionComposer._();

  /// Human labels for the collected variables, so a saved reflection reads
  /// naturally instead of as raw keys.
  static const _labels = {
    'feeling': 'Feeling',
    'trigger': 'Trigger',
    'need': 'What I hoped it would give me',
    'plan': "Next time I'll try",
    'mood': 'Today felt',
    'win': 'Something that went okay',
    'hard': 'What felt hard',
    'intention': "Tomorrow's intention",
  };

  /// Empty answers are skipped so a mostly-skipped daily check-in still reads
  /// cleanly. The `trigger` var holds a [TriggerType] *name* (the flow emits
  /// enum names so plans can be matched to logged urges) — it's rendered as its
  /// human label, falling back to the raw value if it doesn't parse.
  static String compose(Map<String, String> vars) {
    final lines = <String>[];
    for (final entry in vars.entries) {
      var value = entry.value.trim();
      if (value.isEmpty) continue;
      if (entry.key == 'trigger') {
        final trigger = CopingPlanEngine.parseTrigger(value);
        if (trigger != null) value = triggerLabel(trigger);
      }
      lines.add('${_labels[entry.key] ?? entry.key}: $value');
    }
    return lines.join('\n');
  }
}
