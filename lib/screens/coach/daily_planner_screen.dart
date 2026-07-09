import 'dart:convert';

import '../../config.dart';
import '../../data/time_buckets.dart';
import '../../widgets/ad/banner_ad_widget.dart';

/// A light daily planner: a handful of intentions for *today*. This is a single
/// current-day scalar (it resets each morning), so per the prefs-vs-Isar rule it
/// lives in SharedPreferences as one JSON blob rather than in the database.
class DailyPlannerScreen extends StatefulWidget {
  const DailyPlannerScreen({super.key});

  @override
  State<DailyPlannerScreen> createState() => _DailyPlannerScreenState();
}

class _PlanItem {
  _PlanItem(this.text, this.done);
  final String text;
  bool done;

  Map<String, dynamic> toJson() => {'t': text, 'd': done};
  factory _PlanItem.fromJson(Map<String, dynamic> j) =>
      _PlanItem(j['t'] as String? ?? '', j['d'] as bool? ?? false);
}

class _DailyPlannerScreenState extends State<DailyPlannerScreen> {
  final List<_PlanItem> _items = [];
  final _controller = TextEditingController();

  static const _suggestions = [
    'Move my body',
    'Reach out to someone',
    'No screens in bed',
    '5 minutes of stillness',
    'Get outside',
    'Sleep by 11pm',
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _load() {
    final raw = prefs.getString(session.dailyPlan);
    if (raw == null) return;
    try {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      // A plan from a previous day starts fresh — today is a clean slate.
      if ((data['day'] as num?)?.toInt() != TimeBuckets.todayEpochDay()) return;
      final items = (data['items'] as List?) ?? const [];
      _items.addAll(
        items.map((e) => _PlanItem.fromJson(e as Map<String, dynamic>)),
      );
      setState(() {});
    } catch (_) {
      // Corrupt blob → start empty rather than crash.
    }
  }

  Future<void> _save() async {
    final data = {
      'day': TimeBuckets.todayEpochDay(),
      'items': _items.map((e) => e.toJson()).toList(),
    };
    await prefs.setString(session.dailyPlan, jsonEncode(data));
  }

  void _add(String text) {
    final t = text.trim();
    if (t.isEmpty) return;
    setState(() => _items.add(_PlanItem(t, false)));
    _controller.clear();
    _save();
  }

  void _toggle(int i) {
    setState(() => _items[i].done = !_items[i].done);
    _save();
  }

  void _remove(int i) {
    setState(() => _items.removeAt(i));
    _save();
  }

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    final doneCount = _items.where((e) => e.done).length;

    return Scaffold(
      backgroundColor: theme.scaffoldBg,
      appBar: AppBar(
        title: Text("Today's plan",
            style: appCss.headingBold22.textColor(theme.darkText)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Text(
            _items.isEmpty
                ? 'A few small intentions for today. Keep it gentle and doable.'
                : '$doneCount of ${_items.length} done — every one counts.',
            style: appCss.body14.textColor(theme.lightText),
          ),
          const SizedBox(height: 20),
          for (var i = 0; i < _items.length; i++)
            _PlanRow(
              item: _items[i],
              theme: theme,
              onToggle: () => _toggle(i),
              onRemove: () => _remove(i),
            ),
          const SizedBox(height: 8),
          _AddField(controller: _controller, theme: theme, onAdd: _add),
          const SizedBox(height: 20),
          Text('Ideas', style: appCss.titleSemi16.textColor(theme.darkText)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final s in _suggestions)
                _SuggestionChip(label: s, theme: theme, onTap: () => _add(s)),
            ],
          ),
          const SizedBox(height: 24),
          const Center(child: BannerAdWidget()),
        ],
      ),
    );
  }
}

class _PlanRow extends StatelessWidget {
  const _PlanRow({
    required this.item,
    required this.theme,
    required this.onToggle,
    required this.onRemove,
  });
  final _PlanItem item;
  final AppTheme theme;
  final VoidCallback onToggle;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: theme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.stroke),
      ),
      child: ListTile(
        onTap: onToggle,
        leading: Icon(
          item.done
              ? Icons.check_circle_rounded
              : Icons.radio_button_unchecked_rounded,
          color: item.done ? theme.primary : theme.lightText,
        ),
        title: Text(
          item.text,
          style: appCss.body14.textColor(theme.darkText).copyWith(
                decoration: item.done ? TextDecoration.lineThrough : null,
                color: item.done ? theme.lightText : theme.darkText,
              ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.close_rounded, color: theme.lightText, size: 20),
          onPressed: onRemove,
        ),
      ),
    );
  }
}

class _AddField extends StatelessWidget {
  const _AddField(
      {required this.controller, required this.theme, required this.onAdd});
  final TextEditingController controller;
  final AppTheme theme;
  final void Function(String) onAdd;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            textCapitalization: TextCapitalization.sentences,
            style: appCss.body14.textColor(theme.darkText),
            decoration: InputDecoration(
              hintText: 'Add an intention…',
              hintStyle: appCss.body14.textColor(theme.lightText),
              filled: true,
              fillColor: theme.fieldBg,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
            onSubmitted: onAdd,
          ),
        ),
        const SizedBox(width: 10),
        Material(
          color: theme.primary,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => onAdd(controller.text),
            child: const Padding(
              padding: EdgeInsets.all(14),
              child: Icon(Icons.add_rounded, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip(
      {required this.label, required this.theme, required this.onTap});
  final String label;
  final AppTheme theme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: theme.fieldBg,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_rounded, size: 16, color: theme.primary),
              const SizedBox(width: 6),
              Text(label, style: appCss.medium14.textColor(theme.darkText)),
            ],
          ),
        ),
      ),
    );
  }
}
