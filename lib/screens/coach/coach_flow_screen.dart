import '../../config.dart';
import '../../content/coach_models.dart';
import '../../data/enums.dart';
import '../../data/trigger_labels.dart';
import '../../services/coach_runner.dart';
import '../../services/coping_plan_engine.dart';
import '../../services/daily_plan_store.dart';
import '../../services/reflection_composer.dart';
import '../../widgets/primary_button.dart';

/// The ONE screen that renders any rule-based coach flow. It reads a flow id
/// from its route arguments, loads the [CoachFlow] from [contentService], and
/// walks it with the pure [CoachRunner] — so adding a new conversation is just
/// a new JSON file, never new code.
///
/// It is deliberately ad-free: the relapse-reflection flow runs on the
/// `relapseReflection` no-ad route, and even the daily flows are quiet spaces.
/// Side-effects declared as `action` nodes are interpreted here (save a
/// reflection, open a calming tool) — the engine itself stays pure.
class CoachFlowScreen extends StatefulWidget {
  const CoachFlowScreen({super.key});

  @override
  State<CoachFlowScreen> createState() => _CoachFlowScreenState();
}

class _CoachFlowScreenState extends State<CoachFlowScreen> {
  CoachFlow? _flow;
  late CoachState _state;
  final List<_Turn> _turns = [];
  final _input = TextEditingController();
  final _scroll = ScrollController();
  bool _init = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_init) return;
    _init = true;
    final id = ModalRoute.of(context)?.settings.arguments as String?;
    _flow = id == null ? null : contentService.coachFlow(id);
    if (_flow != null) {
      _advanceTo(CoachRunner.start(_flow!));
    }
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  bool get _done => _state.done;

  CoachNode get _node => CoachRunner.current(_flow!, _state);

  /// A node the conversation ends on — no forward affordance, just "Done".
  bool _isTerminal(CoachNode n) =>
      _state.done ||
      n.type == 'end' ||
      (n.type == 'message' && n.next == null && n.choices.isEmpty);

  // --- Walking the flow -----------------------------------------------------

  Future<void> _advanceTo(CoachState s) async {
    setState(() => _state = s);
    final node = CoachRunner.current(_flow!, s);
    if (node.type == 'action') {
      final said = await _runAction(node);
      if (!mounted) return;
      if (said != null) {
        setState(() => _turns.add(_Turn.coach(said)));
        _scrollToEnd();
      }
      await _advanceTo(CoachRunner.proceed(_flow!, s));
      return;
    }
    setState(() => _turns.add(_Turn.coach(node.text)));
    _scrollToEnd();
  }

  void _continue() => _advanceTo(CoachRunner.proceed(_flow!, _state));

  void _choose(int i) {
    final label = _node.choices[i].label;
    setState(() => _turns.add(_Turn.user(label)));
    _advanceTo(CoachRunner.choose(_flow!, _state, i));
  }

  void _submit() {
    final text = _input.text.trim();
    _input.clear();
    setState(() => _turns.add(_Turn.user(text.isEmpty ? 'Skipped' : text)));
    _advanceTo(CoachRunner.submit(_flow!, _state, text));
  }

  // --- Action nodes (the only place side-effects happen) --------------------

  /// Runs a node's `action` token. Returns text for the coach to say next, or
  /// null to stay quiet. Never throws: a storage failure must not derail a
  /// conversation someone is having at a raw moment, so it degrades to silence
  /// the way AdService and NotificationService do.
  Future<String?> _runAction(CoachNode node) async {
    final a = node.action ?? '';
    try {
      if (a.startsWith('saveReflection')) {
        await _saveReflection(a);
        return null;
      }
      if (a == 'adjustPlan') {
        return await _adjustPlan();
      }
      if (a == 'addTodayIntention') {
        return await _addTodayIntention();
      }
      if (a.startsWith('navigate:')) {
        await Navigator.pushNamed(context, a.substring('navigate:'.length));
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  Future<void> _saveReflection(String token) async {
    final kind = token.endsWith(':relapse')
        ? JournalKind.relapseReflection
        : JournalKind.dailyReflection;
    final text = ReflectionComposer.compose(_state.vars);
    if (text.isEmpty) return;
    await journalRepo.add(
      kind: kind,
      text: text,
      emotion: _state.vars['feeling'] ?? _state.vars['mood'],
    );
  }

  /// Records the if-then coping plan this reflection just produced, and says
  /// what changed — a plan that quietly rewrites itself teaches nothing.
  Future<String?> _adjustPlan() async {
    final active = await copingPlanRepo.active();
    final revision = CopingPlanEngine.revise(vars: _state.vars, active: active);
    if (revision.action == PlanAction.none) return null;

    // Grab the outgoing strategy BEFORE applying, so the coach can name what
    // it replaced.
    String? previous;
    for (final p in active) {
      if (p.id == revision.supersededId) previous = p.strategy;
    }

    await copingPlanRepo.apply(revision);

    final trigger = triggerLabel(revision.trigger!).toLowerCase();
    return switch (revision.action) {
      PlanAction.create =>
        'Saved — when $trigger shows up, your plan is: ${revision.strategy}.',
      PlanAction.supersede =>
        'Updated your plan for $trigger — ${revision.strategy} replaces '
            '${previous ?? 'what was there before'}.',
      PlanAction.reaffirm =>
        "That's still your plan for $trigger. Knowing what works is its own kind of progress.",
      PlanAction.none => null,
    };
  }

  Future<String?> _addTodayIntention() async {
    final strategy = (_state.vars['plan'] ?? '').trim();
    if (strategy.isEmpty) return null;
    await DailyPlanStore.addIntention('Practice: $strategy');
    return "It's on today's plan.";
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // --- UI -------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    final flow = _flow;
    if (flow == null) return _MissingFlow(theme: theme);

    return Scaffold(
      backgroundColor: theme.scaffoldBg,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBg,
        title: Text(flow.title,
            style: appCss.titleSemi18.textColor(theme.darkText)),
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: theme.darkText),
          onPressed: () => route.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              itemCount: _turns.length,
              itemBuilder: (_, i) => _Bubble(turn: _turns[i], theme: theme),
            ),
          ),
          _Composer(
            theme: theme,
            node: _node,
            terminal: _isTerminal(_node),
            done: _done,
            input: _input,
            onContinue: _continue,
            onChoose: _choose,
            onSubmit: _submit,
            onDone: () => route.pop(context),
          ),
        ],
      ),
    );
  }
}

