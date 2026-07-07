import 'dart:convert';

import '../../config.dart';
import '../../content/program_models.dart';
import '../../services/program_progress.dart';
import '../../widgets/ad/banner_ad_widget.dart';

/// Read the set of completed day numbers for the dopamine program from prefs.
Set<int> readProgramDone() {
  final raw = prefs.getString(session.dopamineProgress);
  if (raw == null) return {};
  try {
    return (jsonDecode(raw) as List).map((e) => e as int).toSet();
  } catch (_) {
    return {};
  }
}

Future<void> markProgramDay(int day) async {
  final done = readProgramDone()..add(day);
  await prefs.setString(session.dopamineProgress, jsonEncode(done.toList()));
}

/// Overview of the multi-day dopamine-reset program: each day is completed,
/// current, or locked until the previous day is done.
class ProgramScreen extends StatefulWidget {
  const ProgramScreen({super.key});

  @override
  State<ProgramScreen> createState() => _ProgramScreenState();
}

class _ProgramScreenState extends State<ProgramScreen> {
  Set<int> _done = {};

  @override
  void initState() {
    super.initState();
    _done = readProgramDone();
  }

  void _openDay(ProgramDay day) {
    Navigator.pushNamed(context, routeName.programDay, arguments: day)
        .then((_) => setState(() => _done = readProgramDone()));
  }

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    final program = contentService.dopamineReset;
    if (program == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
            child: Text('Program unavailable.',
                style: appCss.body14.textColor(theme.lightText))),
      );
    }

    final total = program.days.length;
    final complete = ProgramProgress.isComplete(_done, total);

    return Scaffold(
      backgroundColor: theme.scaffoldBg,
      appBar: AppBar(
        title: Text(program.title,
            style: appCss.headingBold22.textColor(theme.darkText)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Text(program.intro,
              style: appCss.body14.textColor(theme.lightText)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.primarySoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              complete
                  ? 'You completed the reset. That knowledge is yours to keep.'
                  : '${_done.length} of $total days done',
              style: appCss.medium14.textColor(theme.darkText),
            ),
          ),
          const SizedBox(height: 20),
          for (final day in program.days)
            _DayRow(
              day: day,
              done: _done.contains(day.day),
              unlocked: ProgramProgress.isUnlocked(day.day, _done),
              theme: theme,
              onTap: () => _openDay(day),
            ),
          const SizedBox(height: 12),
          const Center(child: BannerAdWidget()),
        ],
      ),
    );
  }
}

class _DayRow extends StatelessWidget {
  const _DayRow({
    required this.day,
    required this.done,
    required this.unlocked,
    required this.onTap,
    required this.theme,
  });
  final ProgramDay day;
  final bool done;
  final bool unlocked;
  final VoidCallback onTap;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    final IconData leading;
    final Color leadingColor;
    if (done) {
      leading = Icons.check_circle_rounded;
      leadingColor = theme.success;
    } else if (unlocked) {
      leading = Icons.play_circle_outline_rounded;
      leadingColor = theme.primary;
    } else {
      leading = Icons.lock_outline_rounded;
      leadingColor = theme.lightText;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: theme.cardBg,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: unlocked ? onTap : null,
          child: Opacity(
            opacity: unlocked ? 1 : 0.55,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.stroke),
              ),
              child: Row(
                children: [
                  Icon(leading, color: leadingColor),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Day ${day.day}',
                            style:
                                appCss.label12.textColor(theme.lightText)),
                        Text(day.title,
                            style: appCss.titleSemi16
                                .textColor(theme.darkText)),
                      ],
                    ),
                  ),
                  if (unlocked)
                    Icon(Icons.chevron_right_rounded, color: theme.lightText),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
