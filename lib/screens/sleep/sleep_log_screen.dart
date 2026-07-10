import '../../config.dart';
import '../../data/collections/sleep_entry.dart';
import '../../providers/sleep_provider.dart';
import '../../services/sleep_tips_engine.dart';
import '../../widgets/ad/banner_ad_widget.dart';

/// Nightly sleep tracker: log last night, then see rule-based tips (from
/// [SleepTipsEngine]) and recent history. Provider is screen-scoped so tips
/// recompute whenever a night is saved.
class SleepLogScreen extends StatelessWidget {
  const SleepLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SleepProvider(),
      child: const _SleepView(),
    );
  }
}

class _SleepView extends StatelessWidget {
  const _SleepView();

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    final p = context.watch<SleepProvider>();

    return Scaffold(
      backgroundColor: theme.scaffoldBg,
      appBar: AppBar(
        title: Text('Sleep tracker',
            style: appCss.headingBold22.textColor(theme.darkText).sized(20)),
      ),
      body: p.loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                _LogCard(theme: theme),
                const SizedBox(height: 24),
                Text('Your tips',
                    style: appCss.titleSemi16.textColor(theme.darkText)),
                const SizedBox(height: 4),
                Text('Gentle patterns from your logged nights — no streaks.',
                    style: appCss.label12.textColor(theme.lightText)),
                const SizedBox(height: 12),
                for (final t in p.tips) _TipCard(tip: t, theme: theme),
                if (p.entries.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text('Recent nights',
                      style: appCss.titleSemi16.textColor(theme.darkText)),
                  const SizedBox(height: 12),
                  for (final e in p.entries) _HistoryRow(entry: e, theme: theme),
                ],
                const SizedBox(height: 16),
                const Center(child: BannerAdWidget()),
              ],
            ),
    );
  }
}

/// The nightly log form. Local state only; commits through the provider.
class _LogCard extends StatefulWidget {
  const _LogCard({required this.theme});
  final AppTheme theme;

  @override
  State<_LogCard> createState() => _LogCardState();
}

class _LogCardState extends State<_LogCard> {
  TimeOfDay _bedtime = const TimeOfDay(hour: 23, minute: 0);
  TimeOfDay _wake = const TimeOfDay(hour: 7, minute: 0);
  int _quality = 3;
  final _note = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  int get _durationMinutes {
    final bed = _bedtime.hour * 60 + _bedtime.minute;
    var wake = _wake.hour * 60 + _wake.minute;
    if (wake <= bed) wake += 1440;
    return wake - bed;
  }

  Future<void> _pick(bool bedtime) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: bedtime ? _bedtime : _wake,
      helpText: bedtime ? 'When did you go to bed?' : 'When did you wake up?',
    );
    if (picked != null) {
      setState(() => bedtime ? _bedtime = picked : _wake = picked);
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await context.read<SleepProvider>().log(
          bedtimeMinutes: _bedtime.hour * 60 + _bedtime.minute,
          wakeMinutes: _wake.hour * 60 + _wake.minute,
          quality: _quality,
          note: _note.text,
        );
    if (!mounted) return;
    _note.clear();
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Night logged. Rest well.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Log last night',
              style: appCss.titleSemi16.textColor(theme.darkText)),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _TimeField(
                  label: 'Bedtime',
                  value: _fmtClock(_bedtime),
                  theme: theme,
                  onTap: () => _pick(true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _TimeField(
                  label: 'Woke up',
                  value: _fmtClock(_wake),
                  theme: theme,
                  onTap: () => _pick(false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text('About ${_fmtDuration(_durationMinutes)} asleep',
              style: appCss.label12.textColor(theme.primary)),
          const SizedBox(height: 16),
          Text('How rested do you feel?',
              style: appCss.label12.textColor(theme.lightText)),
          const SizedBox(height: 8),
          _QualityPicker(
            value: _quality,
            theme: theme,
            onChanged: (q) => setState(() => _quality = q),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _note,
            style: appCss.body14.textColor(theme.darkText),
            decoration: InputDecoration(
              hintText: 'Anything about last night? (optional)',
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
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saving ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: _saving
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : Text('Save night',
                      style: appCss.buttonSemi16.textColor(Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeField extends StatelessWidget {
  const _TimeField({
    required this.label,
    required this.value,
    required this.theme,
    required this.onTap,
  });
  final String label;
  final String value;
  final AppTheme theme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: theme.scaffoldBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.stroke),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: appCss.label12.textColor(theme.lightText)),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.schedule_rounded, size: 16, color: theme.primary),
                const SizedBox(width: 6),
                Text(value,
                    style: appCss.titleSemi16.textColor(theme.darkText)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QualityPicker extends StatelessWidget {
  const _QualityPicker({
    required this.value,
    required this.theme,
    required this.onChanged,
  });
  final int value;
  final AppTheme theme;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var q = 1; q <= 5; q++)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onChanged(q),
              child: Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: q <= value ? theme.primary : theme.scaffoldBg,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: q <= value ? theme.primary : theme.stroke),
                ),
                child: Text('$q',
                    style: appCss.titleSemi16.textColor(
                        q <= value ? Colors.white : theme.lightText)),
              ),
            ),
          ),
      ],
    );
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard({required this.tip, required this.theme});
  final SleepTip tip;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.primarySoft,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.nights_stay_rounded, color: theme.primary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tip.title,
                      style: appCss.titleSemi16.textColor(theme.darkText)),
                  const SizedBox(height: 4),
                  Text(tip.body,
                      style: appCss.label12.textColor(theme.darkText).sized(13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.entry, required this.theme});
  final SleepEntry entry;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: theme.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.stroke),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_fmtDate(entry.dateEpochDay),
                      style: appCss.titleSemi16.textColor(theme.darkText)),
                  const SizedBox(height: 2),
                  Text(
                      '${_fmtClock12(entry.bedtimeMinutes)} → '
                      '${_fmtClock12(entry.wakeMinutes)} · '
                      '${_fmtDuration(entry.durationMinutes)}',
                      style: appCss.label12.textColor(theme.lightText)),
                ],
              ),
            ),
            Row(
              children: [
                for (var q = 1; q <= 5; q++)
                  Icon(
                    q <= entry.quality
                        ? Icons.circle
                        : Icons.circle_outlined,
                    size: 10,
                    color: q <= entry.quality ? theme.primary : theme.stroke,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// --- formatting helpers ------------------------------------------------------

String _fmtClock(TimeOfDay t) => _fmtClock12(t.hour * 60 + t.minute);

String _fmtClock12(int minuteOfDay) {
  final h24 = (minuteOfDay ~/ 60) % 24;
  final m = minuteOfDay % 60;
  final period = h24 < 12 ? 'AM' : 'PM';
  var h12 = h24 % 12;
  if (h12 == 0) h12 = 12;
  return '$h12:${m.toString().padLeft(2, '0')} $period';
}

String _fmtDuration(int minutes) => '${minutes ~/ 60}h ${minutes % 60}m';

const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
];

/// Inverts [TimeBuckets.epochDayForLocal]: the stored index is days since the
/// UTC-midnight of 1970-01-01, so adding it back yields that calendar date.
String _fmtDate(int epochDay) {
  final d = DateTime.utc(1970, 1, 1).add(Duration(days: epochDay));
  return '${_weekdays[d.weekday - 1]}, ${d.day} ${_months[d.month - 1]}';
}
