import 'dart:async';

import '../../config.dart';
import '../../data/enums.dart';
import '../../services/emergency_flow.dart';
import '../../widgets/primary_button.dart';

/// Emergency recovery mode — the escalated, no-menu sequence for a peak-intensity
/// urge (see [EmergencyFlow]). Unlike the panic hub, there's no list of choices:
/// the app walks one calming step at a time so the person doesn't have to decide
/// anything. NO-AD route (`emergencyMode` is in [AdPolicy.noAdRoutes]).
///
/// An exit is always available — this guides, it never traps.
class EmergencyModeScreen extends StatefulWidget {
  const EmergencyModeScreen({super.key});

  @override
  State<EmergencyModeScreen> createState() => _EmergencyModeScreenState();
}

class _EmergencyModeScreenState extends State<EmergencyModeScreen> {
  final _pageController = PageController();
  final _reflect = TextEditingController();
  int _index = 0;

  static const _steps = EmergencyFlow.steps;

  @override
  void dispose() {
    _pageController.dispose();
    _reflect.dispose();
    super.dispose();
  }

  bool get _isLast => _index == _steps.length - 1;

  Future<void> _advance() async {
    if (_isLast) {
      await _finish();
      return;
    }
    setState(() => _index++);
    _pageController.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _finish() async {
    final note = _reflect.text.trim();
    if (note.isNotEmpty) {
      await journalRepo.add(kind: JournalKind.emergencyJournal, text: note);
    }
    if (mounted) Navigator.of(context).pop();
  }

  String get _cta => switch (_steps[_index]) {
        EmergencyStep.reflect => 'Continue',
        EmergencyStep.close => 'I got through this',
        _ => 'I\'m ready — continue',
      };

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    return Scaffold(
      backgroundColor: theme.calm,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _ProgressDots(count: _steps.length, index: _index, theme: theme),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('I\'m okay now',
                        style: appCss.label12.textColor(theme.lightText)),
                  ),
                ],
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    for (final step in _steps)
                      _StepView(step: step, reflect: _reflect, theme: theme),
                  ],
                ),
              ),
              PrimaryButton(label: _cta, onPressed: _advance),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressDots extends StatelessWidget {
  const _ProgressDots(
      {required this.count, required this.index, required this.theme});
  final int count;
  final int index;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < count; i++)
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Container(
              height: 8,
              width: i == index ? 22 : 8,
              decoration: BoxDecoration(
                color: i <= index ? theme.primary : theme.primary.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
      ],
    );
  }
}

/// Dispatches a step enum to its inline content.
class _StepView extends StatelessWidget {
  const _StepView(
      {required this.step, required this.reflect, required this.theme});
  final EmergencyStep step;
  final TextEditingController reflect;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return switch (step) {
      EmergencyStep.breathe => _BreatheStep(theme: theme),
      EmergencyStep.ground => _GroundStep(theme: theme),
      EmergencyStep.surf => _SurfStep(theme: theme),
      EmergencyStep.reflect => _ReflectStep(controller: reflect, theme: theme),
      EmergencyStep.close => _CloseStep(theme: theme),
    };
  }
}

/// A short heading + supporting copy shared by the text-only steps.
class _StepFrame extends StatelessWidget {
  const _StepFrame({
    required this.icon,
    required this.title,
    required this.body,
    required this.theme,
    this.child,
  });
  final IconData icon;
  final String title;
  final String body;
  final AppTheme theme;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Spacer(),
        Icon(icon, size: 48, color: theme.primary),
        const SizedBox(height: 20),
        Text(title,
            textAlign: TextAlign.center,
            style: appCss.headingBold22.textColor(theme.darkText)),
        const SizedBox(height: 12),
        Text(body,
            textAlign: TextAlign.center,
            style: appCss.body14.textColor(theme.lightText)),
        if (child != null) ...[const SizedBox(height: 28), child!],
        const Spacer(),
      ],
    );
  }
}

/// Step 1 — a gentle pulsing orb on a 4-in / 6-out rhythm (a lighter inline
/// variant of the standalone breathing tool).
class _BreatheStep extends StatefulWidget {
  const _BreatheStep({required this.theme});
  final AppTheme theme;

  @override
  State<_BreatheStep> createState() => _BreatheStepState();
}

