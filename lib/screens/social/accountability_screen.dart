import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config.dart';
import '../../data/enums.dart';
import '../../data/time_buckets.dart';
import '../../services/accountability.dart';
import '../../services/progress_report.dart';
import '../../services/streak_service.dart';
import '../../widgets/ad/banner_ad_widget.dart';
import '../../widgets/primary_button.dart';

/// Accountability partner: a name + number the user types (no contacts
/// permission, no server), plus one-tap prefilled SMS / WhatsApp for a progress
/// update or a non-shaming SOS, and a "share my progress" snapshot.
class AccountabilityScreen extends StatefulWidget {
  const AccountabilityScreen({super.key});

  @override
  State<AccountabilityScreen> createState() => _AccountabilityScreenState();
}

class _AccountabilityScreenState extends State<AccountabilityScreen> {
  final _name = TextEditingController();
  final _phone = TextEditingController();

  int _streakDays = 0;
  int _recoveryScore = 0;
  int _daysActive = 1;
  int _cleanCheckins = 0;
  String? _goalLabel;

  @override
  void initState() {
    super.initState();
    _name.text = prefs.getString(session.accountabilityName) ?? '';
    _phone.text = prefs.getString(session.accountabilityPhone) ?? '';
    _loadSnapshot();
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _loadSnapshot() async {
    final goal = await goalRepo.getActive();
    final events = await trackerRepo.all();
    final today = TimeBuckets.todayEpochDay();
    if (goal != null) {
      final stats = StreakService.compute(
        events,
        todayEpochDay: today,
        startEpochDay: TimeBuckets.epochDayForLocal(goal.startDate),
        target: goal.target,
        goalTargetDays: goal.targetDays,
      );
      _streakDays = stats.daysSinceLastLapse;
      _recoveryScore = stats.recoveryScore;
      _cleanCheckins = StreakService.positiveDays(events, goal.target);
      _goalLabel = _labelFor(goal.type);
    }
    final first = prefs.getString(session.firstLaunchDate);
    if (first != null) {
      final d = DateTime.tryParse(first);
      if (d != null) {
        _daysActive = today - TimeBuckets.epochDayForLocal(d) + 1;
      }
    }
    if (mounted) setState(() {});
  }

  String _labelFor(GoalType t) => switch (t) {
        GoalType.quitPorn => 'Quitting porn',
        GoalType.quitMasturbation => 'Cutting back',
        GoalType.reduceFrequency => 'Reducing frequency',
        GoalType.healthyHabits => 'Building healthy habits',
      };

  String get _report => ProgressReport.build(
        streakDays: _streakDays,
        recoveryScore: _recoveryScore,
        daysActive: _daysActive,
        cleanCheckins: _cleanCheckins,
        goalLabel: _goalLabel,
      );

  void _persist() {
    prefs.setString(session.accountabilityName, _name.text.trim());
    prefs.setString(session.accountabilityPhone, _phone.text.trim());
  }

  Future<void> _send(String body) async {
    _persist();
    final phone = _phone.text.trim();
    if (phone.isEmpty) {
      _toast('Add your partner\'s number first.');
      return;
    }
    // Prefer SMS; it's universally available and needs no app install.
    final uri = AccountabilityMessages.smsUri(phone, body);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      _toast('Couldn\'t open your messaging app.');
    }
  }

  Future<void> _shareProgress() async {
    await SharePlus.instance.share(ShareParams(text: _report));
  }

  void _toast(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    final name = _name.text.trim().isEmpty ? null : _name.text.trim();
    return Scaffold(
      backgroundColor: theme.scaffoldBg,
      appBar: AppBar(
        title: Text('Accountability partner',
            style: appCss.headingBold22.textColor(theme.darkText).sized(20)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Text(
            'Pick someone you trust. Their details stay on your phone — messages '
            'only send when you tap, and you choose every word before it goes.',
            style: appCss.body14.textColor(theme.lightText),
          ),
          const SizedBox(height: 20),
          _Card(theme: theme, children: [
            Text('Your partner',
                style: appCss.titleSemi16.textColor(theme.darkText)),
            const SizedBox(height: 12),
            _Field(controller: _name, hint: 'Name (optional)', theme: theme,
                onChanged: (_) => setState(() {})),
            const SizedBox(height: 8),
            _Field(
                controller: _phone,
                hint: 'Phone number',
                theme: theme,
                keyboard: TextInputType.phone,
                onChanged: (_) => _persist()),
          ]),
          const SizedBox(height: 20),
          _Card(theme: theme, children: [
            Text('Reach out',
                style: appCss.titleSemi16.textColor(theme.darkText)),
            const SizedBox(height: 12),
            PrimaryButton(
              label: 'Send a progress update',
              onPressed: () =>
                  _send(AccountabilityMessages.progress(
                      partnerName: name, streakDays: _streakDays)),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () =>
                  _send(AccountabilityMessages.sos(partnerName: name)),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                side: BorderSide(color: theme.primary),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('Send an SOS',
                  style: appCss.buttonSemi16.textColor(theme.primary)),
            ),
          ]),
          const SizedBox(height: 20),
          _Card(theme: theme, children: [
            Text('Share your progress',
                style: appCss.titleSemi16.textColor(theme.darkText)),
            const SizedBox(height: 4),
            Text('A quick snapshot you can send to anyone.',
                style: appCss.label12.textColor(theme.lightText)),
            const SizedBox(height: 12),
            PrimaryButton(label: 'Share progress snapshot', onPressed: _shareProgress),
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
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: theme.cardBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: theme.stroke),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: children),
      );
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.hint,
    required this.theme,
    this.keyboard,
    this.onChanged,
  });
  final TextEditingController controller;
  final String hint;
  final AppTheme theme;
  final TextInputType? keyboard;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        keyboardType: keyboard,
        onChanged: onChanged,
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
