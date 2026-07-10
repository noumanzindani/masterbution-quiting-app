import '../config.dart';

/// A tappable card row: icon, title, subtitle, chevron. Pushes [route] on tap.
/// Shared by the Tools/Insights tab landings.
class NavRow extends StatelessWidget {
  const NavRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
    required this.theme,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String route;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: theme.cardBg,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => Navigator.pushNamed(context, route),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: theme.stroke),
          ),
          child: Row(
            children: [
              Icon(icon, color: theme.primary, size: 24),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: appCss.titleSemi16.textColor(theme.darkText)),
                    Text(subtitle,
                        style: appCss.label12.textColor(theme.lightText)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: theme.lightText),
            ],
          ),
        ),
      ),
    );
  }
}
