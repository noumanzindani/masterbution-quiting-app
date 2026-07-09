import '../content/coach_models.dart';

/// Immutable snapshot of a coach conversation: where we are ([nodeId]), what the
/// user has told us so far ([vars]), and whether the flow has ended ([done]).
///
/// Kept immutable so the widget layer can hold a list of past states for a
/// scrollable transcript, and so the [CoachRunner] transitions are pure.
class CoachState {
  const CoachState({
    required this.nodeId,
    this.vars = const {},
    this.done = false,
  });

  final String nodeId;
  final Map<String, String> vars;
  final bool done;

  CoachState copyWith({
    String? nodeId,
    Map<String, String>? vars,
    bool? done,
  }) =>
      CoachState(
        nodeId: nodeId ?? this.nodeId,
        vars: vars ?? this.vars,
        done: done ?? this.done,
      );
}

/// Pure state machine over a [CoachFlow]. Every method takes a state and returns
/// a new one — no I/O, no navigation, no persistence — which is exactly what
/// makes the entire coach conversation unit-testable without a widget.
///
/// Side-effects (save a reflection, open breathing, trip the ad cooldown) live
/// as `action` tokens on nodes; the UI layer interprets them. The runner only
/// ever moves between nodes and records answers.
class CoachRunner {
  const CoachRunner._();

  /// Fresh conversation at the flow's entry node.
  static CoachState start(CoachFlow flow) => CoachState(nodeId: flow.entry);

  /// The node the [state] currently sits on.
  static CoachNode current(CoachFlow flow, CoachState state) =>
      flow.nodeById(state.nodeId) ??
      CoachNode(id: state.nodeId, type: 'end');

  /// Advance a `message` or `action` node to its `next` (or finish the flow).
  static CoachState proceed(CoachFlow flow, CoachState state) =>
      _goTo(flow, state, current(flow, state).next);

  /// Pick choice [index] on a `choice` node: record its effect, follow its next.
  /// An out-of-range index is a no-op (defensive against a stale tap).
  static CoachState choose(CoachFlow flow, CoachState state, int index) {
    final node = current(flow, state);
    if (index < 0 || index >= node.choices.length) return state;
    final choice = node.choices[index];
    final merged = {...state.vars, ...choice.effect};
    return _goTo(flow, state.copyWith(vars: merged), choice.next);
  }

  /// Submit free text on an `input` node: store it under the node's `key`, then
  /// follow its `next`.
  static CoachState submit(CoachFlow flow, CoachState state, String text) {
    final node = current(flow, state);
    final vars = {...state.vars};
    if (node.key != null) vars[node.key!] = text;
    return _goTo(flow, state.copyWith(vars: vars), node.next);
  }

  /// Move to [nextId], marking the flow done when there's nowhere to go or the
  /// destination is an `end` node.
  static CoachState _goTo(CoachFlow flow, CoachState state, String? nextId) {
    if (nextId == null) return state.copyWith(done: true);
    final dest = flow.nodeById(nextId);
    return state.copyWith(nodeId: nextId, done: dest?.type == 'end');
  }
}
