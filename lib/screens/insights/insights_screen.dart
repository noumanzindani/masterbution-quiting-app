import 'package:fl_chart/fl_chart.dart';

import '../../config.dart';
import '../../data/trigger_labels.dart';
import '../../providers/analytics_provider.dart';
import '../../services/analytics_engine.dart';
import '../../widgets/ad/banner_ad_widget.dart';

/// "Make the data meaningful" — descriptive patterns from the event log:
/// gated insight cards, a when-urges-hit heatmap, common triggers, and a weekly
/// trend. Non-crisis screen, so a banner is allowed (still policy-gated).
class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AnalyticsProvider(),
      child: const _InsightsView(),
    );
  }
}

class _InsightsView extends StatelessWidget {
  const _InsightsView();

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    final p = context.watch<AnalyticsProvider>();

    return Scaffold(
      backgroundColor: theme.scaffoldBg,
      appBar: AppBar(
        title: Text('Insights',
            style: appCss.headingBold22.textColor(theme.darkText)),
      ),
      body: p.loading
          ? const Center(child: CircularProgressIndicator())
          : !p.hasEnoughData
              ? _EmptyState(theme: theme)
              : ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  children: [
                    if (p.insights.isNotEmpty) ...[
                      for (final i in p.insights)
                        _InsightCard(text: i.text, theme: theme),
                      const SizedBox(height: 12),
                    ],
                    _Section(
                      title: 'When urges tend to hit',
                      subtitle: 'Darker = more slips logged at that time.',
                      theme: theme,
                      child: _Heatmap(grid: p.lapseHeatmap, theme: theme),
                    ),
                    if (p.topTriggers.isNotEmpty)
                      _Section(
                        title: 'Most common triggers',
                        theme: theme,
                        child: _TriggerBars(data: p.topTriggers, theme: theme),
                      ),
                    _Section(
                      title: 'Slips per week',
                      subtitle: p.weeklyTrend.slope < -0.05
                          ? 'Trending down — the direction that matters. (estimate)'
                          : p.weeklyTrend.slope > 0.05
                              ? 'Ticking up lately — worth a gentle check-in. (estimate)'
                              : 'Holding steady. (estimate)',
                      theme: theme,
                      child: _WeeklyTrend(weekly: p.weeklyLapses, theme: theme),
                    ),
                    const SizedBox(height: 12),
                    const Center(child: BannerAdWidget()),
                  ],
                ),
    );
  }
}

// --- sections ---------------------------------------------------------------

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    this.subtitle,
    required this.child,
    required this.theme,
  });
  final String title;
  final String? subtitle;
  final Widget child;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: appCss.titleSemi16.textColor(theme.darkText)),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle!, style: appCss.label12.textColor(theme.lightText)),
          ],
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({required this.text, required this.theme});
  final String text;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.primarySoft,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline_rounded, color: theme.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: appCss.body14.textColor(theme.darkText)),
          ),
        ],
      ),
    );
  }
}

// --- heatmap ----------------------------------------------------------------

class _Heatmap extends StatelessWidget {
  const _Heatmap({required this.grid, required this.theme});
  final List<List<int>> grid;
  final AppTheme theme;

  static const _days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  int get _max {
    var m = 0;
    for (final row in grid) {
      for (final c in row) {
        if (c > m) m = c;
      }
    }
    return m;
  }

  @override
  Widget build(BuildContext context) {
    final max = _max;
    return Column(
      children: [
        for (var d = 0; d < 7; d++)
          Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Row(
              children: [
                SizedBox(
                  width: 16,
                  child: Text(_days[d],
                      style: appCss.label12.textColor(theme.lightText)),
                ),
                const SizedBox(width: 4),
                for (var h = 0; h < 24; h++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.6),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: _cellColor(grid[d][h], max),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final label in ['12a', '6a', '12p', '6p', '11p'])
                Text(label, style: appCss.label12.textColor(theme.lightText)),
            ],
          ),
        ),
      ],
    );
  }

  Color _cellColor(int count, int max) {
    if (count == 0 || max == 0) return theme.fieldBg;
    final t = count / max;
    return theme.primary.withValues(alpha: 0.2 + 0.8 * t);
  }
}

// --- trigger bars -----------------------------------------------------------

class _TriggerBars extends StatelessWidget {
  const _TriggerBars({required this.data, required this.theme});
  final List<TriggerCount> data;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    final max = data.isEmpty ? 1 : data.first.count;
    return Column(
      children: [
        for (final tc in data)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 96,
                  child: Text(triggerLabel(tc.trigger),
                      style: appCss.body14.textColor(theme.darkText)),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: max == 0 ? 0 : tc.count / max,
                      minHeight: 10,
                      backgroundColor: theme.fieldBg,
                      valueColor: AlwaysStoppedAnimation(theme.primary),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text('${tc.count}',
                    style: appCss.label12.textColor(theme.lightText)),
              ],
            ),
          ),
      ],
    );
  }
}

// --- weekly trend (fl_chart) ------------------------------------------------

class _WeeklyTrend extends StatelessWidget {
  const _WeeklyTrend({required this.weekly, required this.theme});
  final List<int> weekly;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    final maxY = (weekly.isEmpty ? 0 : weekly.reduce((a, b) => a > b ? a : b))
        .toDouble();
    return SizedBox(
      height: 140,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: maxY < 3 ? 3 : maxY + 1,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) =>
                FlLine(color: theme.stroke, strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final i = value.toInt();
                  final weeksAgo = weekly.length - 1 - i;
                  final label = weeksAgo == 0 ? 'now' : '-${weeksAgo}w';
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(label,
                        style: appCss.label12.textColor(theme.lightText)),
                  );
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: [
                for (var i = 0; i < weekly.length; i++)
                  FlSpot(i.toDouble(), weekly[i].toDouble()),
              ],
              isCurved: true,
              color: theme.primary,
              barWidth: 3,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: theme.primary.withValues(alpha: 0.12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- empty state ------------------------------------------------------------

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.theme});
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.insights_rounded, size: 48, color: theme.primary),
            const SizedBox(height: 16),
            Text('Patterns are on their way',
                style: appCss.titleSemi18.textColor(theme.darkText)),
            const SizedBox(height: 8),
            Text(
              'Keep logging urges and check-ins. Once there’s enough to be meaningful, your personal patterns show up here — never before, so nothing here is guesswork.',
              textAlign: TextAlign.center,
              style: appCss.body14.textColor(theme.lightText),
            ),
          ],
        ),
      ),
    );
  }
}
