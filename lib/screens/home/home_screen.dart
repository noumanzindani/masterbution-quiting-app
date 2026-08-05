import '../../config.dart';
import '../../data/collections/recovery_goal.dart';
import '../../data/enums.dart';
import '../../providers/dashboard_provider.dart';
import '../../services/coping_plan_engine.dart';
import '../../services/emergency_flow.dart';
import '../../services/streak_service.dart';
import '../../widgets/ad/banner_ad_widget.dart';
import '../onboarding/assessment_content.dart';
import 'log_sheets.dart';

/// The Home tab's content — the app's core loop surface: see progress at a
/// glance and log an urge / slip / check-in. Hosted inside [MainShellScreen]'s
/// IndexedStack; owns no Scaffold/AppBar of its own — the shell supplies both,
/// plus the pinned [SosBar] above this content.
///
/// [DashboardProvider] is scoped here so returning to this tab (e.g. right
/// after onboarding saves the goal) reloads current data automatically.
class HomeTabBody extends StatelessWidget {
  const HomeTabBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardProvider(),
      child: const _DashboardBody(),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody();

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    final p = context.watch<DashboardProvider>();

    return p.loading
        ? const Center(child: CircularProgressIndicator())
        : p.goal == null
            ? _EmptyState(theme: theme)
            : _Content(goal: p.goal!, stats: p.stats, theme: theme);
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.goal, required this.stats, required this.theme});
  final RecoveryGoal goal;
  final StreakStats? stats;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    final s = stats;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        _StreakHero(goal: goal, stats: s, theme: theme),
        const SizedBox(height: 16),
        if (s != null)
          Row(
            children: [
              Expanded(
                child: _ScoreCard(
                  label: 'Recovery score',
                  value: s.recoveryScore,
                  hint: 'Holds steady through slips',
                  theme: theme,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ScoreCard(
                  label: 'Consistency',
                  value: s.consistencyScore,
                  hint: 'Showing up, last 30 days',
                  theme: theme,
                ),
              ),
            ],
          ),
        const SizedBox(height: 20),
        Text('Quick actions',
            style: appCss.titleSemi16.textColor(theme.darkText)),
        const SizedBox(height: 12),
        _QuickActions(theme: theme),
        const SizedBox(height: 20),
        // Self-censoring: hidden on no-ad routes and during a post-lapse
        // cooldown. Never appears on the emergency/crisis screens.
        const Center(child: BannerAdWidget()),
      ],
    );
  }
}

// --- Streak hero ------------------------------------------------------------

class _StreakHero extends StatelessWidget {
  const _StreakHero(
      {required this.goal, required this.stats, required this.theme});
  final RecoveryGoal goal;
  final StreakStats? stats;
  final AppTheme theme;

  ({int day, String label})? _nextMilestone(int days) {
    for (final m in goal.milestones) {
      if (m.day > days) return (day: m.day, label: m.label);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final days = stats?.daysSinceLastLapse ?? 0;
    final next = _nextMilestone(days);
    final progress =
        next == null ? 1.0 : (days / next.day).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [theme.primary, theme.primary.withValues(alpha: 0.82)],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(goalLabel(goal.type),
              style: appCss.medium14.textColor(Colors.white70)),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('$days',
                  style: appCss.counterBold40.textColor(Colors.white).sized(52)),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text('${_plural(days, 'day')} steady',
                    style: appCss.titleSemi16.textColor(Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation(Colors.white),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            next == null
                ? 'Every milestone reached — incredible.'
                : '${next.day - days} ${_plural(next.day - days, 'day')} to ${next.label.toLowerCase()}',
            style: appCss.label12.textColor(Colors.white70),
          ),
        ],
      ),
    );
  }
}

/// Naive English pluralization for small day counts ("1 day", "2 days").
String _plural(int n, String word) => n == 1 ? word : '${word}s';

class _ScoreCard extends StatelessWidget {
  const _ScoreCard({
    required this.label,
    required this.value,
    required this.hint,
    required this.theme,
  });
  final String label;
  final int value;
  final String hint;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: appCss.medium14.textColor(theme.lightText)),
          const SizedBox(height: 8),
          Text('$value',
              style: appCss.counterBold40.textColor(theme.primary).sized(32)),
          const SizedBox(height: 4),
          Text(hint, style: appCss.label12.textColor(theme.lightText)),
        ],
      ),
    );
  }
}

// --- Quick actions ----------------------------------------------------------

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.theme});
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.7,
      children: [
        _ActionTile(
          icon: Icons.bolt_outlined,
          label: language(context, appFonts.logUrge),
          theme: theme,
          onTap: () => _logUrge(context),
        ),
        _ActionTile(
          icon: Icons.check_circle_outline_rounded,
          label: 'I resisted',
          theme: theme,
          onTap: () => _quickResist(context),
        ),
        _ActionTile(
          icon: Icons.wb_sunny_outlined,
          label: 'Daily check-in',
          theme: theme,
          onTap: () => _checkIn(context),
        ),
        _ActionTile(
          icon: Icons.favorite_border_rounded,
          label: language(context, appFonts.iSlipped),
          theme: theme,
          onTap: () => _slip(context),
        ),
      ],
    );
  }

  /// After a slip is logged, gently open the relapse-reflection coach flow (a
  /// no-ad route). The flow reframes the lapse as learning, never failure.
  Future<void> _logUrge(BuildContext context) async {
    final result = await showLogUrgeSheet(context);
    // A peak-intensity urge escalates into the guided emergency sequence — the
    // same tested rule the panic hub uses (EmergencyFlow.shouldEscalate). The
    // matched trigger rides along so the reflect step can name the plan.
    if (result == null ||
        !EmergencyFlow.shouldEscalate(result.intensity) ||
        !context.mounted) {
      return;
    }
    final active = await copingPlanRepo.active();
    final plan = CopingPlanEngine.matchFor(result.triggers, active);
    if (!context.mounted) return;
    await Navigator.pushNamed(
      context,
      routeName.emergencyMode,
      arguments: plan?.trigger,
    );
  }

  Future<void> _slip(BuildContext context) async {
    final logged = await showSlipSheet(context);
    if (logged == true && context.mounted) {
      await Navigator.pushNamed(
        context,
        routeName.relapseReflection,
        arguments: 'relapse_reflection',
      );
    }
  }

  Future<void> _quickResist(BuildContext context) async {
    await context.read<DashboardProvider>().logUrge(outcome: Outcome.resisted);
    if (context.mounted) _toast(context, 'Logged — that\'s a real win.');
  }

  Future<void> _checkIn(BuildContext context) async {
    await context.read<DashboardProvider>().checkInClean();
    if (context.mounted) _toast(context, 'Checked in for today. 🌱');
  }

  void _toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.theme,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return Material(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: theme.primary, size: 26),
              Text(label, style: appCss.titleSemi16.textColor(theme.darkText)),
            ],
          ),
        ),
      ),
    );
  }
}

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
            Icon(Icons.spa_rounded, size: 48, color: theme.primary),
            const SizedBox(height: 16),
            Text('Let\'s set up your goal',
                style: appCss.titleSemi18.textColor(theme.darkText)),
            const SizedBox(height: 8),
            Text('Restart onboarding to choose what you\'re working toward.',
                textAlign: TextAlign.center,
                style: appCss.body14.textColor(theme.lightText)),
          ],
        ),
      ),
    );
  }
}
