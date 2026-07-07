import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';

import '../../config.dart';
import '../../data/collections/mood_entry.dart';
import '../../providers/mood_provider.dart';
import '../../services/media_service.dart';
import '../../widgets/ad/banner_ad_widget.dart';
import '../../widgets/primary_button.dart';

/// Mood faces for the 1–5 scale.
const List<({int value, String emoji, String label})> moodFaces = [
  (value: 1, emoji: '😞', label: 'Very low'),
  (value: 2, emoji: '😕', label: 'Low'),
  (value: 3, emoji: '😐', label: 'Okay'),
  (value: 4, emoji: '🙂', label: 'Good'),
  (value: 5, emoji: '😄', label: 'Great'),
];

const List<String> moodTags = [
  'Anxious', 'Stressed', 'Lonely', 'Bored', 'Angry',
  'Calm', 'Happy', 'Tired', 'Motivated', 'Urge',
];

String moodEmoji(int mood) =>
    moodFaces.firstWhere((f) => f.value == mood, orElse: () => moodFaces[2]).emoji;

/// Mood journal: log how you feel (rating + tags + note) and review past
/// entries. Non-crisis screen — banner allowed.
class MoodJournalScreen extends StatelessWidget {
  const MoodJournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MoodProvider(),
      child: const _MoodView(),
    );
  }
}

class _MoodView extends StatelessWidget {
  const _MoodView();

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    final p = context.watch<MoodProvider>();

    return Scaffold(
      backgroundColor: theme.scaffoldBg,
      appBar: AppBar(
        title: Text('Mood journal',
            style: appCss.headingBold22.textColor(theme.darkText)),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: theme.primary,
        onPressed: () => _showAddSheet(context, p),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text('Log mood',
            style: appCss.buttonSemi16.textColor(Colors.white)),
      ),
      body: p.loading
          ? const Center(child: CircularProgressIndicator())
          : p.entries.isEmpty
              ? _EmptyState(theme: theme)
              : ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 90),
                  children: [
                    for (final e in p.entries)
                      _MoodCard(entry: e, theme: theme),
                    const SizedBox(height: 12),
                    const Center(child: BannerAdWidget()),
                  ],
                ),
    );
  }

  Future<void> _showAddSheet(BuildContext context, MoodProvider p) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChangeNotifierProvider.value(
        value: p,
        child: const _AddMoodSheet(),
      ),
    );
  }
}

class _MoodCard extends StatelessWidget {
  const _MoodCard({required this.entry, required this.theme});
  final MoodEntry entry;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    final local = entry.timestampUtc.toLocal();
    final date = '${local.day}/${local.month}';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.stroke),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(moodEmoji(entry.mood), style: const TextStyle(fontSize: 30)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(date, style: appCss.label12.textColor(theme.lightText)),
                if (entry.tags.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final t in entry.tags)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: theme.primarySoft,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(t,
                              style:
                                  appCss.label12.textColor(theme.darkText)),
                        ),
                    ],
                  ),
                ],
                if (entry.note != null && entry.note!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(entry.note!,
                      style: appCss.body14.textColor(theme.darkText)),
                ],
                if (MediaService.exists(entry.photoPath)) ...[
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(File(entry.photoPath!),
                        height: 120, width: double.infinity, fit: BoxFit.cover),
                  ),
                ],
                if (MediaService.exists(entry.voicePath)) ...[
                  const SizedBox(height: 10),
                  _VoiceButton(path: entry.voicePath!, theme: theme),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A pill button for attaching voice/photo in the add sheet.
class _MediaButton extends StatelessWidget {
  const _MediaButton({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
    required this.theme,
  });
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? theme.primarySoft : theme.fieldBg,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: theme.primary),
              const SizedBox(width: 8),
              Text(label, style: appCss.medium14.textColor(theme.darkText)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Tap-to-play voice note, owning its own [AudioPlayer].
class _VoiceButton extends StatefulWidget {
  const _VoiceButton({required this.path, required this.theme});
  final String path;
  final AppTheme theme;

  @override
  State<_VoiceButton> createState() => _VoiceButtonState();
}

class _VoiceButtonState extends State<_VoiceButton> {
  final _player = AudioPlayer();
  bool _playing = false;

  @override
  void initState() {
    super.initState();
    _player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _playing = false);
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _toggle() async {
    if (_playing) {
      await _player.stop();
      setState(() => _playing = false);
    } else {
      await _player.play(DeviceFileSource(widget.path));
      setState(() => _playing = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    return GestureDetector(
      onTap: _toggle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: theme.primarySoft,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_playing ? Icons.stop_rounded : Icons.play_arrow_rounded,
                color: theme.primary, size: 22),
            const SizedBox(width: 8),
            Text(_playing ? 'Playing…' : 'Voice note',
                style: appCss.medium14.textColor(theme.darkText)),
          ],
        ),
      ),
    );
  }
}

class _AddMoodSheet extends StatefulWidget {
  const _AddMoodSheet();

  @override
  State<_AddMoodSheet> createState() => _AddMoodSheetState();
}

class _AddMoodSheetState extends State<_AddMoodSheet> {
  int _mood = 3;
  final Set<String> _tags = {};
  final _noteController = TextEditingController();
  bool _saving = false;

