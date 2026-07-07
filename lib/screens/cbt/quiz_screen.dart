import '../../config.dart';
import '../../content/quiz_models.dart';
import '../../services/quiz_engine.dart';
import '../../widgets/primary_button.dart';

/// Generic quiz runner: one question at a time, immediate feedback with an
/// explanation, then a low-stakes score. Quiz passed via route arguments.
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  Quiz? _quiz;
  int _index = 0;
  final Map<int, int> _answers = {};
  bool _revealed = false;
  bool _done = false;
  bool _init = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_init) return;
    _init = true;
    _quiz = ModalRoute.of(context)?.settings.arguments as Quiz?;
  }

  void _select(int i) {
    if (_revealed) return;
    setState(() {
      _answers[_index] = i;
      _revealed = true;
    });
  }

  void _next() {
    final quiz = _quiz!;
    if (_index >= quiz.questions.length - 1) {
      setState(() => _done = true);
    } else {
      setState(() {
        _index++;
        _revealed = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    final quiz = _quiz;
    if (quiz == null || quiz.questions.isEmpty) {
      return Scaffold(appBar: AppBar(), body: const SizedBox.shrink());
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBg,
      appBar: AppBar(
        title: Text(quiz.title,
            style: appCss.titleSemi18.textColor(theme.darkText)),
      ),
      body: _done
          ? _Result(quiz: quiz, answers: _answers, theme: theme)
          : _Question(
              question: quiz.questions[_index],
              index: _index,
              total: quiz.questions.length,
              chosen: _answers[_index],
              revealed: _revealed,
              theme: theme,
              onSelect: _select,
              onNext: _next,
              isLast: _index == quiz.questions.length - 1,
            ),
    );
  }
}

class _Question extends StatelessWidget {
  const _Question({
    required this.question,
    required this.index,
    required this.total,
    required this.chosen,
    required this.revealed,
    required this.onSelect,
    required this.onNext,
    required this.isLast,
    required this.theme,
  });
  final QuizQuestion question;
  final int index;
  final int total;
  final int? chosen;
  final bool revealed;
  final ValueChanged<int> onSelect;
  final VoidCallback onNext;
  final bool isLast;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      children: [
        Text('Question ${index + 1} of $total',
            style: appCss.label12.textColor(theme.lightText)),
        const SizedBox(height: 10),
        Text(question.prompt,
            style: appCss.headingBold22.textColor(theme.darkText)),
        const SizedBox(height: 24),
        for (var i = 0; i < question.options.length; i++)
          _Option(
            label: question.options[i],
            state: !revealed
                ? _OptState.idle
                : i == question.correctIndex
                    ? _OptState.correct
                    : (i == chosen ? _OptState.wrong : _OptState.idle),
            theme: theme,
            onTap: () => onSelect(i),
          ),
        if (revealed) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: theme.primarySoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(question.explanation,
                style: appCss.body14.textColor(theme.darkText)),
          ),
          const SizedBox(height: 20),
          PrimaryButton(
              label: isLast ? 'See results' : 'Next', onPressed: onNext),
        ],
      ],
    );
  }
}

enum _OptState { idle, correct, wrong }

class _Option extends StatelessWidget {
  const _Option({
    required this.label,
    required this.state,
    required this.onTap,
    required this.theme,
  });
  final String label;
  final _OptState state;
  final VoidCallback onTap;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    final (bg, border, icon) = switch (state) {
      _OptState.correct => (
          theme.success.withValues(alpha: 0.12),
          theme.success,
          Icons.check_circle_rounded
        ),
      _OptState.wrong => (
          theme.danger.withValues(alpha: 0.10),
          theme.danger,
          Icons.cancel_rounded
        ),
      _OptState.idle => (theme.cardBg, theme.stroke, null),
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(label,
                      style: appCss.body16.textColor(theme.darkText)),
                ),
                if (icon != null) Icon(icon, color: border, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Result extends StatelessWidget {
  const _Result(
      {required this.quiz, required this.answers, required this.theme});
  final Quiz quiz;
  final Map<int, int> answers;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    final result = QuizEngine.score(quiz, answers);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
                result.passed
                    ? Icons.emoji_events_rounded
                    : Icons.school_rounded,
                size: 56,
                color: theme.primary),
            const SizedBox(height: 16),
            Text('${result.correct} / ${result.total}',
                style: appCss.counterBold40.textColor(theme.primary)),
            const SizedBox(height: 8),
            Text(
              result.passed
                  ? 'You\'ve got this. Understanding is a real recovery tool.'
                  : 'Worth another look — the ideas here make urges easier to handle.',
              textAlign: TextAlign.center,
              style: appCss.body16.textColor(theme.darkText),
            ),
            const SizedBox(height: 28),
            PrimaryButton(
                label: 'Done', onPressed: () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }
}
