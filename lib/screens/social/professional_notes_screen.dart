import '../../config.dart';
import '../../data/collections/session_note.dart';
import '../../widgets/ad/banner_ad_widget.dart';
import '../../widgets/primary_button.dart';

/// Private session-notes + homework for people working with a therapist or
/// counsellor. Local-only, included in the encrypted backup.
class ProfessionalNotesScreen extends StatefulWidget {
  const ProfessionalNotesScreen({super.key});

  @override
  State<ProfessionalNotesScreen> createState() =>
      _ProfessionalNotesScreenState();
}

class _ProfessionalNotesScreenState extends State<ProfessionalNotesScreen> {
  List<SessionNote> _notes = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    _notes = await sessionNoteRepo.recent();
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _addSheet() async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AddNoteSheet(),
    );
    if (saved == true) _load();
  }

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBg,
      appBar: AppBar(
        title: Text('Therapy notes',
            style: appCss.headingBold22.textColor(theme.darkText).sized(20)),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: theme.primary,
        onPressed: _addSheet,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('Add note',
            style: appCss.buttonSemi16.textColor(Colors.white)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
              children: [
                Text(
                  'A private place for what came up in a session and any '
                  'homework to try. Stays on your device; travels only in your '
                  'encrypted backup.',
                  style: appCss.body14.textColor(theme.lightText),
                ),
                const SizedBox(height: 20),
                if (_notes.isEmpty)
                  Text('No notes yet. Tap “Add note” after your next session.',
                      style: appCss.label12.textColor(theme.lightText))
                else
                  for (final n in _notes)
                    _NoteCard(note: n, theme: theme, onToggle: (v) async {
                      await sessionNoteRepo.setHomeworkDone(n.id, v);
                      _load();
                    }),
                const SizedBox(height: 16),
                const Center(child: BannerAdWidget()),
              ],
            ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard(
      {required this.note, required this.theme, required this.onToggle});
  final SessionNote note;
  final AppTheme theme;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(note.title,
              style: appCss.titleSemi16.textColor(theme.darkText)),
          if (note.note.trim().isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(note.note, style: appCss.body14.textColor(theme.lightText)),
          ],
          if (note.homework != null && note.homework!.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            InkWell(
              onTap: () => onToggle(!note.homeworkDone),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    note.homeworkDone
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: note.homeworkDone ? theme.primary : theme.lightText,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text('Homework: ${note.homework}',
                        style: appCss.label12
                            .textColor(theme.darkText)
                            .sized(13)),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AddNoteSheet extends StatefulWidget {
  const _AddNoteSheet();
  @override
  State<_AddNoteSheet> createState() => _AddNoteSheetState();
}

class _AddNoteSheetState extends State<_AddNoteSheet> {
  final _title = TextEditingController();
  final _note = TextEditingController();
  final _homework = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _note.dispose();
    _homework.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_title.text.trim().isEmpty) return;
    await sessionNoteRepo.add(
      title: _title.text.trim(),
      note: _note.text.trim(),
      homework: _homework.text.trim().isEmpty ? null : _homework.text.trim(),
    );
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('New session note',
                    style: appCss.headingBold22.textColor(theme.darkText)),
                const SizedBox(height: 16),
                _F(controller: _title, hint: 'Title (e.g. Session with Dr. …)', theme: theme),
                const SizedBox(height: 10),
                _F(controller: _note, hint: 'What came up?', theme: theme, lines: 4),
                const SizedBox(height: 10),
                _F(controller: _homework, hint: 'Homework (optional)', theme: theme, lines: 2),
                const SizedBox(height: 16),
                PrimaryButton(label: 'Save note', onPressed: _save),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _F extends StatelessWidget {
  const _F({
    required this.controller,
    required this.hint,
    required this.theme,
    this.lines = 1,
  });
  final TextEditingController controller;
  final String hint;
  final AppTheme theme;
  final int lines;

  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        maxLines: lines,
        style: appCss.body14.textColor(theme.darkText),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: appCss.label12.textColor(theme.lightText),
          filled: true,
          fillColor: theme.cardBg,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.stroke),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.stroke),
          ),
        ),
      );
}
