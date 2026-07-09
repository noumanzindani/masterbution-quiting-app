/// Plain data models for the rule-based coach. A [CoachFlow] is a decision tree
/// authored as JSON in `assets/content/coach/flows/*.json`; the pure
/// [CoachRunner] walks it and one generic screen renders it. No Flutter, no
/// Isar — so flows parse and test trivially, and adding a flow needs no code.
///
/// Every `fromJson` is defensive: a missing or renamed field degrades to a
/// sensible default rather than throwing, so a small content typo can never
/// crash the coach mid-conversation.
library;

/// One branch offered at a `choice` node.
class CoachChoice {
  const CoachChoice({
    required this.label,
    this.next,
    this.effect = const {},
  });

  /// Button text shown to the user.
  final String label;

  /// Node id to move to when picked (null = end the flow).
  final String? next;

  /// Variables to record when picked, e.g. `{"trigger": "boredom"}`. These feed
  /// later messages and the saved reflection.
  final Map<String, String> effect;

  factory CoachChoice.fromJson(Map<String, dynamic> j) => CoachChoice(
        label: j['label'] as String? ?? '',
        next: j['next'] as String?,
        effect: _stringMap(j['effect']),
      );
}

/// A single node in a coach flow. [type] is one of:
/// - `message` — coach says [text], then continues to [next].
/// - `choice`  — coach says [text], user picks one of [choices].
/// - `input`   — coach asks [text]; the typed answer is stored under [key].
/// - `action`  — a side-effect ([action]) the UI performs, then continues.
/// - `end`     — terminal; [text] is the closing message.
class CoachNode {
  const CoachNode({
    required this.id,
    this.type = 'message',
    this.text = '',
    this.next,
    this.key,
    this.action,
    this.choices = const [],
  });

  final String id;
  final String type;
  final String text;

  /// Next node for `message` / `input` / `action` nodes (null ends the flow).
  final String? next;

  /// Variable name an `input` node stores its answer under.
  final String? key;

  /// Side-effect token for an `action` node (e.g. `saveReflection`,
  /// `navigate:breathing`). Interpreted by the UI layer, never the pure runner.
  final String? action;

  final List<CoachChoice> choices;

  factory CoachNode.fromJson(Map<String, dynamic> j) => CoachNode(
        id: j['id'] as String,
        type: j['type'] as String? ?? 'message',
        text: j['text'] as String? ?? '',
        next: j['next'] as String?,
        key: j['key'] as String?,
        action: j['action'] as String?,
        choices: (j['choices'] as List?)
                ?.map((e) => CoachChoice.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
      );
}

/// A whole conversational flow: an entry node id plus its nodes.
class CoachFlow {
  const CoachFlow({
    required this.id,
    required this.title,
    required this.entry,
    required this.nodes,
  });

  final String id;
  final String title;

  /// Id of the node the flow starts at.
  final String entry;

  final List<CoachNode> nodes;

  CoachNode? nodeById(String id) {
    for (final n in nodes) {
      if (n.id == id) return n;
    }
    return null;
  }

  factory CoachFlow.fromJson(Map<String, dynamic> j) => CoachFlow(
        id: j['id'] as String,
        title: j['title'] as String? ?? '',
        entry: j['entry'] as String? ?? '',
        nodes: (j['nodes'] as List?)
                ?.map((e) => CoachNode.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
      );
}

Map<String, String> _stringMap(Object? raw) {
  if (raw is! Map) return const {};
  return {
    for (final e in raw.entries) e.key.toString(): e.value.toString(),
  };
}
