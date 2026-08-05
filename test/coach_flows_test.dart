import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/content/coach_models.dart';
import 'package:momentum/services/coach_runner.dart';
import 'package:momentum/services/coping_plan_engine.dart';

/// Validates the *authored* coach flow JSON against the *real* engine. A coach
/// flow is a hand-written decision graph, so the classic bug is a dangling node
/// reference (a `next` that points nowhere) — invisible until a user hits it.
/// These tests catch that at build time, and prove every flow terminates.

CoachFlow _load(String name) {
  final file =
      File('assets/content/coach/flows/$name.json');
  final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  return CoachFlow.fromJson(json);
}

/// Routes an `action: navigate:<route>` node is allowed to open — all are
/// existing calming tools, never a dead end.
const _validNavTargets = {'breathing', 'grounding', 'urgeSurf', 'panic'};

void _validate(CoachFlow flow) {
  final ids = {for (final n in flow.nodes) n.id};

  // Entry exists.
  expect(ids.contains(flow.entry), isTrue,
      reason: 'entry "${flow.entry}" is not a node');

  // Every referenced destination resolves to a real node.
  void checkNext(String? next, String from) {
    if (next != null) {
      expect(ids.contains(next), isTrue,
          reason: 'node "$from" points to missing node "$next"');
    }
  }

  for (final n in flow.nodes) {
    checkNext(n.next, n.id);
    for (final c in n.choices) {
      checkNext(c.next, '${n.id} choice "${c.label}"');
    }
    // A choice node must actually offer choices; others shouldn't.
    if (n.type == 'choice') {
      expect(n.choices, isNotEmpty, reason: '${n.id} is a choice with no options');
    }
    // Action tokens are recognised and (for navigation) target a real tool.
    if (n.type == 'action') {
      final a = n.action ?? '';
      final known = a.startsWith('saveReflection') ||
          a.startsWith('navigate:') ||
          a == 'adjustPlan' ||
          a == 'addTodayIntention';
      expect(known, isTrue, reason: '${n.id} has unknown action "$a"');
      if (a.startsWith('navigate:')) {
        expect(_validNavTargets.contains(a.substring('navigate:'.length)),
            isTrue,
            reason: '${n.id} navigates to unknown route "$a"');
      }
    }
  }

  // No orphans: every node is reachable from the entry.
  final reachable = <String>{};
  final queue = <String>[flow.entry];
  while (queue.isNotEmpty) {
    final id = queue.removeLast();
    if (!reachable.add(id)) continue;
    final node = flow.nodeById(id)!;
    if (node.next != null) queue.add(node.next!);
    for (final c in node.choices) {
      if (c.next != null) queue.add(c.next!);
    }
  }
  expect(reachable, containsAll(ids),
      reason: 'unreachable nodes: ${ids.difference(reachable)}');
}

/// Auto-walks a flow by always taking the first choice / submitting a stub,
/// proving the runner reaches an end within a sane number of steps and visits
/// at least one save action along the way.
({bool ended, bool saved}) _walk(CoachFlow flow) {
  var state = CoachRunner.start(flow);
  var saved = false;
  for (var step = 0; step < 50; step++) {
    final node = CoachRunner.current(flow, state);
    if (node.type == 'action' && (node.action ?? '').startsWith('saveReflection')) {
      saved = true;
    }
    if (state.done || node.type == 'end') {
      return (ended: true, saved: saved);
    }
    switch (node.type) {
      case 'choice':
        state = CoachRunner.choose(flow, state, 0);
      case 'input':
        state = CoachRunner.submit(flow, state, 'stub answer');
      default: // message / action
        state = CoachRunner.proceed(flow, state);
    }
  }
  return (ended: false, saved: saved);
}

void main() {
  final flows = {
    'relapse_reflection': _load('relapse_reflection'),
    'daily_reflection': _load('daily_reflection'),
  };

  group('flow graphs are well-formed', () {
    flows.forEach((name, flow) {
      test('$name has no dangling refs, orphans, or bad actions', () {
        _validate(flow);
      });
    });
  });

  group('flows drive to completion through the real runner', () {
    flows.forEach((name, flow) {
      test('$name terminates and saves a reflection', () {
        final r = _walk(flow);
        expect(r.ended, isTrue, reason: '$name never reached an end node');
        expect(r.saved, isTrue, reason: '$name never saved a reflection');
      });
    });
  });

  test('relapse_reflection collects the expected learning variables', () {
    final flow = flows['relapse_reflection']!;
    // Walk: intro → (feeling) → ... capturing choices/inputs.
    var s = CoachRunner.start(flow);
    // intro (message)
    s = CoachRunner.proceed(flow, s);
    // feeling (choice) — pick "Guilty or ashamed"
    s = CoachRunner.choose(flow, s, 0);
    // reassure (message) — only reached from a non-"okay" feeling
    if (CoachRunner.current(flow, s).type == 'message') {
      s = CoachRunner.proceed(flow, s);
    }
    // trigger (choice)
    expect(CoachRunner.current(flow, s).type, 'choice');
    s = CoachRunner.choose(flow, s, 0); // "I was bored"
    // need (input)
    expect(CoachRunner.current(flow, s).type, 'input');
    s = CoachRunner.submit(flow, s, 'a break');
    expect(s.vars['feeling'], 'Guilty or ashamed');
    expect(s.vars['trigger'], 'boredom');
    expect(s.vars['need'], 'a break');
  });

  test('every trigger effect names a real TriggerType', () {
    // A flow emitting "stres" would parse to nothing, silently create no plan,
    // and the user would never learn their reflection went nowhere — the same
    // silent-failure class achievements_content_test closes.
    flows.forEach((name, flow) {
      for (final node in flow.nodes) {
        for (final choice in node.choices) {
          final raw = choice.effect['trigger'];
          if (raw == null) continue;
          expect(
            CopingPlanEngine.parseTrigger(raw),
            isNotNull,
            reason: '$name: node "${node.id}" choice "${choice.label}" emits '
                'trigger "$raw", which is not a TriggerType',
          );
        }
      }
    });
  });
}
