import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/content/coach_models.dart';
import 'package:momentum/services/coach_runner.dart';

/// A tiny four-node flow exercising every node type:
/// message → choice (with effect) → input → end.
CoachFlow _sampleFlow() => CoachFlow.fromJson({
      'id': 'sample',
      'title': 'Sample',
      'entry': 'n1',
      'nodes': [
        {'id': 'n1', 'type': 'message', 'text': 'Hi there.', 'next': 'n2'},
        {
          'id': 'n2',
          'type': 'choice',
          'text': 'What was going on?',
          'choices': [
            {'label': 'I was bored', 'next': 'n3', 'effect': {'trigger': 'boredom'}},
            {'label': 'I felt stressed', 'next': 'n3', 'effect': {'trigger': 'stress'}},
          ],
        },
        {'id': 'n3', 'type': 'input', 'text': 'Say one kind thing.', 'key': 'note', 'next': 'n4'},
        {'id': 'n4', 'type': 'end', 'text': 'You showed up.'},
      ],
    });

void main() {
  group('CoachFlow parsing', () {
    test('parses nodes, choices and effects from JSON', () {
      final flow = _sampleFlow();
      expect(flow.id, 'sample');
      expect(flow.entry, 'n1');
      expect(flow.nodes.length, 4);

      final choice = flow.nodeById('n2')!;
      expect(choice.type, 'choice');
      expect(choice.choices.length, 2);
      expect(choice.choices.first.label, 'I was bored');
      expect(choice.choices.first.effect['trigger'], 'boredom');

      final input = flow.nodeById('n3')!;
      expect(input.key, 'note');
    });

    test('unknown node id returns null', () {
      expect(_sampleFlow().nodeById('nope'), isNull);
    });

    test('a malformed node degrades to sensible defaults', () {
      final flow = CoachFlow.fromJson({
        'id': 'x',
        'entry': 'a',
        'nodes': [
          {'id': 'a'}, // no type, text, next
        ],
      });
      final node = flow.nodeById('a')!;
      expect(node.type, 'message');
      expect(node.text, '');
      expect(node.next, isNull);
      expect(node.choices, isEmpty);
    });
  });

  group('CoachRunner.start', () {
    test('begins at the entry node with empty vars, not done', () {
      final s = CoachRunner.start(_sampleFlow());
      expect(s.nodeId, 'n1');
      expect(s.vars, isEmpty);
      expect(s.done, isFalse);
    });

    test('current() resolves the state to its node', () {
      final flow = _sampleFlow();
      final s = CoachRunner.start(flow);
      expect(CoachRunner.current(flow, s).text, 'Hi there.');
    });
  });

  group('CoachRunner.proceed (message/action nodes)', () {
    test('moves a message node to its next', () {
      final flow = _sampleFlow();
      final s = CoachRunner.proceed(flow, CoachRunner.start(flow));
      expect(s.nodeId, 'n2');
      expect(s.done, isFalse);
    });
  });

  group('CoachRunner.choose', () {
    test('applies the chosen effect and advances to its next', () {
      final flow = _sampleFlow();
      var s = CoachRunner.proceed(flow, CoachRunner.start(flow)); // at n2
      s = CoachRunner.choose(flow, s, 1); // "I felt stressed"
      expect(s.nodeId, 'n3');
      expect(s.vars['trigger'], 'stress');
    });

    test('out-of-range choice index leaves the state unchanged', () {
      final flow = _sampleFlow();
      final atChoice = CoachRunner.proceed(flow, CoachRunner.start(flow));
      final s = CoachRunner.choose(flow, atChoice, 9);
      expect(s.nodeId, atChoice.nodeId);
      expect(s.vars, isEmpty);
    });
  });

  group('CoachRunner.submit (input nodes)', () {
    test('stores the text under the node key and advances', () {
      final flow = _sampleFlow();
      var s = CoachRunner.proceed(flow, CoachRunner.start(flow)); // n2
      s = CoachRunner.choose(flow, s, 0); // n3
      s = CoachRunner.submit(flow, s, 'Be kind to yourself.');
      expect(s.vars['note'], 'Be kind to yourself.');
      expect(s.nodeId, 'n4');
    });
  });

  group('reaching the end', () {
    test('an end node marks the state done', () {
      final flow = _sampleFlow();
      var s = CoachRunner.proceed(flow, CoachRunner.start(flow)); // n2
      s = CoachRunner.choose(flow, s, 0); // n3
      s = CoachRunner.submit(flow, s, 'ok'); // n4 (end)
      expect(CoachRunner.current(flow, s).type, 'end');
      expect(s.done, isTrue);
    });

    test('a message node with no next is also terminal', () {
      final flow = CoachFlow.fromJson({
        'id': 'z',
        'entry': 'only',
        'nodes': [
          {'id': 'only', 'type': 'message', 'text': 'The end.'},
        ],
      });
      final s = CoachRunner.proceed(flow, CoachRunner.start(flow));
      expect(s.done, isTrue);
    });
  });
}
