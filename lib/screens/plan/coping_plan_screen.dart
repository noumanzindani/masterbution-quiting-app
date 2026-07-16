import '../../config.dart';
import '../../data/collections/coping_plan.dart';
import '../../data/trigger_labels.dart';
import 'coping_plan_body.dart';

/// Your standing coping plans. NO-AD route: the panic hub links straight here,
/// so a banner would sit one tap from the panic button.
class CopingPlanScreen extends StatefulWidget {
  const CopingPlanScreen({super.key});

  @override
  State<CopingPlanScreen> createState() => _CopingPlanScreenState();
}

class _CopingPlanScreenState extends State<CopingPlanScreen> {
  List<CopingPlan> _plans = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final plans = await copingPlanRepo.active();
    if (!mounted) return;
    setState(() {
      _plans = plans;
      _loading = false;
    });
  }

  Future<void> _edit(CopingPlan plan) async {
    final controller = TextEditingController(text: plan.strategy);
    final theme = appColor(context);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: theme.cardBg,
        title: Text('When ${triggerLabel(plan.trigger).toLowerCase()} shows up',
            style: appCss.titleSemi16.textColor(theme.darkText)),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: appCss.body14.textColor(theme.darkText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (result == null || result.isEmpty) return;
    await copingPlanRepo.edit(plan.id, result);
    await _load();
  }

  Future<void> _delete(CopingPlan plan) async {
    await copingPlanRepo.remove(plan.id);
    await _load();
  }

  /// What you've tried for this trigger over time. Superseded strategies are
  /// kept precisely so this reads as evidence — "breathing didn't hold for
  /// stress; reaching out did" — rather than a plan appearing from nowhere.
  Future<void> _history(CopingPlan plan) async {
    final history = await copingPlanRepo.historyFor(plan.trigger);
    if (!mounted) return;
    final theme = appColor(context);
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: theme.scaffoldBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('When ${triggerLabel(plan.trigger).toLowerCase()} shows up',
                  style: appCss.titleSemi18.textColor(theme.darkText)),
              const SizedBox(height: 16),
              for (final h in history)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        h.supersededAtUtc == null
                            ? Icons.check_circle_rounded
                            : Icons.history_rounded,
                        size: 18,
                        color: h.supersededAtUtc == null
                            ? theme.primary
                            : theme.lightText,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          h.supersededAtUtc == null
                              ? '${h.strategy} — your plan now'
                              : '${h.strategy} — until '
                                  '${h.supersededAtUtc!.toLocal().year}-'
                                  '${h.supersededAtUtc!.toLocal().month.toString().padLeft(2, '0')}-'
                                  '${h.supersededAtUtc!.toLocal().day.toString().padLeft(2, '0')}',
                          style: appCss.body14.textColor(
                            h.supersededAtUtc == null
                                ? theme.darkText
                                : theme.lightText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBg,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBg,
        title: Text('My coping plans',
            style: appCss.headingBold22.textColor(theme.darkText)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : CopingPlanBody(
              plans: _plans,
              onEdit: _edit,
              onDelete: _delete,
              onHistory: _history,
            ),
    );
  }
}
