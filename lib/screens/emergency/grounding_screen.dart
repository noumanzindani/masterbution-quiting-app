import '../../config.dart';
import '../../widgets/primary_button.dart';
import 'emergency_scaffold.dart';

/// 5-4-3-2-1 sensory grounding — walks the senses to pull attention out of the
/// urge and back into the present. NO-AD route.
class GroundingScreen extends StatefulWidget {
  const GroundingScreen({super.key});

  @override
  State<GroundingScreen> createState() => _GroundingScreenState();
}

class _GroundingScreenState extends State<GroundingScreen> {
  int _step = 0;

  static const _steps = <({int count, String sense, String prompt})>[
    (count: 5, sense: 'see', prompt: 'Look around and name 5 things you can see.'),
    (count: 4, sense: 'feel', prompt: 'Notice 4 things you can physically feel.'),
    (count: 3, sense: 'hear', prompt: 'Listen for 3 sounds around you.'),
    (count: 2, sense: 'smell', prompt: 'Find 2 things you can smell.'),
    (count: 1, sense: 'taste', prompt: 'Name 1 thing you can taste.'),
  ];

  void _next() {
    if (_step >= _steps.length - 1) {
      route.pop(context);
    } else {
      setState(() => _step++);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    final s = _steps[_step];
    final isLast = _step == _steps.length - 1;
    return EmergencyScaffold(
      child: Column(
        children: [
          const Spacer(),
          Text('${s.count}',
              style: appCss.counterBold40.textColor(theme.primary).sized(96)),
          const SizedBox(height: 8),
          Text('things you can ${s.sense}',
              style: appCss.titleSemi18.textColor(theme.lightText)),
          const SizedBox(height: 28),
          Text(
            s.prompt,
            textAlign: TextAlign.center,
            style: appCss.headingBold22.textColor(theme.darkText),
          ),
          const SizedBox(height: 16),
          Text('Take your time. Say each one to yourself.',
              textAlign: TextAlign.center,
              style: appCss.body14.textColor(theme.lightText)),
          const Spacer(),
          Row(
            children: [
              for (var i = 0; i < _steps.length; i++)
                Expanded(
                  child: Container(
                    height: 5,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: i <= _step ? theme.primary : theme.stroke,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            label: isLast ? 'I feel more present' : 'Next',
            onPressed: _next,
          ),
        ],
      ),
    );
  }
}
