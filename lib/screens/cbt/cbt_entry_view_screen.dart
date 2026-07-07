import '../../config.dart';
import '../../data/collections/cbt_entry.dart';
import '../../data/repositories/cbt_repo.dart';

/// Read-only view of a saved CBT entry. Pairs the worksheet template's prompts
/// (if still present) with the saved answers.
class CbtEntryViewScreen extends StatelessWidget {
  const CbtEntryViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    final entry = ModalRoute.of(context)?.settings.arguments as CbtEntry?;
    if (entry == null) {
      return Scaffold(appBar: AppBar(), body: const SizedBox.shrink());
    }

    final responses = CbtRepo.responsesOf(entry);
    final worksheet = contentService.worksheetById(entry.worksheetId);
    final local = entry.timestampUtc.toLocal();

    // Prefer the template's step order + prompts; fall back to raw keys.
    final rows = <({String prompt, String answer})>[];
    if (worksheet != null) {
      for (final s in worksheet.steps) {
        final a = responses[s.id];
        if (a != null && a.isNotEmpty) rows.add((prompt: s.prompt, answer: a));
      }
    } else {
      responses.forEach((k, v) => rows.add((prompt: k, answer: v)));
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBg,
      appBar: AppBar(
        title: Text(entry.title,
            style: appCss.titleSemi18.textColor(theme.darkText)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        children: [
          Text('${local.day}/${local.month}/${local.year}',
              style: appCss.label12.textColor(theme.lightText)),
          const SizedBox(height: 20),
          for (final r in rows) ...[
            Text(r.prompt,
                style: appCss.titleSemi16.textColor(theme.darkText)),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: theme.cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.stroke),
              ),
              child: Text(r.answer,
                  style: appCss.body16.textColor(theme.darkText)),
            ),
            const SizedBox(height: 18),
          ],
        ],
      ),
    );
  }
}