class _BreatheStepState extends State<_BreatheStep>
    with SingleTickerProviderStateMixin {
  // 4s in + 6s out = 10s cycle.
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final t = _c.value * 10;
        final inhaling = t < 4;
        final scale = inhaling ? 0.55 + 0.45 * (t / 4) : 1.0 - 0.45 * ((t - 4) / 6);
        final size = 120.0 + 120.0 * scale;
        return _StepFrame(
          icon: Icons.air_rounded,
          title: inhaling ? 'Breathe in…' : 'Breathe out…',
          body: 'Let the out-breath be longer. That\'s the signal your body '
              'reads as "safe."',
          theme: theme,
          child: Center(
            child: Container(
              height: size,
              width: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  theme.primary,
                  theme.primary.withValues(alpha: 0.6),
                ]),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Step 2 — 5-4-3-2-1 grounding, listed so there's nothing to figure out.
class _GroundStep extends StatelessWidget {
  const _GroundStep({required this.theme});
  final AppTheme theme;

  static const _prompts = [
    ('5', 'things you can see'),
    ('4', 'things you can feel'),
    ('3', 'things you can hear'),
    ('2', 'things you can smell'),
    ('1', 'thing you can taste'),
  ];

  @override
  Widget build(BuildContext context) {
    return _StepFrame(
      icon: Icons.spa_rounded,
      title: 'Come back to right now',
      body: 'Name each one slowly, to yourself.',
      theme: theme,
      child: Column(
        children: [
          for (final (n, label) in _prompts)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    height: 34,
                    width: 34,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: theme.primary.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Text(n,
                        style: appCss.titleSemi16.textColor(theme.primary)),
                  ),
                  const SizedBox(width: 14),
                  Text(label, style: appCss.body14.textColor(theme.darkText)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Step 3 — a 90-second urge-surf countdown. The urge crests and falls; the job
/// is only to let the timer run.
class _SurfStep extends StatefulWidget {
  const _SurfStep({required this.theme});
  final AppTheme theme;

  @override
  State<_SurfStep> createState() => _SurfStepState();
}

class _SurfStepState extends State<_SurfStep> {
  static const _total = 90;
  int _remaining = _total;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remaining <= 0) {
        t.cancel();
      } else {
        setState(() => _remaining--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final mm = (_remaining ~/ 60).toString();
    final ss = (_remaining % 60).toString().padLeft(2, '0');
    return _StepFrame(
      icon: Icons.surfing_rounded,
      title: 'Ride the wave',
      body: 'Urges rise, peak, and pass — always. You don\'t have to fight it. '
          'Just watch it fall.',
      theme: theme,
      child: Column(
        children: [
          SizedBox(
            height: 120,
            width: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 120,
                  width: 120,
                  child: CircularProgressIndicator(
                    value: _remaining / _total,
                    strokeWidth: 6,
                    backgroundColor: theme.primary.withValues(alpha: 0.15),
                    valueColor: AlwaysStoppedAnimation(theme.primary),
                  ),
                ),
                Text('$mm:$ss',
                    style: appCss.counterBold40.textColor(theme.darkText).sized(30)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Step 4 — a couple of lines to get the moment out of the head and onto the
/// page. Optional; saved as an emergency journal entry on finish.
class _ReflectStep extends StatelessWidget {
  const _ReflectStep({required this.controller, required this.theme});
  final TextEditingController controller;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return _StepFrame(
      icon: Icons.edit_note_rounded,
      title: 'What\'s going on for you?',
      body: 'Optional — just a line or two. What set this off, what you need '
          'right now.',
      theme: theme,
      child: TextField(
        controller: controller,
        maxLines: 4,
        style: appCss.body14.textColor(theme.darkText),
        decoration: InputDecoration(
          hintText: 'Type here if it helps…',
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
    );
  }
}

/// Step 5 — the reframe. Getting through the urge without acting is the rep
/// that rewires the habit; this is never framed as a test passed or failed.
class _CloseStep extends StatelessWidget {
  const _CloseStep({required this.theme});
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return _StepFrame(
      icon: Icons.favorite_rounded,
      title: 'You rode it out',
      body: 'You felt a 9-or-10 urge and didn\'t act on it. That\'s not luck — '
          'that\'s the exact rep that rewires this over time. Be proud of it.',
      theme: theme,
    );
  }
}