  final _recorder = AudioRecorder();
  bool _recording = false;
  String? _voicePath;
  String? _photoPath;

  @override
  void dispose() {
    _noteController.dispose();
    _recorder.dispose();
    super.dispose();
  }

  Future<void> _toggleRecord() async {
    if (_recording) {
      await _recorder.stop();
      setState(() => _recording = false);
      return;
    }
    try {
      if (!await _recorder.hasPermission()) {
        _toast('Microphone permission is needed for voice notes.');
        return;
      }
      // Discard any previous take before starting a new one.
      await MediaService.delete(_voicePath);
      final path = await MediaService.newAudioPath();
      await _recorder.start(const RecordConfig(encoder: AudioEncoder.aacLc),
          path: path);
      setState(() {
        _recording = true;
        _voicePath = path;
      });
    } catch (_) {
      _toast('Couldn’t start recording on this device.');
    }
  }

  Future<void> _pickPhoto(ImageSource source) async {
    try {
      final x = await ImagePicker()
          .pickImage(source: source, maxWidth: 1600, imageQuality: 80);
      if (x == null) return;
      await MediaService.delete(_photoPath);
      final saved = await MediaService.savePhoto(x.path);
      if (mounted) setState(() => _photoPath = saved);
    } catch (_) {
      _toast('Couldn’t attach that photo.');
    }
  }

  void _choosePhotoSource() {
    final theme = appColorRead(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.scaffoldBg,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_camera_outlined, color: theme.primary),
              title: Text('Take a photo',
                  style: appCss.body16.textColor(theme.darkText)),
              onTap: () {
                Navigator.pop(context);
                _pickPhoto(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library_outlined, color: theme.primary),
              title: Text('Choose from library',
                  style: appCss.body16.textColor(theme.darkText)),
              onTap: () {
                Navigator.pop(context);
                _pickPhoto(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _save() async {
    final provider = context.read<MoodProvider>();
    if (_recording) await _recorder.stop();
    setState(() => _saving = true);
    await provider.add(
      mood: _mood,
      tags: _tags.toList(),
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
      voicePath: _voicePath,
      photoPath: _photoPath,
    );
    if (mounted) Navigator.pop(context);
  }

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
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('How are you feeling?',
                    style: appCss.headingBold22.textColor(theme.darkText)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (final f in moodFaces)
                      GestureDetector(
                        onTap: () => setState(() => _mood = f.value),
                        child: Column(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: _mood == f.value
                                    ? theme.primarySoft
                                    : Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                              child: Text(f.emoji,
                                  style: TextStyle(
                                      fontSize: _mood == f.value ? 34 : 28)),
                            ),
                            const SizedBox(height: 4),
                            Text(f.label,
                                style:
                                    appCss.label12.textColor(theme.lightText)),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                Text('Tag it (optional)',
                    style: appCss.titleSemi16.textColor(theme.darkText)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final t in moodTags)
                      GestureDetector(
                        onTap: () => setState(() =>
                            _tags.contains(t) ? _tags.remove(t) : _tags.add(t)),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: _tags.contains(t)
                                ? theme.primary
                                : theme.fieldBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(t,
                              style: appCss.medium14.textColor(
                                  _tags.contains(t)
                                      ? Colors.white
                                      : theme.darkText)),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _noteController,
                  maxLines: 3,
                  minLines: 2,
                  style: appCss.body14.textColor(theme.darkText),
                  decoration: InputDecoration(
                    hintText: 'Anything on your mind? (optional)',
                    hintStyle: appCss.body14.textColor(theme.lightText),
                    filled: true,
                    fillColor: theme.fieldBg,
                    contentPadding: const EdgeInsets.all(14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _MediaButton(
                        icon: _recording
                            ? Icons.stop_circle_outlined
                            : Icons.mic_none_rounded,
                        label: _recording
                            ? 'Stop'
                            : (_voicePath != null ? 'Re-record' : 'Voice note'),
                        active: _recording || _voicePath != null,
                        theme: theme,
                        onTap: _toggleRecord,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MediaButton(
                        icon: Icons.image_outlined,
                        label: _photoPath != null ? 'Change photo' : 'Photo',
                        active: _photoPath != null,
                        theme: theme,
                        onTap: _choosePhotoSource,
                      ),
                    ),
                  ],
                ),
                if (_photoPath != null) ...[
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.file(File(_photoPath!),
                        height: 140, width: double.infinity, fit: BoxFit.cover),
                  ),
                ],
                const SizedBox(height: 20),
                PrimaryButton(
                    label: 'Save', loading: _saving, onPressed: _save),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.theme});
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.mood_rounded, size: 48, color: theme.primary),
            const SizedBox(height: 16),
            Text('Notice how you feel',
                style: appCss.titleSemi18.textColor(theme.darkText)),
            const SizedBox(height: 8),
            Text(
              'Naming emotions takes their edge off — and over time reveals what’s really driving the urges.',
              textAlign: TextAlign.center,
              style: appCss.body14.textColor(theme.lightText),
            ),
          ],
        ),
      ),
    );
  }
}
