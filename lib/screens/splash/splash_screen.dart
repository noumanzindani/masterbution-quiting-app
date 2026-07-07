import '../../config.dart';

/// Decides the first screen: onboarding for a fresh install, otherwise home.
/// (App-lock gating will wrap this in Phase 1.)
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _decideNext());
  }

  void _decideNext() {
    final onboarded = prefs.getBool(session.isOnboarded) ?? false;
    if (!onboarded) {
      route.pushReplacement(context, routeName.onboarding);
      return;
    }
    final locked = prefs.getBool(session.appLockEnabled) ?? false;
    if (locked) {
      // Lock gates entry; on success it replaces itself with home.
      route.pushReplacement(context, routeName.lock);
    } else {
      route.pushReplacement(context, routeName.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBg,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 88,
              width: 88,
              decoration: BoxDecoration(
                color: theme.primarySoft,
                borderRadius: BorderRadius.circular(26),
              ),
              child: Icon(Icons.waves_rounded, size: 44, color: theme.primary),
            ),
            const SizedBox(height: 20),
            Text(
              language(context, appFonts.appName),
              style: appCss.displayBold28.textColor(theme.darkText),
            ),
          ],
        ),
      ),
    );
  }
}
