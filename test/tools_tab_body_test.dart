import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:momentum/common/theme/theme_service.dart';
import 'package:momentum/routes/route_name.dart';
import 'package:momentum/screens/shell/tools_tab_screen.dart';

void main() {
  testWidgets('lists all seven tool destinations and navigates on tap',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final r = RouteName();

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeService(prefs),
        child: MaterialApp(
          home: const ToolsTabBody(),
          routes: {
            r.coachHub: (_) => const Scaffold(body: Text('coach hub')),
            r.dailyPlanner: (_) => const Scaffold(body: Text('planner')),
            r.copingPlan: (_) => const Scaffold(body: Text('plans')),
            r.wellbeing: (_) => const Scaffold(body: Text('wellbeing')),
            r.sleepLog: (_) => const Scaffold(body: Text('sleep')),
            r.rewards: (_) => const Scaffold(body: Text('rewards')),
            r.alternatives: (_) => const Scaffold(body: Text('alts')),
          },
        ),
      ),
    );

    expect(find.text('Coach & check-ins'), findsOneWidget);
    expect(find.text('Daily planner'), findsOneWidget);
    expect(find.text('My coping plans'), findsOneWidget);
    expect(find.text('Wellbeing'), findsOneWidget);
    expect(find.text('Sleep'), findsOneWidget);
    expect(find.text('Milestones & rewards'), findsOneWidget);
    expect(find.text('Healthy alternatives'), findsOneWidget);

    await tester.tap(find.text('Sleep'));
    await tester.pumpAndSettle();
    expect(find.text('sleep'), findsOneWidget);
  });
}
