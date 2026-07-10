import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/common/languages/language_provider.dart';
import 'package:momentum/common/theme/app_theme.dart';
import 'package:momentum/common/theme/theme_service.dart';
import 'package:momentum/screens/shell/sos_widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final theme = AppTheme.fromType(ThemeType.light);

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('SosBar shows the help label and calls onTap', (tester) async {
    var tapped = false;
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeService(prefs)),
        ChangeNotifierProvider(create: (_) => LanguageProvider(prefs)),
      ],
      child: MaterialApp(
        home: SosBar(theme: theme, onTap: () => tapped = true),
      ),
    ));

    expect(find.text('I need help right now'), findsOneWidget);

    await tester.tap(find.text('I need help right now'));
    expect(tapped, isTrue);
  });

  testWidgets('SosFab shows a shield icon and calls onTap', (tester) async {
    var tapped = false;
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeService(prefs)),
        ChangeNotifierProvider(create: (_) => LanguageProvider(prefs)),
      ],
      child: MaterialApp(
        home: Scaffold(
          floatingActionButton:
              SosFab(theme: theme, onTap: () => tapped = true),
        ),
      ),
    ));

    expect(find.byIcon(Icons.shield_outlined), findsOneWidget);

    await tester.tap(find.byType(SosFab));
    expect(tapped, isTrue);
  });
}
