import '../../config.dart';
import '../../content/cbt_models.dart';
import '../../data/collections/cbt_entry.dart';
import '../../widgets/ad/banner_ad_widget.dart';

/// CBT toolkit: pick a worksheet to work through, and review your past entries.
class CbtHubScreen extends StatefulWidget {
  const CbtHubScreen({super.key});

  @override
  State<CbtHubScreen> createState() => _CbtHubScreenState();
}

class _CbtHubScreenState extends State<CbtHubScreen> {
  List<CbtEntry> _entries = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final entries = await cbtRepo.recent();
    if (mounted) setState(() => _entries = entries);
  }

  void _openWorksheet(CbtWorksheet w) {
    Navigator.pushNamed(context, routeName.worksheet, arguments: w)
        .then((_) => _load());
  }

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    final worksheets = contentService.worksheets;

    return Scaffold(
      backgroundColor: theme.scaffoldBg,
      appBar: AppBar(
        title: Text('CBT toolkit',
            style: appCss.headingBold22.textColor(theme.darkText)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Text(
            'Structured exercises to examine the thoughts and triggers behind an urge. Your answers are private and saved only on this device.',
            style: appCss.body14.textColor(theme.lightText),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text('WORKSHEETS',
                style: appCss.label12.textColor(theme.lightText)),
          ),
          for (final w in worksheets)
            _WorksheetCard(worksheet: w, theme: theme, onTap: () => _openWorksheet(w)),
          if (_entries.isNotEmpty) ...[
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 12),
              child: Text('YOUR ENTRIES',
                  style: appCss.label12.textColor(theme.lightText)),
            ),
            for (final e in _entries)
              _EntryCard(entry: e, theme: theme),
          ],
          const SizedBox(height: 12),
          const Center(child: BannerAdWidget()),
        ],
      ),
    );
  }
}

class _WorksheetCard extends StatelessWidget {
  const _WorksheetCard(
      {required this.worksheet, required this.onTap, required this.theme});
  final CbtWorksheet worksheet;
  final VoidCallback onTap;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: theme.cardBg,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: theme.stroke),
            ),
            child: Row(
              children: [
                Icon(Icons.edit_note_rounded, color: theme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(worksheet.title,
                          style:
                              appCss.titleSemi16.textColor(theme.darkText)),
                      const SizedBox(height: 2),
                      Text('${worksheet.steps.length} steps',
                          style: appCss.label12.textColor(theme.lightText)),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: theme.lightText),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EntryCard extends StatelessWidget {
  const _EntryCard({required this.entry, required this.theme});
  final CbtEntry entry;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    final local = entry.timestampUtc.toLocal();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: theme.cardBg,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.pushNamed(context, routeName.cbtEntry,
              arguments: entry),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.stroke),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entry.title,
                          style: appCss.medium14.textColor(theme.darkText)),
                      Text('${local.day}/${local.month}',
                          style: appCss.label12.textColor(theme.lightText)),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: theme.lightText),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
