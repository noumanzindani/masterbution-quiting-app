import 'dart:math' as math;

import '../../config.dart';
import '../../widgets/primary_button.dart';
import 'emergency_scaffold.dart';

/// Paced-breathing tool: a circle that expands on the inhale, holds, and
/// contracts on the exhale, following a calming 4-4-6 rhythm. NO-AD route.
class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen>
    with SingleTickerProviderStateMixin {
  // 4s inhale + 4s hold + 6s exhale = 14s cycle.
  static const _inhale = 4.0;
  static const _hold = 4.0;
  static const _exhale = 6.0;
  static const _cycle = _inhale + _hold + _exhale;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: (_cycle * 1000).round()),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  ({String label, double scale, int count}) _phase(double v) {
    final t = v * _cycle;
    if (t < _inhale) {
      return (label: 'Breathe in', scale: 0.55 + 0.45 * (t / _inhale), count: (_inhale - t).ceil());
    }
    if (t < _inhale + _hold) {
      return (label: 'Hold', scale: 1.0, count: (_inhale + _hold - t).ceil());
    }
    final p = (t - _inhale - _hold) / _exhale;
    return (label: 'Breathe out', scale: 1.0 - 0.45 * p, count: (_cycle - t).ceil());
  }

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    return EmergencyScaffold(
      child: Column(
        children: [
          const Spacer(),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final ph = _phase(_controller.value);
              final size = 130.0 + 130.0 * ph.scale;
              return Column(
                children: [
                  SizedBox(
                    height: 300,
                    child: Center(
                      child: Container(
                        height: size,
                        width: size,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              theme.primary,
                              theme.primary.withValues(alpha: 0.65),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: theme.primary.withValues(alpha: 0.35),
                              blurRadius: 40,
                              spreadRadius: 8,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            '${math.max(1, ph.count)}',
                            style: appCss.counterBold40
                                .textColor(Colors.white)
                                .sized(44),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(ph.label,
                      style: appCss.headingBold22.textColor(theme.darkText)),
                ],
              );
            },
          ),
          const Spacer(),
          Text(
            'Let your out-breath be longer than your in-breath. That’s the signal your body reads as “safe.”',
            textAlign: TextAlign.center,
            style: appCss.body14.textColor(theme.lightText),
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            label: 'I’m calmer now',
            onPressed: () => route.pop(context),
          ),
        ],
      ),
    );
  }
}
