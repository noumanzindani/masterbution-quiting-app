import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:momentum/common/theme/theme_service.dart';
import 'package:momentum/data/collections/coping_plan.dart';
import 'package:momentum/data/enums.dart';
import 'package:momentum/screens/plan/coping_plan_body.dart';

CopingPlan _plan(TriggerType t, String strategy, {int id = 1}) => CopingPlan()
  ..id = id
  ..trigger = t
  ..strategy = strategy
  ..createdAtUtc = DateTime.utc(2026, 3, 4);

Future<void> _pump(
  WidgetTester tester,
  List<CopingPlan> plans, {
  void Function(CopingPlan)? onEdit,
  void Function(CopingPlan)? onDelete,
  void Function(CopingPlan)? onHistory,
}) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  await tester.pumpWidget(
    ChangeNotifierProvider(
      create: (_) => ThemeService(prefs),
      child: MaterialApp(
        home: Scaffold(
          body: CopingPlanBody(
            plans: plans,
            onEdit: onEdit ?? (_) {},
            onDelete: onDelete ?? (_) {},
            onHistory: onHistory ?? (_) {},
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('renders each plan as trigger → strategy', (tester) async {
    await _pump(tester, [
      _plan(TriggerType.stress, 'Reach out to someone', id: 1),
      _plan(TriggerType.boredom, 'Move my body', id: 2),
    ]);
    expect(find.text('Stress'), findsOneWidget);
    expect(find.text('Reach out to someone'), findsOneWidget);
    expect(find.text('Boredom'), findsOneWidget);
    expect(find.text('Move my body'), findsOneWidget);
  });

  testWidgets('empty state explains where plans come from, without blame',
      (tester) async {
    await _pump(tester, const []);
    expect(find.textContaining('reflection'), findsOneWidget);
  });

  testWidgets('edit and delete report the plan they act on', (tester) async {
    CopingPlan? edited;
    CopingPlan? deleted;
    await _pump(
      tester,
      [_plan(TriggerType.stress, 'Reach out to someone', id: 9)],
      onEdit: (p) => edited = p,
      onDelete: (p) => deleted = p,
    );
    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pump();
    expect(edited?.id, 9);

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pump();
    expect(deleted?.id, 9);
  });

  testWidgets('tapping a plan asks for its history', (tester) async {
    CopingPlan? asked;
    await _pump(
      tester,
      [_plan(TriggerType.stress, 'Reach out to someone', id: 4)],
      onHistory: (p) => asked = p,
    );
    await tester.tap(find.text('Reach out to someone'));
    await tester.pump();
    expect(asked?.id, 4);
  });
}
