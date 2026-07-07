import '../../config.dart';
import '../../content/session_models.dart';
import '../../widgets/primary_button.dart';

/// Self-paced player for a [GuidedSession] — one block at a time, advanced by
/// the reader. Distraction-free (no banner). Session passed via arguments.
class SessionPlayerScreen extends StatefulWidget {
  const SessionPlayerScreen({super.key});

  @override
  State<SessionPlayerScreen> createState() => _SessionPlayerScreenState();
}

class _SessionPlayerScreenState extends State<SessionPlayerScreen> {
  GuidedSession? _session;
  int _index = 0;
  bool _init = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_init) return;
    _init = true;
    _session = ModalRoute.of(context)?.settings.arguments as GuidedSession?;
  }

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    final s = _session;
    if (s == null || s.blocks.isEmpty) {
      return Scaffold(appBar: AppBar(), body: const SizedBox.shrink());
    }

    final block = s.blocks[_index];
    final isLast = _index == s.blocks.length - 1;
    final progress = (_index + 1) / s.blocks.length;

    return Scaffold(
      backgroundColor: theme.calm,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 8, 28, 24),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: theme.darkText),
                    onPressed: () => route.pop(context),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 5,
                        backgroundColor: theme.cardBg,
                        valueColor: AlwaysStoppedAnimation(theme.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
              const Spacer(),
              if (block.pause)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Icon(Icons.air_rounded, size: 40, color: theme.primary),
                ),
              Text(
                block.text,
                textAlign: TextAlign.center,
                style: (block.pause ? appCss.headingBold22 : appCss.titleSemi18)
                    .textColor(theme.darkText),
              ),
              const Spacer(),
              PrimaryButton(
                label: isLast ? 'Finish' : 'Next',
                onPressed: () {
                  if (isLast) {
                    route.pop(context);
                  } else {
                    setState(() => _index++);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
