// test/learn_hub_body_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:momentum/common/theme/theme_service.dart';
import 'package:momentum/routes/route_name.dart';
import 'package:momentum/screens/learn/learn_hub_screen.dart';

void main() {
  testWidgets('LearnHubBody lists all seven content hubs and navigates on tap',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final r = RouteName();

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeService(prefs),
        child: MaterialApp(
          home: const LearnHubBody(),
          routes: {
            r.academy: (_) => const Scaffold(body: Text('academy')),
            r.cbt: (_) => const Scaffold(body: Text('cbt')),
            r.alternatives: (_) => const Scaffold(body: Text('alts')),
            r.sessions: (_) => const Scaffold(body: Text('sessions')),
            r.program: (_) => const Scaffold(body: Text('program')),
            r.values: (_) => const Scaffold(body: Text('values')),
            r.motivation: (_) => const Scaffold(body: Text('motivation')),
          },
        ),
      ),
    );

    expect(find.text('Academy'), findsOneWidget);
    expect(find.text('CBT toolkit'), findsOneWidget);
    expect(find.text('Instead of… '), findsOneWidget);
    expect(find.text('Guided sessions'), findsOneWidget);
    expect(find.text('7-day dopamine reset'), findsOneWidget);
    expect(find.text('Your values'), findsOneWidget);
    expect(find.text('Motivation'), findsOneWidget);

    await tester.tap(find.text('CBT toolkit'));
    await tester.pumpAndSettle();
    expect(find.text('cbt'), findsOneWidget);
  });
}
