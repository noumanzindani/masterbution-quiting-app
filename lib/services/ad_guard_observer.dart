import '../config.dart';

/// Keeps [AdService.currentRoute] in lock-step with the navigation stack so the
/// ad policy always knows which screen is on top. This is the defence-in-depth
/// layer: even if a screen forgets to guard, the policy sees the no-ad route
/// name and blocks ads. Wired into `MaterialApp.navigatorObservers`.
class AdGuardObserver extends NavigatorObserver {
  void _sync(Route<dynamic>? route) {
    adService.currentRoute = route?.settings.name;
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _sync(route);

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) =>
      _sync(newRoute);

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _sync(previousRoute);

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _sync(previousRoute);
}
