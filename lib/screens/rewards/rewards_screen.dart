import '../../common/theme/accent_palette.dart';
import '../../config.dart';
import '../../content/reward_models.dart';
import '../../providers/rewards_provider.dart';

/// Gamification surface: coin balance, achievements earned from real progress,
/// an opt-in rewarded-ad top-up, and the accent-theme shop (the only coin sink,
/// purely cosmetic). Provider is screen-scoped so achievements recompute on open.
class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RewardsProvider(),
      child: const _RewardsView(),
    );
  }
}

class _RewardsView extends StatelessWidget {
  const _RewardsView();

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    final p = context.watch<RewardsProvider>();

    return Scaffold(
      backgroundColor: theme.scaffoldBg,
      appBar: AppBar(
        title: Text('Milestones & rewards',
            style: appCss.headingBold22.textColor(theme.darkText)),
      ),
      body: p.loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                _CoinHeader(coins: p.coins, theme: theme),
                const SizedBox(height: 16),
                _EarnCard(theme: theme),
                const SizedBox(height: 24),
                Text('Achievements',
                    style: appCss.titleSemi16.textColor(theme.darkText)),
                const SizedBox(height: 4),
                Text('${p.unlockedCount} of ${p.achievements.length} unlocked',
                    style: appCss.label12.textColor(theme.lightText)),
                const SizedBox(height: 12),
                for (final a in p.achievements)
                  _AchievementRow(
                    achievement: a,
                    unlocked: p.isAchievementUnlocked(a.id),
                    theme: theme,
                  ),
                const SizedBox(height: 24),
                Text('Accent themes',
                    style: appCss.titleSemi16.textColor(theme.darkText)),
                const SizedBox(height: 4),
                Text('Spend coins on a new look. Purely cosmetic.',
                    style: appCss.label12.textColor(theme.lightText)),
                const SizedBox(height: 12),
                for (final accent in AccentPalettes.all)
                  _AccentRow(accent: accent, theme: theme),
              ],
            ),
    );
  }
}

// --- Coins ------------------------------------------------------------------

class _CoinHeader extends StatelessWidget {
  const _CoinHeader({required this.coins, required this.theme});
  final int coins;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [theme.primary, theme.primary.withValues(alpha: 0.82)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.monetization_on_rounded, color: Colors.white, size: 40),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$coins',
                  style: appCss.counterBold40.textColor(Colors.white).sized(36)),
              Text('coins earned', style: appCss.medium14.textColor(Colors.white70)),
            ],
          ),
        ],
      ),
    );
  }
}

class _EarnCard extends StatelessWidget {
  const _EarnCard({required this.theme});
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    final p = context.watch<RewardsProvider>();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.stroke),
      ),
      child: Row(
        children: [
          Icon(Icons.play_circle_outline_rounded, color: theme.primary, size: 28),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Watch a short video',
                    style: appCss.titleSemi16.textColor(theme.darkText)),
                Text('Optional — earn +10 coins',
                    style: appCss.label12.textColor(theme.lightText)),
              ],
            ),
          ),
          p.busyAd
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(strokeWidth: 2.4),
                )
              : TextButton(
                  onPressed: () => _watch(context),
                  child: Text('Watch',
                      style: appCss.buttonSemi16.textColor(theme.primary)),
                ),
        ],
      ),
    );
  }

  Future<void> _watch(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final provider = context.read<RewardsProvider>();
    if (!adService.rewardedReady) {
      messenger.showSnackBar(const SnackBar(
          content: Text('No video available right now — try again shortly.')));
      return;
    }
    final before = provider.coins;
    await provider.watchAdForCoins();
    if (provider.coins > before) {
      messenger.showSnackBar(const SnackBar(content: Text('Nice — +10 coins!')));
    }
  }
}

// --- Achievements -----------------------------------------------------------

class _AchievementRow extends StatelessWidget {
  const _AchievementRow({
    required this.achievement,
    required this.unlocked,
    required this.theme,
  });
  final Achievement achievement;
  final bool unlocked;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: unlocked ? 1 : 0.55,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: unlocked ? theme.primary : theme.stroke,
              width: unlocked ? 1.4 : 1),
        ),
        child: Row(
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: unlocked ? theme.primarySoft : theme.fieldBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                unlocked ? _iconFor(achievement.icon) : Icons.lock_outline_rounded,
                color: unlocked ? theme.primary : theme.lightText,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(achievement.title,
                      style: appCss.titleSemi16.textColor(theme.darkText)),
                  const SizedBox(height: 2),
                  Text(achievement.description,
                      style: appCss.label12.textColor(theme.lightText)),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              children: [
                Icon(Icons.monetization_on_rounded,
                    size: 16,
                    color: unlocked ? theme.warning : theme.lightText),
                Text('${achievement.coins}',
                    style: appCss.label12.textColor(theme.lightText)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

IconData _iconFor(String name) => switch (name) {
      'flag' => Icons.flag_rounded,
      'bolt' => Icons.bolt_rounded,
      'calendar' => Icons.calendar_month_rounded,
      'trending_up' => Icons.trending_up_rounded,
      'shield' => Icons.shield_rounded,
      'favorite' => Icons.favorite_rounded,
      'edit' => Icons.edit_rounded,
      'self_improvement' => Icons.self_improvement_rounded,
      'spa' => Icons.spa_rounded,
      _ => Icons.star_rounded,
    };

// --- Accent shop ------------------------------------------------------------

class _AccentRow extends StatelessWidget {
  const _AccentRow({required this.accent, required this.theme});
  final AccentPalette accent;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    final p = context.watch<RewardsProvider>();
    final themeService = context.watch<ThemeService>();
    final unlocked = p.isAccentUnlocked(accent.id);
    final selected = themeService.accentId == accent.id;
    final swatch = accent.primaryFor(theme.isDark);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: selected ? swatch : theme.stroke,
            width: selected ? 1.6 : 1),
      ),
      child: Row(
        children: [
          Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(color: swatch, shape: BoxShape.circle),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(accent.label,
                style: appCss.titleSemi16.textColor(theme.darkText)),
          ),
          _trailing(context, unlocked, selected),
        ],
      ),
    );
  }

  Widget _trailing(BuildContext context, bool unlocked, bool selected) {
    if (selected) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_rounded, color: theme.primary, size: 20),
          const SizedBox(width: 4),
          Text('Selected', style: appCss.label12.textColor(theme.primary)),
        ],
      );
    }
    if (unlocked) {
      return TextButton(
        onPressed: () => context.read<ThemeService>().setAccent(accent.id),
        child: Text('Apply', style: appCss.buttonSemi16.textColor(theme.primary)),
      );
    }
    return TextButton(
      onPressed: () => _unlock(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Unlock  ', style: appCss.buttonSemi16.textColor(theme.darkText)),
          Icon(Icons.monetization_on_rounded, size: 15, color: theme.warning),
          Text(' ${accent.cost}', style: appCss.label12.textColor(theme.lightText)),
        ],
      ),
    );
  }

  Future<void> _unlock(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final rewards = context.read<RewardsProvider>();
    final themeService = context.read<ThemeService>();
    final ok = await rewards.unlockAccent(accent);
    if (ok) {
      themeService.setAccent(accent.id); // apply immediately
    } else {
      messenger.showSnackBar(const SnackBar(
          content: Text('Not enough coins yet — keep going!')));
    }
  }
}
