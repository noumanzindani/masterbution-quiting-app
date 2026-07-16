import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/services/reflection_composer.dart';

void main() {
  test('composes labelled lines from the collected vars', () {
    final text = ReflectionComposer.compose({
      'feeling': 'Guilty or ashamed',
      'need': 'a break',
    });
    expect(text, 'Feeling: Guilty or ashamed\nWhat I hoped it would give me: a break');
  });

  test('skips empty answers so a mostly-skipped check-in still reads cleanly', () {
    final text = ReflectionComposer.compose({
      'feeling': 'Numb',
      'need': '   ',
      'plan': 'Move my body',
    });
    expect(text, "Feeling: Numb\nNext time I'll try: Move my body");
  });

  test('renders a trigger enum name as its human label', () {
    // The flow emits TriggerType names so plans can match logged urges — the
    // journal must not inherit that machine vocabulary.
    final text = ReflectionComposer.compose({'trigger': 'socialMedia'});
    expect(text, 'Trigger: Social media');
  });

  test('an unknown trigger value passes through verbatim rather than vanishing', () {
    final text = ReflectionComposer.compose({'trigger': 'stres'});
    expect(text, 'Trigger: stres');
  });

  test('an unknown key falls back to the raw key', () {
    final text = ReflectionComposer.compose({'custom': 'value'});
    expect(text, 'custom: value');
  });

  test('no vars → empty string', () {
    expect(ReflectionComposer.compose(const {}), isEmpty);
  });
}
