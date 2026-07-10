import '../../config.dart';

/// Pure, reusable bottom-navigation shell. Owns the [BottomNavigationBar] and
/// switches between [tabs] via an [IndexedStack] so each tab's scroll position
/// and provider state survive switching. Has no dependency on any specific
/// screen — [MainShellScreen] wires the real app tabs into it.
class TabShellScaffold extends StatefulWidget {
  const TabShellScaffold({
    super.key,
    required this.tabs,
    required this.items,
    this.appBarTitleFor,
    this.topBannerFor,
    this.floatingActionFor,
    this.initialIndex = 0,
  });

  final List<Widget> tabs;
  final List<BottomNavigationBarItem> items;
  final String Function(int index)? appBarTitleFor;
  final Widget? Function(int index)? topBannerFor;
  final Widget? Function(int index)? floatingActionFor;
  final int initialIndex;

  @override
  State<TabShellScaffold> createState() => _TabShellScaffoldState();
}

class _TabShellScaffoldState extends State<TabShellScaffold> {
  late int _index = widget.initialIndex;

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    final banner = widget.topBannerFor?.call(_index);

    return Scaffold(
      backgroundColor: theme.scaffoldBg,
      appBar: widget.appBarTitleFor == null
          ? null
          : AppBar(
              title: Text(widget.appBarTitleFor!(_index),
                  style: appCss.headingBold22.textColor(theme.darkText)),
            ),
      body: Column(
        children: [
          ?banner,
          Expanded(
            child: IndexedStack(index: _index, children: widget.tabs),
          ),
        ],
      ),
      floatingActionButton: widget.floatingActionFor?.call(_index),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: theme.cardBg,
        selectedItemColor: theme.primary,
        unselectedItemColor: theme.lightText,
        items: widget.items,
      ),
    );
  }
}
