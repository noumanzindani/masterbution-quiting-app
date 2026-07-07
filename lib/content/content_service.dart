import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import 'cbt_models.dart';
import 'content_models.dart';
import 'program_models.dart';
import 'quiz_models.dart';
import 'session_models.dart';

/// Loads and caches the bundled JSON content corpus. Preloaded once at startup
/// (in [AppInit]) since the corpus is small; every screen then reads
/// synchronously from the in-memory lists.
///
/// Loading is fully defensive: a missing or malformed asset degrades to an
/// empty list (and an empty section in the UI) rather than crashing the app.
class ContentService {
  List<ContentArticle> _articles = const [];
  List<Quote> _quotes = const [];
  List<HealthyAlternative> _alternatives = const [];
  List<CbtWorksheet> _worksheets = const [];
  List<Quiz> _quizzes = const [];
  List<GuidedSession> _sessions = const [];
  List<ValueItem> _values = const [];
  Program? _dopamineReset;
  Map<String, String> _categoryLabels = const {};

  Future<void> preload() async {
    await _loadManifest();
    _articles = await _loadList(
        'assets/content/academy/articles.json', ContentArticle.fromJson);
    _quotes = await _loadList(
        'assets/content/motivation/quotes.json', Quote.fromJson);
    _alternatives = await _loadList(
        'assets/content/alternatives.json', HealthyAlternative.fromJson);
    _worksheets = await _loadList(
        'assets/content/cbt/worksheets.json', CbtWorksheet.fromJson);
    _quizzes = await _loadList(
        'assets/content/academy/quizzes.json', Quiz.fromJson);
    _sessions = await _loadList(
        'assets/content/sessions/sessions.json', GuidedSession.fromJson);
    _values = await _loadList(
        'assets/content/values/values.json', ValueItem.fromJson);
    _dopamineReset = await _loadObject(
        'assets/content/programs/dopamine_reset.json', Program.fromJson);
  }

  // --- Articles / academy ---

  List<ContentArticle> get articles => _articles;

  List<ContentArticle> articlesByCategory(String category) =>
      _articles.where((a) => a.category == category).toList();

  ContentArticle? articleById(String id) {
    for (final a in _articles) {
      if (a.id == id) return a;
    }
    return null;
  }

  /// Category ids that have at least one article, in manifest order.
  List<String> get categories =>
      _categoryLabels.keys.where((c) => articlesByCategory(c).isNotEmpty).toList();

  String categoryLabel(String id) => _categoryLabels[id] ?? id;

  // --- Motivation ---

  List<Quote> get quotes => _quotes;

  /// Deterministic quote for a given local day so it's stable within the day.
  Quote quoteForDay(int epochDay) => _quotes.isEmpty
      ? const Quote(text: 'One small step at a time.')
      : _quotes[epochDay % _quotes.length];

  List<ContentArticle> get stories => articlesByCategory('story');

  // --- Alternatives ---

  List<HealthyAlternative> get alternatives => _alternatives;

  // --- CBT worksheets ---

  List<CbtWorksheet> get worksheets => _worksheets;

  CbtWorksheet? worksheetById(String id) {
    for (final w in _worksheets) {
      if (w.id == id) return w;
    }
    return null;
  }

  // --- Quizzes ---

  List<Quiz> get quizzes => _quizzes;

  List<Quiz> quizzesByCategory(String category) =>
      _quizzes.where((q) => q.category == category).toList();

  // --- Sessions / program / values ---

  List<GuidedSession> get sessions => _sessions;

  List<ValueItem> get values => _values;

  Program? get dopamineReset => _dopamineReset;

  // --- loading ---

  Future<void> _loadManifest() async {
    try {
      final raw = await rootBundle.loadString('assets/content/manifest.json');
      final manifest = jsonDecode(raw) as Map<String, dynamic>;
      final cats = (manifest['categories'] as List?) ?? const [];
      _categoryLabels = {
        for (final c in cats)
          (c as Map<String, dynamic>)['id'] as String: c['label'] as String,
      };
    } catch (_) {
      _categoryLabels = const {};
    }
  }

  Future<List<T>> _loadList<T>(
    String path,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final raw = await rootBundle.loadString(path);
      final data = jsonDecode(raw) as List;
      return data
          .map((e) => fromJson(e as Map<String, dynamic>))
          .toList(growable: false);
    } catch (_) {
      return const [];
    }
  }

  Future<T?> _loadObject<T>(
    String path,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final raw = await rootBundle.loadString(path);
      return fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }
}
