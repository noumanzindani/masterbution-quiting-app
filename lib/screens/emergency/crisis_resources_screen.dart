import 'package:url_launcher/url_launcher.dart';

import '../../config.dart';
import 'crisis_content.dart';
import 'emergency_scaffold.dart';

/// Always-reachable crisis resources. NO-AD route, with a prominent
/// "not medical care" disclaimer. Tapping a resource launches the phone/SMS/web
/// handler via url_launcher.
class CrisisResourcesScreen extends StatelessWidget {
  const CrisisResourcesScreen({super.key});

  Future<void> _launch(BuildContext context, String uri) async {
    final ok = await launchUrl(
      Uri.parse(uri),
      mode: LaunchMode.externalApplication,
    );
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Couldn’t open that on this device.')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    return EmergencyScaffold(
      child: ListView(
        children: [
          Text(language(context, appFonts.crisisResources),
              style: appCss.headingBold22.textColor(theme.darkText)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: theme.cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: theme.stroke),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded,
                    size: 18, color: theme.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    language(context, appFonts.notMedicalCare),
                    style: appCss.label12.textColor(theme.darkText),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          for (final r in crisisResources)
            _ResourceCard(
              resource: r,
              theme: theme,
              onTap: () => _launch(context, r.uri),
            ),
          const SizedBox(height: 8),
          Text(
            'If you are in immediate danger, call your local emergency number.',
            textAlign: TextAlign.center,
            style: appCss.label12.textColor(theme.lightText),
          ),
        ],
      ),
    );
  }
}

class _ResourceCard extends StatelessWidget {
  const _ResourceCard({
    required this.resource,
    required this.onTap,
    required this.theme,
  });
  final CrisisResource resource;
  final VoidCallback onTap;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.stroke),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(resource.title,
                style: appCss.titleSemi16.textColor(theme.darkText)),
            const SizedBox(height: 4),
            Text(resource.detail,
                style: appCss.body14.textColor(theme.lightText)),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.primary,
                  side: BorderSide(color: theme.primary),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: onTap,
                child: Text(resource.actionLabel,
                    style: appCss.buttonSemi16.textColor(theme.primary)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
