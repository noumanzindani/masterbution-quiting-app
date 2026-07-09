import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../session.dart';
import 'accent_palette.dart';
import 'app_theme.dart';

/// Persists and exposes the light/dark/system theme choice.
///
/// Adapted from EzHand's `ThemeService`: a [ChangeNotifier] backed by
/// SharedPreferences, injected with `prefs` at construction so it can read the
/// stored preference synchronously.
class ThemeService extends ChangeNotifier {
  ThemeService(this._prefs) {
    _index = _prefs.getInt(_session.themeIndex) ?? 2; // default: follow system
    _accentId =
        _prefs.getString(_session.chosenAccent) ?? AccentPalettes.defaultId;
  }

  final SharedPreferences _prefs;
  final Session _session = Session();

  /// 0 = light, 1 = dark, 2 = follow system.
  late int _index;
  int get themeIndex => _index;

  /// The selected (unlockable, cosmetic) accent palette id.
  late String _accentId;
  String get accentId => _accentId;

  ThemeMode get themeMode => switch (_index) {
        0 => ThemeMode.light,
        1 => ThemeMode.dark,
        _ => ThemeMode.system,
      };

  /// Resolves the concrete palette given the current platform brightness, with
  /// the chosen accent applied on top (default accent = the base teal).
  AppTheme appThemeFor(BuildContext context) {
    final systemDark =
        MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    final isDark = _index == 1 || (_index == 2 && systemDark);
    final base = AppTheme.fromType(isDark ? ThemeType.dark : ThemeType.light);
    if (_accentId == AccentPalettes.defaultId) return base;
    final accent = AccentPalettes.byId(_accentId);
    return base.copyWith(
      primary: accent.primaryFor(isDark),
      primarySoft: accent.softFor(isDark),
    );
  }

  void setThemeIndex(int index) {
    if (index == _index) return;
    _index = index;
    _prefs.setInt(_session.themeIndex, index);
    notifyListeners();
  }

  /// Apply an unlocked accent palette (the RewardsProvider gates unlocking).
  void setAccent(String accentId) {
    if (accentId == _accentId) return;
    _accentId = accentId;
    _prefs.setString(_session.chosenAccent, accentId);
    notifyListeners();
  }

  /// Material [ThemeData] for the given brightness with the chosen accent baked
  /// in — used by `MaterialApp` so accent recolours Material defaults too
  /// (spinners, switches), matching the custom widgets driven by [appThemeFor].
  ThemeData themeDataFor(ThemeType type) {
    final base = AppTheme.fromType(type);
    if (_accentId == AccentPalettes.defaultId) return base.themeData;
    final accent = AccentPalettes.byId(_accentId);
    final isDark = type == ThemeType.dark;
    return base
        .copyWith(
          primary: accent.primaryFor(isDark),
          primarySoft: accent.softFor(isDark),
        )
        .themeData;
  }
}
