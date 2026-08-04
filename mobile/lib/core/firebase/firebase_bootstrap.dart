import 'package:dinarwise/core/analytics/analytics_service.dart';
import 'package:dinarwise/core/diagnostics/crash_reporting_service.dart';
import 'package:dinarwise/core/performance/performance_service.dart';
import 'package:dinarwise/core/preferences/app_preferences.dart';
import 'package:dinarwise/firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';

class FirebaseServices {
  const FirebaseServices({
    required this.analytics,
    required this.crashReporting,
    required this.performance,
  });

  final AnalyticsService analytics;
  final CrashReportingService crashReporting;
  final PerformanceService performance;
}

abstract final class FirebaseBootstrap {
  static Future<FirebaseServices> initialize(AppPreferences preferences) async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      final analytics = AnalyticsService(
        FirebaseAnalyticsBackend(FirebaseAnalytics.instance),
      );
      final crash = CrashReportingService(
        FirebaseCrashReportingBackend(FirebaseCrashlytics.instance),
      );
      final performance = PerformanceService(FirebasePerformance.instance);
      await analytics.setEnabled(preferences.analyticsAllowed);
      await crash.setEnabled(preferences.diagnosticsAllowed);
      await performance.setEnabled(preferences.diagnosticsAllowed);
      crash.installGlobalHandlers();
      return FirebaseServices(
        analytics: analytics,
        crashReporting: crash,
        performance: performance,
      );
    } catch (_) {
      return FirebaseServices(
        analytics: AnalyticsService(const NoopAnalyticsBackend()),
        crashReporting: CrashReportingService(null),
        performance: PerformanceService(null),
      );
    }
  }
}
