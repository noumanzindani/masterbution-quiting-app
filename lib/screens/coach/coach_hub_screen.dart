import '../../config.dart';
import '../../data/collections/journal_entry.dart';
import '../../data/enums.dart';
import '../../widgets/ad/banner_ad_widget.dart';

/// The "Coach & check-ins" hub — entry point to the rule-based coach flows and
/// the daily planner, plus a look back at recent reflections for continuity.
class CoachHubScreen extends StatefulWidget {
  const CoachHubScreen({super.key});

  @override
  State<CoachHubScreen> createState() => _CoachHubScreenState();
}

class _CoachHubScreenState extends State<CoachHubScreen> {
  List<JournalEntry> _recent = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    // Daily + relapse reflections, most recent first.
    final daily = await journalRepo.recentOfKind(JournalKind.dailyReflection);
    final relapse =
        await journalRepo.recentOfKind(JournalKind.relapseReflection);
    final all = [...daily, ...relapse]
      ..sort((a, b) => b.timestampUtc.compareTo(a.timestampUtc));
    if (!mounted) return;
    setState(() => _recent = all.take(5).toList());
  }

  Future<void> _openReflection() async {
    await Navigator.pushNamed(context, routeName.coach,
        arguments: 'daily_reflection');
    _load(); // refresh the recent list when we come back
  }

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBg,
      appBar: AppBar(
        title: Text('Coach & check-ins',
            style: appCss.headingBold22.textColor(theme.darkText)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          _HubTile(
            icon: Icons.wb_twilight_rounded,
            title: 'Daily reflection',
            subtitle: 'A guided minute to check in with yourself',
            theme: theme,
            onTap: _openReflection,
          ),
          _HubTile(
            icon: Icons.checklist_rounded,
            title: "Today's plan",
            subtitle: 'A few gentle intentions for the day',
            theme: theme,
            onTap: () =>
                Navigator.pushNamed(context, routeName.dailyPlanner),
          ),
          const SizedBox(height: 24),
          if (_recent.isNotEmpty) ...[
            Text('Recent reflections',
                style: appCss.titleSemi16.textColor(theme.darkText)),
            const SizedBox(height: 12),
            for (final e in _recent) _ReflectionCard(entry: e, theme: theme),
          ],
          const SizedBox(height: 20),
          const Center(child: BannerAdWidget()),
        ],
      ),
    );
  }
}

class _HubTile extends StatelessWidget {
  const _HubTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.theme,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final AppTheme theme;
  final VoidCallback onTap;

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
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: theme.stroke),
            ),
            child: Row(
              children: [
                Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    color: theme.primarySoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: theme.primary),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style:
                              appCss.titleSemi16.textColor(theme.darkText)),
                      const SizedBox(height: 2),
                      Text(subtitle,
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

class _ReflectionCard extends StatelessWidget {
  const _ReflectionCard({required this.entry, required this.theme});
  final JournalEntry entry;
  final AppTheme theme;

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String _date(DateTime utc) {
    final d = utc.toLocal();
    return '${_months[d.month - 1]} ${d.day}';
  }

  bool get _isRelapse => entry.kind == JournalKind.relapseReflection;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _isRelapse
                    ? Icons.self_improvement_rounded
                    : Icons.wb_twilight_rounded,
                size: 16,
                color: theme.primary,
              ),
              const SizedBox(width: 6),
              Text(
                _isRelapse ? 'Learning from a slip' : 'Daily reflection',
                style: appCss.label12.textColor(theme.primary),
              ),
              const Spacer(),
              Text(_date(entry.timestampUtc),
                  style: appCss.label12.textColor(theme.lightText)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            entry.text,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: appCss.body14.textColor(theme.darkText),
          ),
        ],
      ),
    );
  }
}
