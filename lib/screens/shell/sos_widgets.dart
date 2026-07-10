import '../../config.dart';
import '../../widgets/primary_button.dart';

/// Full-width "I need help right now" bar — the Home tab's persistent,
/// one-tap path to the panic flow. Pinned above the tab content (the bottom
/// slot is occupied by the bottom-nav bar).
class SosBar extends StatelessWidget {
  const SosBar({super.key, required this.onTap, required this.theme});

  final VoidCallback onTap;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      color: theme.scaffoldBg,
      child: PrimaryButton(
        label: 'I need help right now',
        icon: Icons.shield_outlined,
        color: theme.accent,
        onPressed: onTap,
      ),
    );
  }
}

/// Small floating shield button shown on every non-Home tab — keeps the panic
/// flow exactly one tap away without repeating the full-width bar on every
/// screen.
class SosFab extends StatelessWidget {
  const SosFab({super.key, required this.onTap, required this.theme});

  final VoidCallback onTap;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'sosFab',
      backgroundColor: theme.accent,
      onPressed: onTap,
      child: const Icon(Icons.shield_outlined, color: Colors.white),
    );
  }
}
