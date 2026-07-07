import '../../config.dart';

/// Shared shell for every emergency/urge screen: the calming background, a
/// dismiss affordance, and generous padding. These are NO-AD surfaces by route
/// (see [AdPolicy.noAdRoutes]) — never place a [BannerAdWidget] here.
class EmergencyScaffold extends StatelessWidget {
  const EmergencyScaffold({
    super.key,
    required this.child,
    this.onClose,
    this.showClose = true,
  });

  final Widget child;
  final VoidCallback? onClose;
  final bool showClose;

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    return Scaffold(
      backgroundColor: theme.calm,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (showClose)
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(Icons.close_rounded, color: theme.darkText),
                    onPressed: onClose ?? () => route.pop(context),
                  ),
                ),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}
