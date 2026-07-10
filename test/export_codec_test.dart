import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/services/export_codec.dart';

void main() {
  final data = {
    'tracker': [
      {'id': 1, 'outcome': 3}
    ],
    'journal': [
      {'id': 9, 'text': 'private'}
    ],
  };

  group('ExportCodec envelope round-trip', () {
    test('encode → decode preserves data, version and timestamp', () {
      final json = ExportCodec.encode(data: data, exportedAt: '2026-07-10T00:00:00Z');
      final decoded = ExportCodec.decode(json);
      expect(decoded.version, ExportCodec.currentVersion);
      expect(decoded.exportedAt, '2026-07-10T00:00:00Z');
      expect(decoded.data['tracker'], data['tracker']);
      expect(decoded.data['journal'], data['journal']);
    });
  });

  group('ExportCodec validation', () {
    test('rejects non-JSON', () {
      expect(() => ExportCodec.decode('not json {'), throwsException);
    });

    test('rejects a file that is not a Momentum backup', () {
      expect(() => ExportCodec.decode('{"app":"other","version":1,"data":{}}'),
          throwsException);
    });

    test('rejects an unsupported (future) version', () {
      final future = '{"app":"momentum","version":9999,"exportedAt":"x","data":{}}';
      expect(() => ExportCodec.decode(future), throwsException);
    });
  });

  group('ExportCodec scope filter', () {
    test('keeps only the included sections', () {
      final filtered = ExportCodec.filter(data, {'tracker'});
      expect(filtered.keys, ['tracker']);
      expect(filtered.containsKey('journal'), isFalse);
    });

    test('an empty include set yields no sections', () {
      expect(ExportCodec.filter(data, {}), isEmpty);
    });
  });
}
