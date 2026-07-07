import '../../config.dart';
import '../../content/cbt_models.dart';
import '../../widgets/option_scale.dart';
import '../../widgets/primary_button.dart';

/// Generic CBT worksheet form. Renders any [CbtWorksheet]'s steps (text / scale
/// / choice) and saves the answers as a [CbtEntry]. Kept distraction-free (no
/// banner) — this is reflective work. Worksheet passed via route arguments.
class WorksheetScreen extends StatefulWidget {
  const WorksheetScreen({super.key});

  @override
  State<WorksheetScreen> createState() => _WorksheetScreenState();
}

class _WorksheetScreenState extends State<WorksheetScreen> {
  CbtWorksheet? _worksheet;
  final Map<String, String> _responses = {}; // scale/choice answers
  final Map<String, TextEditingController> _controllers = {};
  bool _saving = false;
  bool _init = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_init) return;
    _init = true;
    _worksheet = ModalRoute.of(context)?.settings.arguments as CbtWorksheet?;
    for (final s in _worksheet?.steps ?? const <CbtStep>[]) {
      if (s.type == 'text') _controllers[s.id] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final w = _worksheet;
    if (w == null) return;
    final responses = <String, String>{};
    for (final s in w.steps) {
      if (s.type == 'text') {
        final t = _controllers[s.id]!.text.trim();
        if (t.isNotEmpty) responses[s.id] = t;
      } else {
        final v = _responses[s.id];
        if (v != null) responses[s.id] = v;
      }
    }
    if (responses.isEmpty) {
      Navigator.pop(context);
      return;
    }
    setState(() => _saving = true);
    await cbtRepo.save(
      worksheetId: w.id,
      title: w.title,
      exercise: w.exercise,
      responses: responses,
    );
    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Saved. Well done doing the work.')));
  }

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    final w = _worksheet;
    if (w == null) {
      return Scaffold(appBar: AppBar(), body: const SizedBox.shrink());
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBg,
      appBar: AppBar(
        title: Text(w.title,
            style: appCss.titleSemi18.textColor(theme.darkText)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        children: [
          if (w.intro.isNotEmpty) ...[
            Text(w.intro, style: appCss.body14.textColor(theme.lightText)),
            const SizedBox(height: 24),
          ],
          for (final step in w.steps) ...[
            _StepField(
              step: step,
              controller: _controllers[step.id],
              selected: _responses[step.id],
              theme: theme,
              onChanged: (v) => setState(() => _responses[step.id] = v),
            ),
            const SizedBox(height: 24),
          ],
          PrimaryButton(label: 'Save', loading: _saving, onPressed: _save),
        ],
      ),
    );
  }
}

class _StepField extends StatelessWidget {
  const _StepField({
    required this.step,
    required this.controller,
    required this.selected,
    required this.onChanged,
    required this.theme,
  });
  final CbtStep step;
  final TextEditingController? controller;
  final String? selected;
  final ValueChanged<String> onChanged;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    switch (step.type) {
      case 'scale':
        return OptionScale(
          prompt: step.prompt,
          options: [for (var i = 0; i <= step.max; i++) '$i'],
          selectedIndex: selected == null ? null : int.tryParse(selected!),
          onSelected: (i) => onChanged('$i'),
        );
      case 'choice':
        return OptionScale(
          prompt: step.prompt,
          options: step.options,
          selectedIndex:
              selected == null ? null : step.options.indexOf(selected!),
          onSelected: (i) => onChanged(step.options[i]),
        );
      default: // text
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(step.prompt,
                style: appCss.titleSemi16.textColor(theme.darkText)),
            const SizedBox(height: 10),
            TextField(
              controller: controller,
              maxLines: 4,
              minLines: 2,
              style: appCss.body16.textColor(theme.darkText),
              decoration: InputDecoration(
                hintText: step.hint.isEmpty ? 'Your answer…' : step.hint,
                hintStyle: appCss.body14.textColor(theme.lightText),
                filled: true,
                fillColor: theme.cardBg,
                contentPadding: const EdgeInsets.all(14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: theme.stroke),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: theme.stroke),
                ),
              ),
            ),
          ],
        );
    }
  }
}
