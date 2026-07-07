import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/content/content_models.dart';
import 'package:momentum/services/alternatives_engine.dart';

HealthyAlternative _alt(String id,
        {int minutes = 5, String category = 'general'}) =>
    HealthyAlternative(
      id: id,
      title: id,
      description: '',
      category: category,
      minutes: minutes,
      icon: 'bolt',
    );

void main() {
  group('AlternativesEngine.suggest', () {
    test('only returns activities that fit the available time', () {
      final all = [_alt('a', minutes: 5), _alt('b', minutes: 15), _alt('c', minutes: 30)];
      final out = AlternativesEngine.suggest(all, maxMinutes: 15);
      expect(out.every((a) => a.minutes <= 15), isTrue);
      expect(out.map((a) => a.id), isNot(contains('c')));
    });

    test('caps the number of suggestions', () {
      final all = [for (var i = 0; i < 6; i++) _alt('a$i')];
      expect(AlternativesEngine.suggest(all, maxMinutes: 30, count: 3).length, 3);
    });

    test('prefers a variety of categories', () {
      final all = [
        _alt('a1', category: 'move'),
        _alt('a2', category: 'move'),
        _alt('b1', category: 'connect'),
        _alt('c1', category: 'create'),
      ];
      final cats =
          AlternativesEngine.suggest(all, maxMinutes: 30, count: 3)
              .map((a) => a.category)
              .toSet();
      expect(cats, {'move', 'connect', 'create'});
    });

    test('returns empty when nothing fits', () {
      final all = [_alt('a', minutes: 30), _alt('b', minutes: 45)];
      expect(AlternativesEngine.suggest(all, maxMinutes: 5), isEmpty);
    });
  });
}
