import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../session.dart';
import 'app_theme.dart';

/// Persists and exposes the light/dark/system theme choice.
///
/// Adapted from EzHand's `ThemeService`: a [ChangeNotifier] backed by
/// SharedPreferences, injected with `prefs` at construction so it can read the
/// stored preference synchronously.
class ThemeService extends ChangeNotifier {
  ThemeService(this._prefs) {
    _index = _prefs.getInt(_session.themeIndex) ?? 2; // default: follow system
  }

  final SharedPreferences _prefs;
  final Session _session = Session();

  /// 0 = light, 1 = dark, 2 = follow system.
  late int _index;
  int get themeIndex => _index;

  ThemeMode get themeMode => switch (_index) {
        0 => ThemeMode.light,
        1 => ThemeMode.dark,
        _ => ThemeMode.system,
      };

  /// Resolves the concrete palette given the current platform brightness.
  AppTheme appThemeFor(BuildContext context) {
    final systemDark =
        MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    final isDark = _index == 1 || (_index == 2 && systemDark);
    return AppTheme.fromType(isDark ? ThemeType.dark : ThemeType.light);
  }

  void setThemeIndex(int index) {
    if (index == _index) return;
    _index = index;
    _prefs.setInt(_session.themeIndex, index);
    notifyListeners();
  }
}
