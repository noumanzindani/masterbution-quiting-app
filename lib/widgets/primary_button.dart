import '../config.dart';

/// The app's standard filled call-to-action. Centralised so every primary
/// button shares the same height, radius, disabled and loading treatment.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.color,
    this.foreground = Colors.white,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final Color? color;
  final Color foreground;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: color ?? theme.primary,
        disabledBackgroundColor: (color ?? theme.primary).withValues(alpha: 0.5),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      onPressed: loading ? null : onPressed,
      child: loading
          ? SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.4,
                valueColor: AlwaysStoppedAnimation(foreground),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20, color: foreground),
                  const SizedBox(width: 8),
                ],
                Text(label, style: appCss.buttonSemi16.textColor(foreground)),
              ],
            ),
    );
  }
}
