import '../../config.dart';
import '../../data/enums.dart';
import '../../data/trigger_labels.dart';
import '../../providers/dashboard_provider.dart';
import '../../widgets/option_scale.dart';
import '../../widgets/primary_button.dart';

/// Opens the "log an urge" sheet. Captures intensity, outcome and optional
/// triggers/note, then writes a [TrackerEvent] via the dashboard provider.
Future<void> showLogUrgeSheet(BuildContext context) {
  final provider = context.read<DashboardProvider>();
  return _showSheet<void>(
    context,
    ChangeNotifierProvider.value(
      value: provider,
      child: const _LogUrgeSheet(),
    ),
  );
}

/// Opens the compassionate "I slipped" sheet. Frames the lapse as learning,
/// never failure, then appends it (the score barely moves). Resolves to `true`
/// once a lapse is actually saved, so the caller can offer the relapse-
/// reflection coach flow.
Future<bool?> showSlipSheet(BuildContext context) {
  final provider = context.read<DashboardProvider>();
  return _showSheet<bool>(
    context,
    ChangeNotifierProvider.value(
      value: provider,
      child: const _SlipSheet(),
    ),
  );
}

Future<T?> _showSheet<T>(BuildContext context, Widget child) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => child,
  );
}

/// Shared rounded container that lifts above the keyboard.
class _SheetShell extends StatelessWidget {
  const _SheetShell({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: theme.stroke,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                ...children,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- Urge log ---------------------------------------------------------------

class _LogUrgeSheet extends StatefulWidget {
  const _LogUrgeSheet();

  @override
  State<_LogUrgeSheet> createState() => _LogUrgeSheetState();
}

class _LogUrgeSheetState extends State<_LogUrgeSheet> {
  int _intensity = 5;
  Outcome? _outcome;
  final Set<TriggerType> _triggers = {};
  final _noteController = TextEditingController();
  bool _saving = false;

  static const _outcomeOptions = <(Outcome, String)>[
    (Outcome.resisted, 'I resisted'),
    (Outcome.surfed, 'I rode it out'),
    (Outcome.delayed, 'I delayed it'),
    (Outcome.lapse, 'I acted on it'),
  ];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await context.read<DashboardProvider>().logUrge(
          outcome: _outcome ?? Outcome.resisted,
          intensity: _intensity,
          triggers: _triggers.toList(),
          note: _noteController.text.trim().isEmpty
              ? null
              : _noteController.text.trim(),
        );
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    return _SheetShell(
      children: [
        Text('Log an urge',
            style: appCss.headingBold22.textColor(theme.darkText)),
        const SizedBox(height: 6),
        Text('Noticing an urge is a skill. Well done for pausing.',
            style: appCss.body14.textColor(theme.lightText)),
        const SizedBox(height: 24),
        OptionScale(
          prompt: 'How strong is it?',
          options: const ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10'],
          selectedIndex: _intensity,
          onSelected: (v) => setState(() => _intensity = v),
        ),
        const SizedBox(height: 24),
        OptionScale(
          prompt: 'What happened?',
          options: [for (final o in _outcomeOptions) o.$2],
          selectedIndex:
              _outcome == null ? null : _outcomeOptions.indexWhere((o) => o.$1 == _outcome),
          onSelected: (i) => setState(() => _outcome = _outcomeOptions[i].$1),
        ),
        const SizedBox(height: 24),
        Text('What triggered it? (optional)',
            style: appCss.titleSemi16.textColor(theme.darkText)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final t in quickTriggers)
              _MultiChip(
                label: triggerLabel(t),
                selected: _triggers.contains(t),
                theme: theme,
                onTap: () => setState(() {
                  _triggers.contains(t)
                      ? _triggers.remove(t)
                      : _triggers.add(t);
                }),
              ),
          ],
        ),
        const SizedBox(height: 20),
        _NoteField(controller: _noteController, theme: theme),
        const SizedBox(height: 24),
        PrimaryButton(
          label: 'Save',
          loading: _saving,
          onPressed: _save,
        ),
      ],
    );
  }
}

// --- Slip log ---------------------------------------------------------------

class _SlipSheet extends StatefulWidget {
  const _SlipSheet();

  @override
  State<_SlipSheet> createState() => _SlipSheetState();
}

class _SlipSheetState extends State<_SlipSheet> {
  final Set<TriggerType> _triggers = {};
  final _noteController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await context.read<DashboardProvider>().logLapse(
          triggers: _triggers.toList(),
          note: _noteController.text.trim().isEmpty
              ? null
              : _noteController.text.trim(),
        );
    if (!mounted) return;
    // Signal the caller a lapse was saved so it can offer relapse reflection.
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    return _SheetShell(
      children: [
        Text('This is a moment, not a verdict',
            style: appCss.headingBold22.textColor(theme.darkText)),
        const SizedBox(height: 8),
        Text(
          'Logging a slip takes courage. Your day-count restarts, but the progress you\'ve built stays with you. Let\'s learn what led here.',
          style: appCss.body14.textColor(theme.lightText),
        ),
        const SizedBox(height: 24),
        Text('What led up to it? (optional)',
            style: appCss.titleSemi16.textColor(theme.darkText)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final t in quickTriggers)
              _MultiChip(
                label: triggerLabel(t),
                selected: _triggers.contains(t),
                theme: theme,
                onTap: () => setState(() {
                  _triggers.contains(t)
                      ? _triggers.remove(t)
                      : _triggers.add(t);
                }),
              ),
          ],
        ),
        const SizedBox(height: 20),
        _NoteField(controller: _noteController, theme: theme),
        const SizedBox(height: 24),
        PrimaryButton(
          label: 'Log it with kindness',
          loading: _saving,
          onPressed: _save,
        ),
      ],
    );
  }
}

// --- Shared field / chip ----------------------------------------------------

class _NoteField extends StatelessWidget {
  const _NoteField({required this.controller, required this.theme});
  final TextEditingController controller;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 3,
      minLines: 2,
      style: appCss.body14.textColor(theme.darkText),
      decoration: InputDecoration(
        hintText: 'Add a note (optional)',
        hintStyle: appCss.body14.textColor(theme.lightText),
        filled: true,
        fillColor: theme.fieldBg,
        contentPadding: const EdgeInsets.all(14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _MultiChip extends StatelessWidget {
  const _MultiChip({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.theme,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? theme.primary : theme.fieldBg,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Text(
            label,
            style: appCss.medium14
                .textColor(selected ? Colors.white : theme.darkText),
          ),
        ),
      ),
    );
  }
}
