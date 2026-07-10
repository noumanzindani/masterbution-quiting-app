import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/content/content_models.dart';
import 'package:momentum/content/session_models.dart';
import 'package:momentum/content/wellbeing_models.dart';

/// Validates that every wellbeing module points at content that actually exists.
/// A module referencing a missing article/session id would render a tile that
/// opens an empty screen — invisible to `analyze`, caught here.
List<T> _load<T>(String path, T Function(Map<String, dynamic>) fromJson) =>
    (jsonDecode(File(path).readAsStringSync()) as List)
        .map((e) => fromJson(e as Map<String, dynamic>))
        .toList();

void main() {
  final modules = _load(
      'assets/content/wellbeing/modules.json', WellbeingModule.fromJson);
  final articleIds = _load(
          'assets/content/wellbeing/articles.json', ContentArticle.fromJson)
      .map((a) => a.id)
      .toSet();
  final sessionIds = _load(
          'assets/content/wellbeing/sessions.json', GuidedSession.fromJson)
      .map((s) => s.id)
      .toSet();

  test('modules corpus is non-empty', () {
    expect(modules, isNotEmpty);
  });

  test('every referenced article id resolves', () {
    for (final m in modules) {
      for (final id in m.articleIds) {
        expect(articleIds.contains(id), isTrue,
            reason: 'module "${m.id}" references missing article "$id"');
      }
    }
  });

  test('every referenced session id resolves', () {
    for (final m in modules) {
      for (final id in m.sessionIds) {
        expect(sessionIds.contains(id), isTrue,
            reason: 'module "${m.id}" references missing session "$id"');
      }
    }
  });

  test('every module has at least one piece of content', () {
    for (final m in modules) {
      expect(m.articleIds.length + m.sessionIds.length, greaterThan(0),
          reason: 'module "${m.id}" is empty');
    }
  });

  test('module ids are unique', () {
    final ids = modules.map((m) => m.id).toList();
    expect(ids.toSet().length, ids.length);
  });

  test('the sleep module wires up the sleep tracker', () {
    final sleep = modules.firstWhere((m) => m.id == 'sleep');
    expect(sleep.tracker, 'sleepLog',
        reason: 'sleep module should surface the nightly tracker');
  });
}
