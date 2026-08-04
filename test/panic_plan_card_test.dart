import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:momentum/common/theme/app_theme.dart';
import 'package:momentum/common/theme/theme_service.dart';
import 'package:momentum/routes/route_name.dart';
import 'package:momentum/screens/emergency/panic_screen.dart';

/// The panic hub's card is rendered from a count the screen fetches, so the
/// card itself is a pure presenter — the same split as [CopingPlanBody] and
/// [SosBar]. That keeps the copy and the destination under test even though the
/// screen's own `copingPlanRepo` read can't be reached from a widget test.
void main() {
  final theme = AppTheme.fromType(ThemeType.light);

  Future<void> pumpCard(WidgetTester tester, int count) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final r = RouteName();

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeService(prefs),
        child: MaterialApp(
          home: Scaffold(body: PanicPlanCard(count: count, theme: theme)),
          routes: {r.copingPlan: (_) => const Scaffold(body: Text('plans'))},
        ),
      ),
    );
  }

  testWidgets('reads in the singular for a lone plan', (tester) async {
    await pumpCard(tester, 1);

    expect(find.text('Your coping plans'), findsOneWidget);
    expect(find.text('One thing you decided to try'), findsOneWidget);
  });

  testWidgets('counts the plans in the plural', (tester) async {
    await pumpCard(tester, 3);

    expect(find.text('3 things you decided to try'), findsOneWidget);
  });

  testWidgets('opens the coping plan screen on tap', (tester) async {
    await pumpCard(tester, 2);

    await tester.tap(find.text('Your coping plans'));
    await tester.pumpAndSettle();

    expect(find.text('plans'), findsOneWidget);
  });
}
