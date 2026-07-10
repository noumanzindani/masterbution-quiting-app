/// One step in the emergency recovery sequence. Each maps to an in-the-moment
/// calming tool the [EmergencyModeScreen] renders inline (no navigation away,
/// so the sequence can't be abandoned into an ad-bearing screen).
enum EmergencyStep { breathe, ground, surf, reflect, close }

/// The escalated cousin of the panic hub. Where the hub is a *menu* of tools,
/// emergency mode is a *forced sequence*: at a peak-intensity urge, choosing
/// between options is itself too much load, so the app walks one calming step
/// at a time.
///
/// Pure by design — the "when to escalate" rule and the step order live here so
/// every entry point (the urge log sheet, the panic hub) shares one tested
/// decision and the trigger can't drift.
class EmergencyFlow {
  const EmergencyFlow._();

  /// Urges at or above this (of 10) are treated as a crisis: the plan frames
  /// "> 9/10" as the escalation point, and 9 is inclusive.
  static const int escalationThreshold = 9;

  static bool shouldEscalate(int intensity) => intensity >= escalationThreshold;

  /// The fixed, ordered sequence: settle the body, come back to the present,
  /// let the wave pass, name what happened, then a calm close.
  static const List<EmergencyStep> steps = [
    EmergencyStep.breathe,
    EmergencyStep.ground,
    EmergencyStep.surf,
    EmergencyStep.reflect,
    EmergencyStep.close,
  ];
}
