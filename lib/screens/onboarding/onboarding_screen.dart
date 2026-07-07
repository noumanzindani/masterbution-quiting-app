import '../../config.dart';
import '../../data/enums.dart';
import '../../providers/onboarding_provider.dart';
import '../../widgets/option_scale.dart';
import '../../widgets/primary_button.dart';
import 'assessment_content.dart';

/// The one-time onboarding flow. A [PageView] walks the user through welcome →
/// focus/intent → frequency → a short wellbeing screener → results → goal, then
/// persists everything via [OnboardingProvider.finish] and enters the app.
///
/// The provider is scoped to this screen (it's a one-shot flow, no need to keep
/// it alive app-wide).
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OnboardingProvider(),
      child: const _OnboardingView(),
    );
  }
}

class _OnboardingView extends StatefulWidget {
  const _OnboardingView();

  @override
  State<_OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<_OnboardingView> {
  final _controller = PageController();
  int _page = 0;
  bool _saving = false;

  // Page indices (order matches the PageView children below): welcome(0),
  // focus(1), frequency(2), wellbeing(3), results(4), goal(5).
  static const _results = 4;
  static const _lastPage = 5;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next(OnboardingProvider p) {
    if (_page == _lastPage) {
      _finish(p);
      return;
    }
    // Compute scores as we move into the results page.
    if (_page + 1 == _results) p.computeScores();
    _goTo(_page + 1);
  }

  void _back() => _goTo(_page - 1);

  void _goTo(int page) {
    _controller.animateToPage(
      page,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _finish(OnboardingProvider p) async {
    setState(() => _saving = true);
    await p.finish();
    if (!mounted) return;
    route.pushReplacement(context, routeName.home);
  }

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    final p = context.watch<OnboardingProvider>();

    return Scaffold(
      backgroundColor: theme.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            _ProgressBar(current: _page, total: _lastPage + 1, theme: theme),
            Expanded(
              child: PageView(
                controller: _controller,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _page = i),
                children: [
                  _WelcomePage(theme: theme),
                  _FocusPage(p: p, theme: theme),
                  _FrequencyPage(p: p, theme: theme),
                  _WellbeingPage(p: p, theme: theme),
                  _ResultsPage(p: p, theme: theme),
                  _GoalPage(p: p, theme: theme),
                ],
              ),
            ),
            _NavBar(
              page: _page,
              lastPage: _lastPage,
              saving: _saving,
              theme: theme,
              onBack: _page == 0 ? null : _back,
              onNext: _saving ? null : () => _next(p),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Chrome -----------------------------------------------------------------

class _ProgressBar extends StatelessWidget {
  const _ProgressBar(
      {required this.current, required this.total, required this.theme});
  final int current;
  final int total;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: LinearProgressIndicator(
          value: (current + 1) / total,
          minHeight: 6,
          backgroundColor: theme.fieldBg,
          valueColor: AlwaysStoppedAnimation(theme.primary),
        ),
      ),
    );
  }
}

class _NavBar extends StatelessWidget {
  const _NavBar({
    required this.page,
    required this.lastPage,
    required this.saving,
    required this.theme,
    required this.onBack,
    required this.onNext,
  });
  final int page;
  final int lastPage;
  final bool saving;
  final AppTheme theme;
  final VoidCallback? onBack;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final label = page == lastPage ? 'Start my journey' : 'Continue';
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
      child: Row(
        children: [
          if (onBack != null)
            TextButton(
              onPressed: onBack,
              child: Text('Back',
                  style: appCss.buttonSemi16.textColor(theme.lightText)),
            ),
          const Spacer(),
          Expanded(
            flex: 2,
            child: PrimaryButton(
              label: label,
              loading: saving,
              onPressed: onNext,
            ),
          ),
        ],
      ),
    );
  }
}

// --- Pages ------------------------------------------------------------------

/// Every page shares this scrollable, padded shell.
class _Page extends StatelessWidget {
  const _Page({required this.title, this.subtitle, required this.children});
  final String title;
  final String? subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: appCss.headingBold22.textColor(theme.darkText)),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(subtitle!, style: appCss.body14.textColor(theme.lightText)),
          ],
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }
}

