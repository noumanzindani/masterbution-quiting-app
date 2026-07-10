import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:momentum/common/theme/theme_service.dart';
import 'package:momentum/screens/shell/tab_shell_scaffold.dart';

Future<Widget> _harness(Widget child) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  return ChangeNotifierProvider(
    create: (_) => ThemeService(prefs),
    child: MaterialApp(home: child),
  );
}

void main() {
  testWidgets('tapping a nav item switches the IndexedStack index',
      (tester) async {
    await tester.pumpWidget(await _harness(
      const TabShellScaffold(
        tabs: [Text('tab 0'), Text('tab 1'), Text('tab 2')],
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'A'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'B'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'C'),
        ],
      ),
    ));

    expect(tester.widget<IndexedStack>(find.byType(IndexedStack)).index, 0);

    await tester.tap(find.text('B'));
    await tester.pumpAndSettle();

    expect(tester.widget<IndexedStack>(find.byType(IndexedStack)).index, 1);
  });

  testWidgets('topBannerFor and floatingActionFor receive the selected index',
      (tester) async {
    await tester.pumpWidget(await _harness(
      TabShellScaffold(
        tabs: const [Text('tab 0'), Text('tab 1')],
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'A'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'B'),
        ],
        topBannerFor: (i) => i == 0 ? const Text('banner') : null,
        floatingActionFor: (i) => i == 1 ? const Text('fab') : null,
      ),
    ));

    expect(find.text('banner'), findsOneWidget);
    expect(find.text('fab'), findsNothing);

    await tester.tap(find.text('B'));
    await tester.pumpAndSettle();

    expect(find.text('banner'), findsNothing);
    expect(find.text('fab'), findsOneWidget);
  });
}
