import '../../config.dart';
import '../../data/collections/habit_definition.dart';
import '../../data/enums.dart';
import '../../providers/habit_provider.dart';
import '../../widgets/ad/banner_ad_widget.dart';

/// Preset label + icon for each [HabitType].
({String label, IconData icon}) habitPreset(HabitType t) {
  switch (t) {
    case HabitType.exercise:
      return (label: 'Exercise', icon: Icons.fitness_center_rounded);
    case HabitType.reading:
      return (label: 'Reading', icon: Icons.menu_book_rounded);
    case HabitType.meditation:
      return (label: 'Meditation', icon: Icons.self_improvement_rounded);
    case HabitType.prayer:
      return (label: 'Prayer', icon: Icons.volunteer_activism_rounded);
    case HabitType.sleep:
      return (label: 'Good sleep', icon: Icons.bedtime_rounded);
    case HabitType.water:
      return (label: 'Drink water', icon: Icons.water_drop_rounded);
    case HabitType.eating:
      return (label: 'Eat well', icon: Icons.restaurant_rounded);
    case HabitType.social:
      return (label: 'Connect', icon: Icons.groups_rounded);
    case HabitType.walk:
      return (label: 'Walk', icon: Icons.directions_walk_rounded);
    case HabitType.gratitude:
      return (label: 'Gratitude', icon: Icons.favorite_rounded);
  }
}

/// Habit tracker: today's habits with a tap-to-complete check, current streak,
/// and a 7-day strip. Non-crisis screen — banner allowed.
class HabitsScreen extends StatelessWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HabitProvider(),
      child: const _HabitsView(),
    );
  }
}

class _HabitsView extends StatelessWidget {
  const _HabitsView();

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    final p = context.watch<HabitProvider>();

    return Scaffold(
      backgroundColor: theme.scaffoldBg,
      appBar: AppBar(
        title: Text('Habits',
            style: appCss.headingBold22.textColor(theme.darkText)),
        actions: [
          IconButton(
            icon: Icon(Icons.add_rounded, color: theme.primary),
            onPressed: () => _showAddSheet(context, p),
          ),
        ],
      ),
      body: p.loading
          ? const Center(child: CircularProgressIndicator())
          : p.habits.isEmpty
              ? _EmptyState(theme: theme, onAdd: () => _showAddSheet(context, p))
              : ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  children: [
                    Text('Small daily wins compound. Tap when you do one.',
                        style: appCss.body14.textColor(theme.lightText)),
                    const SizedBox(height: 16),
                    for (final h in p.habits)
                      _HabitCard(
                        habit: h,
                        done: p.doneToday.contains(h.id),
                        streak: p.streaks[h.id] ?? 0,
                        doneDays: p.doneDaysByHabit[h.id] ?? const {},
                        today: p.today,
                        theme: theme,
                        onToggle: () => p.toggle(h.id),
                      ),
                    const SizedBox(height: 12),
                    const Center(child: BannerAdWidget()),
                  ],
                ),
    );
  }

  void _showAddSheet(BuildContext context, HabitProvider p) {
    final theme = appColorRead(context);
    final existing = p.habits.map((h) => h.type).toSet();
    final available =
        HabitType.values.where((t) => !existing.contains(t)).toList();
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.scaffoldBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add a habit',
                style: appCss.headingBold22.textColor(theme.darkText)),
            const SizedBox(height: 16),
            if (available.isEmpty)
              Text('You’re tracking all the built-in habits already.',
                  style: appCss.body14.textColor(theme.lightText))
            else
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final t in available)
                    ActionChip(
                      avatar: Icon(habitPreset(t).icon,
                          size: 18, color: theme.primary),
                      label: Text(habitPreset(t).label,
                          style: appCss.medium14.textColor(theme.darkText)),
                      backgroundColor: theme.cardBg,
                      side: BorderSide(color: theme.stroke),
                      onPressed: () {
                        p.addHabit(t, habitPreset(t).label);
                        Navigator.pop(context);
                      },
                    ),
                ],
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _HabitCard extends StatelessWidget {
  const _HabitCard({
    required this.habit,
    required this.done,
    required this.streak,
    required this.doneDays,
    required this.today,
    required this.onToggle,
    required this.theme,
  });
  final HabitDefinition habit;
  final bool done;
  final int streak;
  final Set<int> doneDays;
  final int today;
  final VoidCallback onToggle;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    final preset = habitPreset(habit.type);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.stroke),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(preset.icon, color: theme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(habit.title,
                        style: appCss.titleSemi16.textColor(theme.darkText)),
                    if (streak > 0)
                      Text('🔥 $streak day${streak == 1 ? '' : 's'}',
                          style: appCss.label12.textColor(theme.lightText)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onToggle,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  height: 34,
                  width: 34,
                  decoration: BoxDecoration(
                    color: done ? theme.primary : theme.fieldBg,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: done ? theme.primary : theme.stroke, width: 2),
                  ),
                  child: done
                      ? const Icon(Icons.check_rounded,
                          color: Colors.white, size: 20)
                      : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var i = 6; i >= 0; i--)
                _DayDot(
                  filled: doneDays.contains(today - i),
                  isToday: i == 0,
                  theme: theme,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DayDot extends StatelessWidget {
  const _DayDot(
      {required this.filled, required this.isToday, required this.theme});
  final bool filled;
  final bool isToday;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 14,
      width: 14,
      decoration: BoxDecoration(
        color: filled ? theme.primary : theme.fieldBg,
        shape: BoxShape.circle,
        border: isToday ? Border.all(color: theme.primary, width: 1.5) : null,
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.theme, required this.onAdd});
  final AppTheme theme;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.task_alt_rounded, size: 48, color: theme.primary),
            const SizedBox(height: 16),
            Text('Build a life fuller than the habit you’re leaving',
                textAlign: TextAlign.center,
                style: appCss.titleSemi18.textColor(theme.darkText)),
            const SizedBox(height: 8),
            Text('Add a few healthy habits to grow alongside your recovery.',
                textAlign: TextAlign.center,
                style: appCss.body14.textColor(theme.lightText)),
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: onAdd,
              icon: Icon(Icons.add_rounded, color: theme.primary),
              label: Text('Add a habit',
                  style: appCss.buttonSemi16.textColor(theme.primary)),
            ),
          ],
        ),
      ),
    );
  }
}
