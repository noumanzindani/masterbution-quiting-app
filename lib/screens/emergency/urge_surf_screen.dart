import '../../config.dart';
import '../../widgets/primary_button.dart';
import 'emergency_scaffold.dart';

/// Urge-surfing timer: a 3-minute guided countdown reframing the urge as a wave
/// that rises, crests, and falls if you don't act on it. NO-AD route.
class UrgeSurfScreen extends StatefulWidget {
  const UrgeSurfScreen({super.key});

  @override
  State<UrgeSurfScreen> createState() => _UrgeSurfScreenState();
}

class _UrgeSurfScreenState extends State<UrgeSurfScreen>
    with SingleTickerProviderStateMixin {
  static const _totalSeconds = 180;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: _totalSeconds),
  )..forward();

  static const _messages = [
    'Notice the urge without fighting it. Just watch it.',
    'Where do you feel it in your body? Breathe into that spot.',
    'Urges peak and then fade — you don’t have to do anything.',
    'You’re riding it out. It’s already passing.',
  ];

  String _message(double v) {
    final i = (v * _messages.length).floor().clamp(0, _messages.length - 1);
    return _messages[i];
  }

  String _clock(int secondsLeft) {
    final m = secondsLeft ~/ 60;
    final s = secondsLeft % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    return EmergencyScaffold(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final done = _controller.isCompleted;
          final secondsLeft =
              (_totalSeconds * (1 - _controller.value)).ceil();
          return Column(
            children: [
              const Spacer(),
              SizedBox(
                height: 240,
                width: 240,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 240,
                      width: 240,
                      child: CircularProgressIndicator(
                        value: done ? 1.0 : _controller.value,
                        strokeWidth: 10,
                        backgroundColor: theme.cardBg,
                        valueColor: AlwaysStoppedAnimation(theme.primary),
                      ),
                    ),
                    Text(
                      done ? '✓' : _clock(secondsLeft),
                      style: appCss.counterBold40
                          .textColor(theme.darkText)
                          .sized(done ? 56 : 44),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                done ? 'The wave passed.' : 'Ride the wave',
                style: appCss.headingBold22.textColor(theme.darkText),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  done
                      ? 'You let the urge rise and fall without acting on it. That’s exactly the skill that rewires this over time.'
                      : _message(_controller.value),
                  textAlign: TextAlign.center,
                  style: appCss.body16.textColor(theme.lightText),
                ),
              ),
              const Spacer(),
              PrimaryButton(
                label: done ? 'I made it through' : 'I’m okay now',
                onPressed: () => route.pop(context),
              ),
            ],
          );
        },
      ),
    );
  }
}
