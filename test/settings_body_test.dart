import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:momentum/common/languages/language_provider.dart';
import 'package:momentum/common/theme/theme_service.dart';
import 'package:momentum/config.dart' as cfg;
import 'package:momentum/providers/settings_provider.dart';
import 'package:momentum/screens/settings/settings_screen.dart';

void main() {
  testWidgets('SettingsBody shows privacy, data and support sections',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefsInstance = await SharedPreferences.getInstance();
    cfg.prefs = prefsInstance;

    // The settings list is taller than the default test surface; grow it so
    // every section is actually built (ListView only builds what's within
    // the viewport + cache extent) rather than scrolling to find each one.
    tester.view.physicalSize = const Size(800, 3000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeService(prefsInstance)),
          ChangeNotifierProvider(
              create: (_) => LanguageProvider(prefsInstance)),
          ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ],
        child: const MaterialApp(home: Scaffold(body: SettingsBody())),
      ),
    );

    expect(find.text('App lock'), findsOneWidget);
    expect(find.text('Discreet mode'), findsOneWidget);
    expect(find.text('Backup & export'), findsOneWidget);
    expect(find.text('Accountability partner'), findsOneWidget);
    expect(find.text('Therapy notes'), findsOneWidget);
  });
}