class _WelcomePage extends StatelessWidget {
  const _WelcomePage({required this.theme});
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return _Page(
      title: language(context, appFonts.welcomeTitle),
      children: [
        Text(
          language(context, appFonts.welcomeSubtitle),
          style: appCss.body16.textColor(theme.lightText),
        ),
        const SizedBox(height: 24),
        _InfoCard(
          icon: Icons.lock_outline_rounded,
          text:
              'Everything stays on this device. No account, no sign-up, and nothing leaves your phone.',
          theme: theme,
        ),
        const SizedBox(height: 12),
        _InfoCard(
          icon: Icons.favorite_border_rounded,
          text:
              'This is a judgement-free space. A slip is never a failure here — it\'s information we learn from.',
          theme: theme,
        ),
      ],
    );
  }
}

class _FocusPage extends StatelessWidget {
  const _FocusPage({required this.p, required this.theme});
  final OnboardingProvider p;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    final focusIndex =
        focusOptions.indexWhere((o) => o.target == p.focus);
    return _Page(
      title: 'What would you like to focus on?',
      subtitle: 'This just tailors your plan — you can change it later.',
      children: [
        OptionScale(
          options: [for (final o in focusOptions) o.label],
          selectedIndex: focusIndex < 0 ? null : focusIndex,
          onSelected: (i) => p.setFocus(focusOptions[i].target),
        ),
        const SizedBox(height: 28),
        Text('Your aim right now',
            style: appCss.titleSemi16.textColor(theme.darkText)),
        const SizedBox(height: 12),
        OptionScale(
          options: const ['Quit completely', 'Cut down'],
          selectedIndex: p.wantsToQuit ? 0 : 1,
          onSelected: (i) => p.setWantsToQuit(i == 0),
        ),
      ],
    );
  }
}

class _FrequencyPage extends StatelessWidget {
  const _FrequencyPage({required this.p, required this.theme});
  final OnboardingProvider p;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return _Page(
      title: 'Where are you now?',
      subtitle: 'An honest answer helps set a realistic starting point.',
      children: [
        OptionScale(
          prompt: frequencyQuestion.prompt,
          options: frequencyQuestion.options,
          selectedIndex: p.frequency,
          onSelected: p.setFrequency,
        ),
      ],
    );
  }
}

class _WellbeingPage extends StatelessWidget {
  const _WellbeingPage({required this.p, required this.theme});
  final OnboardingProvider p;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return _Page(
      title: 'How have you been feeling?',
      children: [
        _DisclaimerBanner(
          text: language(context, appFonts.notADiagnosis),
          theme: theme,
        ),
        const SizedBox(height: 24),
        for (var i = 0; i < adhdQuestions.length; i++) ...[
          OptionScale(
            prompt: adhdQuestions[i].prompt,
            options: adhdQuestions[i].options,
            selectedIndex: p.adhd[i],
            onSelected: (v) => p.setScaleItem(p.adhd, i, v),
          ),
          const SizedBox(height: 24),
        ],
        Text('Over the last two weeks…',
            style: appCss.medium14.textColor(theme.lightText)),
        const SizedBox(height: 16),
        for (var i = 0; i < anxietyQuestions.length; i++) ...[
          OptionScale(
            prompt: anxietyQuestions[i].prompt,
            options: anxietyQuestions[i].options,
            selectedIndex: p.anxiety[i],
            onSelected: (v) => p.setScaleItem(p.anxiety, i, v),
          ),
          const SizedBox(height: 24),
        ],
        for (var i = 0; i < depressionQuestions.length; i++) ...[
          OptionScale(
            prompt: depressionQuestions[i].prompt,
            options: depressionQuestions[i].options,
            selectedIndex: p.depression[i],
            onSelected: (v) => p.setScaleItem(p.depression, i, v),
          ),
          const SizedBox(height: 24),
        ],
        OptionScale(
          prompt: sleepQuestion.prompt,
          options: sleepQuestion.options,
          selectedIndex: p.sleep,
          onSelected: p.setSleep,
        ),
        const SizedBox(height: 24),
        OptionScale(
          prompt: stressQuestion.prompt,
          options: stressQuestion.options,
          selectedIndex: p.stress,
          onSelected: p.setStress,
        ),
      ],
    );
  }
}

