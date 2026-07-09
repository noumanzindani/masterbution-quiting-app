import 'package:flutter/material.dart';

/// An unlockable accent colour — the ONLY thing reward coins buy. Purely
/// cosmetic (it recolours the `primary`/`primarySoft` pair); it never gates any
/// therapeutic content. Each palette provides a light + dark variant so it works
/// in both themes. The `default` palette is the app's original teal, free and
/// always unlocked.
class AccentPalette {
  const AccentPalette({
    required this.id,
    required this.label,
    required this.cost,
    required this.lightPrimary,
    required this.lightSoft,
    required this.darkPrimary,
    required this.darkSoft,
  });

  final String id;
  final String label;

  /// Coin cost to unlock. 0 = free (the default accent).
  final int cost;

  final Color lightPrimary;
  final Color lightSoft;
  final Color darkPrimary;
  final Color darkSoft;

  Color primaryFor(bool isDark) => isDark ? darkPrimary : lightPrimary;
  Color softFor(bool isDark) => isDark ? darkSoft : lightSoft;
}

/// The accent catalogue. `default` mirrors the base [AppTheme] teal.
class AccentPalettes {
  const AccentPalettes._();

  static const String defaultId = 'default';

  static const List<AccentPalette> all = [
    AccentPalette(
      id: defaultId,
      label: 'Calm teal',
      cost: 0,
      lightPrimary: Color(0xFF2A9D8F),
      lightSoft: Color(0xFFDDF1EE),
      darkPrimary: Color(0xFF3DB5A6),
      darkSoft: Color(0xFF1E3A38),
    ),
    AccentPalette(
      id: 'ocean',
      label: 'Ocean',
      cost: 20,
      lightPrimary: Color(0xFF2E8BC0),
      lightSoft: Color(0xFFD9EAF5),
      darkPrimary: Color(0xFF4FA3D1),
      darkSoft: Color(0xFF16303F),
    ),
    AccentPalette(
      id: 'forest',
      label: 'Forest',
      cost: 25,
      lightPrimary: Color(0xFF3B8C5A),
      lightSoft: Color(0xFFDDEFE3),
      darkPrimary: Color(0xFF4FA870),
      darkSoft: Color(0xFF16301F),
    ),
    AccentPalette(
      id: 'indigo',
      label: 'Indigo',
      cost: 30,
      lightPrimary: Color(0xFF5A67D8),
      lightSoft: Color(0xFFE2E4FA),
      darkPrimary: Color(0xFF7C87E8),
      darkSoft: Color(0xFF23263F),
    ),
    AccentPalette(
      id: 'plum',
      label: 'Plum',
      cost: 30,
      lightPrimary: Color(0xFF9B5DE5),
      lightSoft: Color(0xFFEEE1FA),
      darkPrimary: Color(0xFFB07EEC),
      darkSoft: Color(0xFF2E2340),
    ),
    AccentPalette(
      id: 'amber',
      label: 'Amber',
      cost: 35,
      lightPrimary: Color(0xFFD98A2B),
      lightSoft: Color(0xFFF9ECD9),
      darkPrimary: Color(0xFFE8A54F),
      darkSoft: Color(0xFF3F3016),
    ),
    AccentPalette(
      id: 'rose',
      label: 'Rose',
      cost: 40,
      lightPrimary: Color(0xFFD65A7A),
      lightSoft: Color(0xFFF9E1E8),
      darkPrimary: Color(0xFFE87E97),
      darkSoft: Color(0xFF3F232C),
    ),
  ];

  static AccentPalette byId(String id) =>
      all.firstWhere((p) => p.id == id, orElse: () => all.first);
}
