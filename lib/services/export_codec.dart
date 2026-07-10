import 'dart:convert';

/// A decoded backup envelope.
typedef DecodedBundle = ({int version, String exportedAt, Map<String, dynamic> data});

/// Pure (de)serialization of the backup envelope — no Isar, no crypto, so the
/// format contract is fully unit-testable. The envelope tags the file as a
/// Momentum backup and carries a schema [version] so a future import can migrate
/// or reject an incompatible file instead of silently corrupting data.
class ExportCodec {
  const ExportCodec._();

  static const String _appTag = 'momentum';
  static const int currentVersion = 1;

  /// Wrap [data] (section-name → list of row maps) into the versioned envelope
  /// JSON string.
  static String encode({
    required Map<String, dynamic> data,
    required String exportedAt,
  }) {
    return jsonEncode({
      'app': _appTag,
      'version': currentVersion,
      'exportedAt': exportedAt,
      'data': data,
    });
  }

  /// Parse + validate a backup file. Throws a clear [Exception] if it isn't a
  /// Momentum backup or is a version this build can't read.
  static DecodedBundle decode(String jsonStr) {
    final Object? parsed;
    try {
      parsed = jsonDecode(jsonStr);
    } catch (_) {
      throw Exception('This file isn\'t a valid backup.');
    }
    if (parsed is! Map || parsed['app'] != _appTag) {
      throw Exception('This file isn\'t a Momentum backup.');
    }
    final version = parsed['version'];
    if (version is! int || version > currentVersion) {
      throw Exception('This backup was made by a newer version of the app.');
    }
    final data = parsed['data'];
    return (
      version: version,
      exportedAt: parsed['exportedAt']?.toString() ?? '',
      data: data is Map ? Map<String, dynamic>.from(data) : <String, dynamic>{},
    );
  }

  /// Keep only the sections the user chose to include (the sharing controls).
  static Map<String, dynamic> filter(
          Map<String, dynamic> data, Set<String> include) =>
      {
        for (final e in data.entries)
          if (include.contains(e.key)) e.key: e.value,
      };
}
