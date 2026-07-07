import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../session.dart';
import 'en.dart';

/// Holds the active language map and persists the chosen locale.
///
/// Phase 0 ships English only. The map-lookup design (key → string, falling
/// back to the key itself) is identical to EzHand's — so adding ar/fr/es in
/// Phase 7 is just more maps + registering `flutter_localizations` for RTL.
class LanguageProvider extends ChangeNotifier {
  LanguageProvider(this._prefs) {
    _localeCode = _prefs.getString(_session.locale) ?? 'en';
  }

  final SharedPreferences _prefs;
  final Session _session = Session();

  static const Map<String, Map<String, String>> _maps = {'en': en};

  late String _localeCode;
  String get localeCode => _localeCode;

  bool get isRtl => _localeCode == 'ar';

  Map<String, String> get _active => _maps[_localeCode] ?? en;

  /// Resolve a key to its localized string, falling back to the key so a
  /// missing translation is visible rather than blank.
  String translate(String key) => _active[key] ?? key;

  void setLocale(String code) {
    if (!_maps.containsKey(code) || code == _localeCode) return;
    _localeCode = code;
    _prefs.setString(_session.locale, code);
    notifyListeners();
  }
}
