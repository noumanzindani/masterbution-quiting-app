import 'dart:convert';

import '../../config.dart';
import '../../widgets/ad/banner_ad_widget.dart';
import '../../widgets/primary_button.dart';

/// Values & purpose module: pick the values that matter most and write why.
/// Reconnecting with values is a proven way to make an urge easier to refuse.
/// Selections persist in prefs so the app can reflect them back later.
class ValuesScreen extends StatefulWidget {
  const ValuesScreen({super.key});

  @override
  State<ValuesScreen> createState() => _ValuesScreenState();
}

class _ValuesScreenState extends State<ValuesScreen> {
  final Set<String> _chosen = {};
  final _reflection = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _chosen.addAll(_readChosen());
    _reflection.text = prefs.getString(session.valuesReflection) ?? '';
  }

  @override
  void dispose() {
    _reflection.dispose();
    super.dispose();
  }

  Set<String> _readChosen() {
    final raw = prefs.getString(session.chosenValues);
    if (raw == null) return {};
    try {
      return (jsonDecode(raw) as List).map((e) => e as String).toSet();
    } catch (_) {
      return {};
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await prefs.setString(session.chosenValues, jsonEncode(_chosen.toList()));
    await prefs.setString(
        session.valuesReflection, _reflection.text.trim());
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Saved your compass.')));
  }

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    final values = contentService.values;

    return Scaffold(
      backgroundColor: theme.scaffoldBg,
      appBar: AppBar(
        title: Text('Your values',
            style: appCss.headingBold22.textColor(theme.darkText)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Text(
            'Recovery isn\'t just about what you\'re leaving — it\'s about what you\'re moving toward. Pick the values that matter most to you.',
            style: appCss.body14.textColor(theme.lightText),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final v in values)
                GestureDetector(
                  onTap: () => setState(() =>
                      _chosen.contains(v.id) ? _chosen.remove(v.id) : _chosen.add(v.id)),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: _chosen.contains(v.id)
                          ? theme.primary
                          : theme.fieldBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(v.label,
                        style: appCss.medium14.textColor(_chosen.contains(v.id)
                            ? Colors.white
                            : theme.darkText)),
                  ),
                ),
            ],
          ),
          if (_chosen.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text('YOUR COMPASS',
                style: appCss.label12.textColor(theme.lightText)),
            const SizedBox(height: 10),
            for (final v in values.where((v) => _chosen.contains(v.id)))
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.explore_rounded,
                        size: 18, color: theme.primary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: '${v.label} — ',
                              style: appCss.medium14
                                  .textColor(theme.darkText)),
                          TextSpan(
                              text: v.description,
                              style: appCss.body14
                                  .textColor(theme.lightText)),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
          ],
          const SizedBox(height: 24),
          Text('Who do you want to be in recovery?',
              style: appCss.titleSemi16.textColor(theme.darkText)),
          const SizedBox(height: 10),
          TextField(
            controller: _reflection,
            maxLines: 4,
            minLines: 3,
            style: appCss.body16.textColor(theme.darkText),
            decoration: InputDecoration(
              hintText: 'A few words to come back to when it\'s hard…',
              hintStyle: appCss.body14.textColor(theme.lightText),
              filled: true,
              fillColor: theme.cardBg,
              contentPadding: const EdgeInsets.all(14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: theme.stroke),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: theme.stroke),
              ),
            ),
          ),
          const SizedBox(height: 20),
          PrimaryButton(label: 'Save', loading: _saving, onPressed: _save),
          const SizedBox(height: 20),
          const Center(child: BannerAdWidget()),
        ],
      ),
    );
  }
}
