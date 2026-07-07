import '../data/enums.dart';

/// One beat of a guided session. [pause] marks a "sit with this / breathe" beat
/// the player styles differently and lingers on.
class SessionBlock {
  const SessionBlock({required this.text, this.pause = false});

  final String text;
  final bool pause;

  factory SessionBlock.fromJson(Map<String, dynamic> j) => SessionBlock(
        text: j['text'] as String? ?? '',
        pause: j['pause'] as bool? ?? false,
      );
}

/// A guided, self-paced text session (mindfulness, ACT, compassion, …). The
/// player advances one block at a time.
class GuidedSession {
  const GuidedSession({
    required this.id,
    required this.title,
    required this.intro,
    required this.type,
    required this.minutes,
    required this.blocks,
  });

  final String id;
  final String title;
  final String intro;
  final SessionType type;
  final int minutes;
  final List<SessionBlock> blocks;

  factory GuidedSession.fromJson(Map<String, dynamic> j) => GuidedSession(
        id: j['id'] as String,
        title: j['title'] as String? ?? '',
        intro: j['intro'] as String? ?? '',
        type: _typeFrom(j['type'] as String?),
        minutes: (j['minutes'] as num?)?.toInt() ?? 5,
        blocks: (j['blocks'] as List?)
                ?.map((e) => SessionBlock.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
      );

  static SessionType _typeFrom(String? name) {
    for (final t in SessionType.values) {
      if (t.name == name) return t;
    }
    return SessionType.mindfulness;
  }
}
