import '../../config.dart';
import '../../data/collections/coping_plan.dart';
import '../../data/trigger_labels.dart';

/// The plan list, as a pure presenter: it renders whatever [plans] it's handed
/// and reports taps back. Split from [CopingPlanScreen] so it's widget-testable
/// without opening Isar — the same split the tab bodies use.
class CopingPlanBody extends StatelessWidget {
  const CopingPlanBody({
    super.key,
    required this.plans,
    required this.onEdit,
    required this.onDelete,
    required this.onHistory,
  });

  final List<CopingPlan> plans;
  final void Function(CopingPlan) onEdit;
  final void Function(CopingPlan) onDelete;
  final void Function(CopingPlan) onHistory;

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    if (plans.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            "No plans yet. After a slip, the reflection helps you pick one "
            "thing to try next time that trigger shows up — it'll appear here.",
            textAlign: TextAlign.center,
            style: appCss.body14.textColor(theme.lightText),
          ),
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        Text(
          'When one of these shows up, this is what you decided to try first.',
          style: appCss.body14.textColor(theme.lightText),
        ),
        const SizedBox(height: 20),
        for (final plan in plans)
          _PlanCard(
            plan: plan,
            theme: theme,
            onEdit: () => onEdit(plan),
            onDelete: () => onDelete(plan),
            onHistory: () => onHistory(plan),
          ),
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.plan,
    required this.theme,
    required this.onEdit,
    required this.onDelete,
    required this.onHistory,
  });

  final CopingPlan plan;
  final AppTheme theme;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onHistory;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: theme.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.stroke),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onHistory,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(triggerLabel(plan.trigger),
                          style: appCss.label12.textColor(theme.primary)),
                      const SizedBox(height: 4),
                      Text(plan.strategy,
                          style: appCss.titleSemi16.textColor(theme.darkText)),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit_outlined,
                      color: theme.lightText, size: 20),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: Icon(Icons.close_rounded,
                      color: theme.lightText, size: 20),
                  onPressed: onDelete,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
