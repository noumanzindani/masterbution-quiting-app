import 'config.dart';
import 'providers/settings_provider.dart';
import 'screens/lock/lock_screen.dart';
import 'services/ad_guard_observer.dart';
import 'services/app_init.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInit.run();
  runApp(const MomentumApp());
}

/// Root app. Registers the always-on providers (theme + language) and rebuilds
/// [MaterialApp] when either changes. Feature providers are added to this list
/// as later phases introduce them.
class MomentumApp extends StatelessWidget {
  const MomentumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeService(prefs)),
        ChangeNotifierProvider(create: (_) => LanguageProvider(prefs)),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: const _AppView(),
    );
  }
}

class _AppView extends StatefulWidget {
  const _AppView();

  @override
  State<_AppView> createState() => _AppViewState();
}

class _AppViewState extends State<_AppView> with WidgetsBindingObserver {
  final AdGuardObserver _adGuard = AdGuardObserver();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Re-lock only after the app has been backgrounded past this grace period,
  /// so quick app-switches don't nag for the PIN.
  static const _lockGrace = Duration(seconds: 15);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      prefs.setInt(
          session.lastPausedAt, DateTime.now().millisecondsSinceEpoch);
    } else if (state == AppLifecycleState.resumed) {
      if (_maybeReLock()) return; // don't also show an ad while locking
      // App resume is a neutral moment — a capped interstitial may show. The
      // policy still blocks it in any no-ad zone or during a lapse cooldown.
      adService.maybeShowInterstitial();
    }
  }

  /// Push the lock screen on resume if app-lock is on and we've been away past
  /// the grace window. Returns true if it locked.
  bool _maybeReLock() {
    final settings = context.read<SettingsProvider>();
    if (!settings.appLockEnabled) return false;
    if (adService.currentRoute == routeName.lock) return false; // already locked
    final pausedMs = prefs.getInt(session.lastPausedAt);
    if (pausedMs != null) {
      final away = DateTime.now().millisecondsSinceEpoch - pausedMs;
      if (away < _lockGrace.inMilliseconds) return false;
    }
    rootNavigatorKey.currentState?.pushNamed(
      routeName.lock,
      arguments: const LockArgs(popOnSuccess: true),
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final themeService = context.watch<ThemeService>();
    // Rebuild on locale change too (RTL wiring arrives with ar in Phase 7).
    context.watch<LanguageProvider>();

    return MaterialApp(
      title: 'Momentum',
      debugShowCheckedModeBanner: false,
      themeMode: themeService.themeMode,
      theme: AppTheme.fromType(ThemeType.light).themeData,
      darkTheme: AppTheme.fromType(ThemeType.dark).themeData,
      navigatorKey: rootNavigatorKey,
      initialRoute: routeName.splash,
      routes: appRoute.routes,
      navigatorObservers: [_adGuard],
    );
  }
}
