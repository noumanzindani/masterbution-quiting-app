import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/common/theme/app_theme.dart';
import 'package:momentum/widgets/nav_row.dart';

void main() {
  testWidgets('NavRow shows title/subtitle and pushes its route on tap',
      (tester) async {
    final theme = AppTheme.fromType(ThemeType.light);

    await tester.pumpWidget(MaterialApp(
      home: NavRow(
        icon: Icons.star,
        title: 'Habits',
        subtitle: 'Build wins',
        route: '/target',
        theme: theme,
      ),
      routes: {
        '/target': (_) => const Scaffold(body: Text('target screen')),
      },
    ));

    expect(find.text('Habits'), findsOneWidget);
    expect(find.text('Build wins'), findsOneWidget);

    await tester.tap(find.text('Habits'));
    await tester.pumpAndSettle();

    expect(find.text('target screen'), findsOneWidget);
  });
}
