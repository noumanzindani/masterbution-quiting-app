import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/common/languages/ar.dart';
import 'package:momentum/common/languages/en.dart';
import 'package:momentum/common/languages/es.dart';
import 'package:momentum/common/languages/fr.dart';

/// Guards the localization: every UI map must cover the same keys as English
/// (so no screen silently shows a raw key), and each translated content file
/// must line up with its English source.
void main() {
  group('UI string maps', () {
    for (final entry in {'ar': ar, 'fr': fr, 'es': es}.entries) {
      test('${entry.key} covers every English key with non-empty values', () {
        for (final key in en.keys) {
          expect(entry.value.containsKey(key), isTrue,
              reason: '${entry.key} is missing "$key"');
          expect(entry.value[key]!.trim(), isNotEmpty);
        }
      });
    }
  });

  group('localized motivation quotes', () {
    final enCount =
        (jsonDecode(File('assets/content/motivation/quotes.json').readAsStringSync())
                as List)
            .length;

    for (final locale in ['ar', 'fr', 'es']) {
      test('$locale quotes match the English count and are non-empty', () {
        final path = 'assets/content/i18n/$locale/motivation/quotes.json';
        final list = jsonDecode(File(path).readAsStringSync()) as List;
        expect(list.length, enCount);
        for (final q in list.cast<Map>()) {
          expect((q['text'] as String).trim(), isNotEmpty);
        }
      });
    }
  });
}