// --- Transcript -------------------------------------------------------------

class _Turn {
  const _Turn(this.text, {required this.isCoach});
  const _Turn.coach(String text) : this(text, isCoach: true);
  const _Turn.user(String text) : this(text, isCoach: false);

  final String text;
  final bool isCoach;
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.turn, required this.theme});
  final _Turn turn;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    final coach = turn.isCoach;
    return Align(
      alignment: coach ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.82,
        ),
        decoration: BoxDecoration(
          color: coach ? theme.cardBg : theme.primary,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(coach ? 4 : 18),
            bottomRight: Radius.circular(coach ? 18 : 4),
          ),
          border: coach ? Border.all(color: theme.stroke) : null,
        ),
        child: Text(
          turn.text,
          style: appCss.body14
              .textColor(coach ? theme.darkText : Colors.white),
        ),
      ),
    );
  }
}

// --- Bottom composer --------------------------------------------------------

class _Composer extends StatelessWidget {
  const _Composer({
    required this.theme,
    required this.node,
    required this.terminal,
    required this.done,
    required this.input,
    required this.onContinue,
    required this.onChoose,
    required this.onSubmit,
    required this.onDone,
  });

  final AppTheme theme;
  final CoachNode node;
  final bool terminal;
  final bool done;
  final TextEditingController input;
  final VoidCallback onContinue;
  final void Function(int) onChoose;
  final VoidCallback onSubmit;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        12 + MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBg,
        border: Border(top: BorderSide(color: theme.stroke)),
      ),
      child: SafeArea(top: false, child: _child(context)),
    );
  }

  Widget _child(BuildContext context) {
    if (terminal) {
      return PrimaryButton(label: 'Done', onPressed: onDone);
    }
    switch (node.type) {
      case 'choice':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < node.choices.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _ChoiceButton(
                  label: node.choices[i].label,
                  theme: theme,
                  onTap: () => onChoose(i),
                ),
              ),
          ],
        );
      case 'input':
        return Row(
          children: [
            Expanded(
              child: TextField(
                controller: input,
                minLines: 1,
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
                style: appCss.body14.textColor(theme.darkText),
                decoration: InputDecoration(
                  hintText: 'Type your answer…',
                  hintStyle: appCss.body14.textColor(theme.lightText),
                  filled: true,
                  fillColor: theme.fieldBg,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (_) => onSubmit(),
              ),
            ),
            const SizedBox(width: 10),
            _SendButton(theme: theme, onTap: onSubmit),
          ],
        );
      case 'message':
      default:
        return PrimaryButton(label: 'Continue', onPressed: onContinue);
    }
  }
}

class _ChoiceButton extends StatelessWidget {
  const _ChoiceButton(
      {required this.label, required this.onTap, required this.theme});
  final String label;
  final VoidCallback onTap;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: theme.primarySoft,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Text(label,
              style: appCss.medium14.textColor(theme.primary)),
        ),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({required this.theme, required this.onTap});
  final AppTheme theme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: theme.primary,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.all(14),
          child: Icon(Icons.arrow_upward_rounded, color: Colors.white),
        ),
      ),
    );
  }
}

class _MissingFlow extends StatelessWidget {
  const _MissingFlow({required this.theme});
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.scaffoldBg,
      appBar: AppBar(backgroundColor: theme.scaffoldBg),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            "This conversation isn't available right now.",
            textAlign: TextAlign.center,
            style: appCss.body14.textColor(theme.lightText),
          ),
        ),
      ),
    );
  }
}
