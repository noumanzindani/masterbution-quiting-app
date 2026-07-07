import 'package:flutter/material.dart';

/// Thin navigation helper (the global `route` singleton). Keeps navigation
/// call-sites terse and centralises push/pop behaviour.
class NavigationClass {
  Future<T?> pushNamed<T>(BuildContext context, String name, {Object? args}) {
    return Navigator.pushNamed<T>(context, name, arguments: args);
  }

  Future<T?> pushReplacement<T>(BuildContext context, String name,
      {Object? args}) {
    return Navigator.pushReplacementNamed(context, name, arguments: args);
  }

  void pop<T>(BuildContext context, [T? result]) => Navigator.pop(context, result);

  void popToFirst(BuildContext context) =>
      Navigator.popUntil(context, (r) => r.isFirst);
}
