import '../../config.dart';
import '../../content/program_models.dart';
import '../../widgets/content_blocks.dart';
import '../../widgets/primary_button.dart';
import 'program_screen.dart' show markProgramDay, readProgramDone;

/// A single program day: the day's reading, the concrete action, and a
/// mark-complete button that unlocks the next day. Day passed via arguments.
class ProgramDayScreen extends StatefulWidget {
  const ProgramDayScreen({super.key});

  @override
  State<ProgramDayScreen> createState() => _ProgramDayScreenState();
}

class _ProgramDayScreenState extends State<ProgramDayScreen> {
  ProgramDay? _day;
  bool _done = false;
  bool _init = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_init) return;
    _init = true;
    _day = ModalRoute.of(context)?.settings.arguments as ProgramDay?;
    if (_day != null) _done = readProgramDone().contains(_day!.day);
  }

  Future<void> _complete() async {
    await markProgramDay(_day!.day);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    final day = _day;
    if (day == null) {
      return Scaffold(appBar: AppBar(), body: const SizedBox.shrink());
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBg,
      appBar: AppBar(
        title: Text('Day ${day.day}',
            style: appCss.titleSemi18.textColor(theme.darkText)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        children: [
          Text(day.title,
              style: appCss.displayBold28.textColor(theme.darkText)),
          const SizedBox(height: 20),
          ContentBlocks(blocks: day.blocks),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: theme.primarySoft,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('TODAY’S ACTION',
                    style: appCss.label12.textColor(theme.primary)),
                const SizedBox(height: 6),
                Text(day.action,
                    style: appCss.body16.textColor(theme.darkText)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          if (_done)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_rounded, color: theme.success),
                const SizedBox(width: 8),
                Text('Completed',
                    style: appCss.titleSemi16.textColor(theme.success)),
              ],
            )
          else
            PrimaryButton(label: 'Mark day complete', onPressed: _complete),
        ],
      ),
    );
  }
}
