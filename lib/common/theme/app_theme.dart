import 'package:flutter/material.dart';

enum ThemeType { light, dark }

/// Palette holder built from a [ThemeType]. A calm teal/ink system — chosen to
/// feel supportive and non-clinical rather than alarming (this app must never
/// read as shaming or high-pressure).
class AppTheme {
  const AppTheme({
    required this.type,
    required this.primary,
    required this.primarySoft,
    required this.accent,
    required this.scaffoldBg,
    required this.cardBg,
    required this.fieldBg,
    required this.stroke,
    required this.darkText,
    required this.lightText,
    required this.success,
    required this.warning,
    required this.danger,
    required this.calm,
  });

  final ThemeType type;
  final Color primary;
  final Color primarySoft;
  final Color accent;
  final Color scaffoldBg;
  final Color cardBg;
  final Color fieldBg;
  final Color stroke;
  final Color darkText; // primary text
  final Color lightText; // secondary/subtitle text
  final Color success;
  final Color warning;
  final Color danger; // used sparingly; never for "you failed"
  final Color calm; // emergency/urge-surf surfaces (soothing, not alarming)

  bool get isDark => type == ThemeType.dark;

  factory AppTheme.fromType(ThemeType type) {
    switch (type) {
      case ThemeType.dark:
        return const AppTheme(
          type: ThemeType.dark,
          primary: Color(0xFF3DB5A6),
          primarySoft: Color(0xFF1E3A38),
          accent: Color(0xFFF2A65A),
          scaffoldBg: Color(0xFF10161A),
          cardBg: Color(0xFF1A2228),
          fieldBg: Color(0xFF212B32),
          stroke: Color(0xFF2C3840),
          darkText: Color(0xFFEAF2F4),
          lightText: Color(0xFF9BB0B8),
          success: Color(0xFF4CC38A),
          warning: Color(0xFFE0B341),
          danger: Color(0xFFE5736A),
          calm: Color(0xFF163A46),
        );
      case ThemeType.light:
        return const AppTheme(
          type: ThemeType.light,
          primary: Color(0xFF2A9D8F),
          primarySoft: Color(0xFFDDF1EE),
          accent: Color(0xFFE9974A),
          scaffoldBg: Color(0xFFF6F9F9),
          cardBg: Color(0xFFFFFFFF),
          fieldBg: Color(0xFFEFF4F4),
          stroke: Color(0xFFDCE6E6),
          darkText: Color(0xFF1D2A32),
          lightText: Color(0xFF63757D),
          success: Color(0xFF2E9E6B),
          warning: Color(0xFFC98A1E),
          danger: Color(0xFFCF5B52),
          calm: Color(0xFFDFF0F2),
        );
    }
  }

  /// Material [ThemeData] derived from the palette. Keeps Material widgets on
  /// brand without every screen re-specifying colors.
  ThemeData get themeData {
    final base = isDark ? ThemeData.dark() : ThemeData.light();
    return base.copyWith(
      scaffoldBackgroundColor: scaffoldBg,
      primaryColor: primary,
      colorScheme: base.colorScheme.copyWith(
        primary: primary,
        secondary: accent,
        surface: cardBg,
        error: danger,
        brightness: isDark ? Brightness.dark : Brightness.light,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBg,
        foregroundColor: darkText,
        elevation: 0,
        centerTitle: false,
      ),
      cardColor: cardBg,
      dividerColor: stroke,
    );
  }
}
