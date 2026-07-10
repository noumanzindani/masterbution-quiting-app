import '../../config.dart';
import '../../services/export_service.dart';
import '../../widgets/ad/banner_ad_widget.dart';
import '../../widgets/primary_button.dart';

/// Encrypted backup + restore. Export gathers the local database into a
/// passphrase-encrypted file handed to the OS share sheet (Files, email, etc.);
/// restore takes a pasted backup + its passphrase. A non-crisis screen, banner
/// allowed.
class BackupScreen extends StatefulWidget {
  const BackupScreen({super.key});

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  final _exportPass = TextEditingController();
  final _importText = TextEditingController();
  final _importPass = TextEditingController();
  bool _includePrivate = true;
  bool _busy = false;

  @override
  void dispose() {
    _exportPass.dispose();
    _importText.dispose();
    _importPass.dispose();
    super.dispose();
  }

  /// Core stats always travel; private text (journals, mood notes, CBT work) is
  /// opt-in, so a therapist export can be stats-only if the user prefers.
  Set<String> get _sections {
    final all = ExportSections.all.toSet();
    if (!_includePrivate) {
      all.removeAll(
          [ExportSections.journal, ExportSections.mood, ExportSections.cbt]);
    }
    return all;
  }

  Future<void> _export() async {
    if (_exportPass.text.trim().length < 4) {
      _toast('Choose a passphrase of at least 4 characters.');
      return;
    }
    setState(() => _busy = true);
    try {
      await ExportService.shareBackup(
        include: _sections,
        passphrase: _exportPass.text,
        now: DateTime.now(),
      );
    } catch (_) {
      _toast('Couldn\'t create the backup. Please try again.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _import() async {
    if (_importText.text.trim().isEmpty) {
      _toast('Paste your backup text first.');
      return;
    }
    setState(() => _busy = true);
    try {
      final count = await ExportService.restoreFromPayload(
          _importText.text, _importPass.text);
      if (mounted) {
        _toast('Restored $count items. Reopen the app to see everything.');
        _importText.clear();
        _importPass.clear();
      }
    } catch (e) {
      _toast('$e'.replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _toast(String msg) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBg,
      appBar: AppBar(
        title: Text('Backup & export',
            style: appCss.headingBold22.textColor(theme.darkText).sized(20)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Text(
            'Your data never leaves this device on its own. A backup is an '
            'encrypted file you choose to save or share — for example, to move '
            'to a new phone or hand progress to a therapist.',
            style: appCss.body14.textColor(theme.lightText),
          ),
          const SizedBox(height: 24),
          _Card(theme: theme, children: [
            Text('Create a backup',
                style: appCss.titleSemi16.textColor(theme.darkText)),
            const SizedBox(height: 12),
            _Field(
              controller: _exportPass,
              hint: 'Choose a passphrase',
              theme: theme,
              obscure: true,
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _includePrivate,
              activeThumbColor: theme.primary,
              onChanged: (v) => setState(() => _includePrivate = v),
              title: Text('Include private journals & notes',
                  style: appCss.body14.textColor(theme.darkText)),
              subtitle: Text('Off = share progress stats only',
                  style: appCss.label12.textColor(theme.lightText)),
            ),
            const SizedBox(height: 8),
            PrimaryButton(
              label: _busy ? 'Working…' : 'Export encrypted backup',
              onPressed: _busy ? null : _export,
            ),
            const SizedBox(height: 8),
            Text(
              'Keep your passphrase safe — without it the backup can\'t be '
              'restored. We can\'t recover it for you.',
              style: appCss.label12.textColor(theme.lightText),
            ),
          ]),
          const SizedBox(height: 20),
          _Card(theme: theme, children: [
            Text('Restore from a backup',
                style: appCss.titleSemi16.textColor(theme.darkText)),
            const SizedBox(height: 4),
            Text('Restoring replaces the data currently on this device.',
                style: appCss.label12.textColor(theme.lightText)),
            const SizedBox(height: 12),
            _Field(
              controller: _importText,
              hint: 'Paste your backup text here',
              theme: theme,
              maxLines: 4,
            ),
            const SizedBox(height: 8),
            _Field(
              controller: _importPass,
              hint: 'Backup passphrase',
              theme: theme,
              obscure: true,
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              label: _busy ? 'Working…' : 'Restore',
              onPressed: _busy ? null : _import,
            ),
          ]),
          const SizedBox(height: 16),
          const Center(child: BannerAdWidget()),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.children, required this.theme});
  final List<Widget> children;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.stroke),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.hint,
    required this.theme,
    this.obscure = false,
    this.maxLines = 1,
  });
  final TextEditingController controller;
  final String hint;
  final AppTheme theme;
  final bool obscure;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      maxLines: obscure ? 1 : maxLines,
      style: appCss.body14.textColor(theme.darkText),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: appCss.label12.textColor(theme.lightText),
        filled: true,
        fillColor: theme.scaffoldBg,
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
}