class _ResultsPage extends StatelessWidget {
  const _ResultsPage({required this.p, required this.theme});
  final OnboardingProvider p;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    final s = p.scores;
    return _Page(
      title: 'Your starting point',
      subtitle:
          'A snapshot to shape your plan — not a diagnosis, and never a score to feel bad about.',
      children: [
        if (s == null)
          Text('Answer the check-in to see your snapshot.',
              style: appCss.body14.textColor(theme.lightText))
        else ...[
          _DifficultyCard(score: s.recoveryDifficultyScore, theme: theme),
          const SizedBox(height: 20),
          _SubscoreRow(label: 'Focus / attention', value: s.adhdScore, max: 12, theme: theme),
          _SubscoreRow(label: 'Anxiety', value: s.anxietyScore, max: 6, theme: theme),
          _SubscoreRow(label: 'Low mood', value: s.depressionScore, max: 6, theme: theme),
          _SubscoreRow(label: 'Sleep difficulty', value: s.sleepScore, max: 4, theme: theme),
          _SubscoreRow(label: 'Stress', value: s.stressScore, max: 4, theme: theme),
          const SizedBox(height: 20),
          _DisclaimerBanner(
            text: language(context, appFonts.notADiagnosis),
            theme: theme,
          ),
        ],
      ],
    );
  }
}

class _GoalPage extends StatelessWidget {
  const _GoalPage({required this.p, required this.theme});
  final OnboardingProvider p;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    final durationIndex =
        goalDurations.indexWhere((d) => d.days == p.chosenTargetDays);
    return _Page(
      title: 'Set your goal',
      subtitle: 'We picked a starting point for you. Adjust it to fit your life.',
      children: [
        Text('I want to…', style: appCss.titleSemi16.textColor(theme.darkText)),
        const SizedBox(height: 12),
        OptionScale(
          options: [for (final g in GoalType.values) goalLabel(g)],
          selectedIndex: GoalType.values.indexOf(p.chosenGoal),
          onSelected: (i) => p.setChosenGoal(GoalType.values[i]),
        ),
        const SizedBox(height: 28),
        Text('Goal length',
            style: appCss.titleSemi16.textColor(theme.darkText)),
        const SizedBox(height: 12),
        OptionScale(
          options: [for (final d in goalDurations) d.label],
          selectedIndex: durationIndex < 0 ? null : durationIndex,
          onSelected: (i) => p.setChosenTargetDays(goalDurations[i].days),
        ),
        const SizedBox(height: 24),
        _InfoCard(
          icon: Icons.flag_outlined,
          text:
              'Milestones unlock along the way. If you slip, your day-count restarts but your progress score barely moves — you keep what you\'ve built.',
          theme: theme,
        ),
      ],
    );
  }
}

// --- Small building blocks --------------------------------------------------

class _InfoCard extends StatelessWidget {
  const _InfoCard(
      {required this.icon, required this.text, required this.theme});
  final IconData icon;
  final String text;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.stroke),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.primary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: appCss.body14.textColor(theme.darkText)),
          ),
        ],
      ),
    );
  }
}

class _DisclaimerBanner extends StatelessWidget {
  const _DisclaimerBanner({required this.text, required this.theme});
  final String text;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.primarySoft,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, size: 18, color: theme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: appCss.label12.textColor(theme.darkText)),
          ),
        ],
      ),
    );
  }
}

class _DifficultyCard extends StatelessWidget {
  const _DifficultyCard({required this.score, required this.theme});
  final int score;
  final AppTheme theme;

  String get _band => score > 66
      ? 'We\'ll start with extra support'
      : score >= 34
          ? 'A steady, balanced plan fits you'
          : 'You\'re starting from a strong place';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recovery difficulty',
              style: appCss.medium14.textColor(theme.lightText)),
          const SizedBox(height: 6),
          Text('$score / 100',
              style: appCss.counterBold40.textColor(theme.primary)),
          const SizedBox(height: 6),
          Text(_band, style: appCss.body14.textColor(theme.darkText)),
        ],
      ),
    );
  }
}

class _SubscoreRow extends StatelessWidget {
  const _SubscoreRow({
    required this.label,
    required this.value,
    required this.max,
    required this.theme,
  });
  final String label;
  final int value;
  final int max;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: appCss.body14.textColor(theme.darkText)),
          ),
          SizedBox(
            width: 120,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: max == 0 ? 0 : value / max,
                minHeight: 6,
                backgroundColor: theme.fieldBg,
                valueColor: AlwaysStoppedAnimation(theme.primary),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text('$value/$max',
              style: appCss.label12.textColor(theme.lightText)),
        ],
      ),
    );
  }
}
