import '../config.dart';
import '../content/content_models.dart';

/// Renders a list of [ArticleBlock]s (heading / paragraph / bullet list /
/// callout). Shared by the article reader and the program-day screen so all
/// long-form content looks identical.
class ContentBlocks extends StatelessWidget {
  const ContentBlocks({super.key, required this.blocks});

  final List<ArticleBlock> blocks;

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [for (final b in blocks) _Block(block: b, theme: theme)],
    );
  }
}

class _Block extends StatelessWidget {
  const _Block({required this.block, required this.theme});
  final ArticleBlock block;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    switch (block.type) {
      case 'h':
        return Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 8),
          child: Text(block.text,
              style: appCss.titleSemi18.textColor(theme.darkText)),
        );
      case 'list':
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final item in block.items)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 7, right: 10),
                        child: Container(
                          height: 6,
                          width: 6,
                          decoration: BoxDecoration(
                              color: theme.primary, shape: BoxShape.circle),
                        ),
                      ),
                      Expanded(
                        child: Text(item,
                            style: appCss.body16.textColor(theme.darkText)),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      case 'callout':
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.primarySoft,
            borderRadius: BorderRadius.circular(14),
            border: Border(left: BorderSide(color: theme.primary, width: 3)),
          ),
          child: Text(block.text,
              style: appCss.body16.textColor(theme.darkText)),
        );
      default: // 'p'
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(block.text,
              style: appCss.body16.textColor(theme.darkText)),
        );
    }
  }
}
