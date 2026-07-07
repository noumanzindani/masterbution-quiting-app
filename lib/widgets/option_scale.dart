import '../config.dart';

/// A labelled single-choice scale rendered as wrapping chips. Used across the
/// onboarding screeners and the log sheet so every "pick one of N" question
/// looks and behaves identically.
class OptionScale extends StatelessWidget {
  const OptionScale({
    super.key,
    this.prompt,
    required this.options,
    required this.selectedIndex,
    required this.onSelected,
  });

  final String? prompt;
  final List<String> options;
  final int? selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (prompt != null) ...[
          Text(prompt!, style: appCss.titleSemi16.textColor(theme.darkText)),
          const SizedBox(height: 12),
        ],
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (var i = 0; i < options.length; i++)
              _Chip(
                label: options[i],
                selected: i == selectedIndex,
                onTap: () => onSelected(i),
                theme: theme,
              ),
          ],
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.theme,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? theme.primary : theme.fieldBg,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Text(
            label,
            style: appCss.medium14
                .textColor(selected ? Colors.white : theme.darkText),
          ),
        ),
      ),
    );
  }
}
