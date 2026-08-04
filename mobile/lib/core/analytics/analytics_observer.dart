import 'package:dinarwise/core/analytics/analytics_service.dart';
import 'package:flutter/widgets.dart';

/// Central GoRouter-compatible screen tracker. Route names are generic and
/// contain no IDs or user-entered data. Consecutive duplicates are suppressed
/// by [AnalyticsService].
class AnalyticsNavigationObserver extends NavigatorObserver {
  AnalyticsNavigationObserver(this.analytics);

  final AnalyticsService analytics;

  void _track(Route<dynamic>? route) {
    final name = route?.settings.name;
    if (name != null && name.isNotEmpty) analytics.screen(name);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _track(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _track(newRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _track(previousRoute);
  }
}
