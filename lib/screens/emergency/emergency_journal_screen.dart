import '../../config.dart';
import '../../data/enums.dart';
import '../../widgets/primary_button.dart';
import 'emergency_scaffold.dart';

/// A place to externalise an urge in the moment — writing it down often drains
/// its charge. Persists a [JournalEntry] of kind [JournalKind.emergencyJournal].
/// NO-AD route.
class EmergencyJournalScreen extends StatefulWidget {
  const EmergencyJournalScreen({super.key});

  @override
  State<EmergencyJournalScreen> createState() => _EmergencyJournalScreenState();
}

class _EmergencyJournalScreenState extends State<EmergencyJournalScreen> {
  final _controller = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      route.pop(context);
      return;
    }
    setState(() => _saving = true);
    await journalRepo.add(kind: JournalKind.emergencyJournal, text: text);
    if (!mounted) return;
    route.pop(context);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Saved. That took strength.')));
  }

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    return EmergencyScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Write it out',
              style: appCss.headingBold22.textColor(theme.darkText)),
          const SizedBox(height: 8),
          Text(
            'What are you feeling right now? What triggered it? No one else will ever read this.',
            style: appCss.body14.textColor(theme.lightText),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: TextField(
              controller: _controller,
              expands: true,
              maxLines: null,
              textAlignVertical: TextAlignVertical.top,
              style: appCss.body16.textColor(theme.darkText),
              decoration: InputDecoration(
                hintText: 'Start typing…',
                hintStyle: appCss.body16.textColor(theme.lightText),
                filled: true,
                fillColor: theme.cardBg,
                contentPadding: const EdgeInsets.all(16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: 'Save & close',
            loading: _saving,
            onPressed: _save,
          ),
        ],
      ),
    );
  }
}
