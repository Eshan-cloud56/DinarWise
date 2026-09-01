import 'package:dinarwise/core/analytics/analytics_service.dart';
import 'package:dinarwise/core/diagnostics/crash_reporting_service.dart';
import 'package:dinarwise/core/performance/performance_service.dart';
import 'package:dinarwise/firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';

enum FirebaseInitializationState { initialized, failed }

class FirebaseInitializationStatus {
  const FirebaseInitializationStatus._(this.state, this.errorType);

  const FirebaseInitializationStatus.initialized()
      : this._(FirebaseInitializationState.initialized, null);

  const FirebaseInitializationStatus.failed(String errorType)
      : this._(FirebaseInitializationState.failed, errorType);

  final FirebaseInitializationState state;
  final String? errorType;

  bool get isInitialized => state == FirebaseInitializationState.initialized;
}

typedef FirebaseInitializer = Future<void> Function();
typedef FirebaseComponentsFactory = ({
  AnalyticsService analytics,
  CrashReportingService crashReporting,
  PerformanceService performance,
})
    Function();

class FirebaseServices {
  const FirebaseServices({
    required this.analytics,
    required this.crashReporting,
    required this.performance,
    required this.initializationStatus,
  });

  final AnalyticsService analytics;
  final CrashReportingService crashReporting;
  final PerformanceService performance;
  final FirebaseInitializationStatus initializationStatus;
}

abstract final class FirebaseBootstrap {
  static Future<FirebaseServices> initialize({
    FirebaseInitializer? initializer,
    FirebaseComponentsFactory? componentsFactory,
  }) async {
    try {
      await (initializer ?? _initializeFirebase)();
      final components = (componentsFactory ?? _firebaseComponents)();
      final analyticsEnabled = await components.analytics.setEnabled(true);
      if (!analyticsEnabled) {
        throw StateError('analytics_enablement_failed');
      }
      await components.crashReporting.setEnabled(true);
      await components.performance.setEnabled(true);
      components.crashReporting.installGlobalHandlers();
      return FirebaseServices(
        analytics: components.analytics,
        crashReporting: components.crashReporting,
        performance: components.performance,
        initializationStatus: const FirebaseInitializationStatus.initialized(),
      );
    } catch (error) {
      final errorType = error.runtimeType.toString();
      if (!kReleaseMode) {
        debugPrint('Firebase initialization failed ($errorType). '
            'DinarWise will continue with local features.');
      }
      return FirebaseServices(
        analytics: AnalyticsService(const NoopAnalyticsBackend()),
        crashReporting: CrashReportingService(null),
        performance: PerformanceService(null),
        initializationStatus: FirebaseInitializationStatus.failed(errorType),
      );
    }
  }

  static Future<void> _initializeFirebase() => Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

  static ({
    AnalyticsService analytics,
    CrashReportingService crashReporting,
    PerformanceService performance,
  }) _firebaseComponents() => (
        analytics: AnalyticsService(
          FirebaseAnalyticsBackend(FirebaseAnalytics.instance),
        ),
        crashReporting: CrashReportingService(
          FirebaseCrashReportingBackend(FirebaseCrashlytics.instance),
        ),
        performance: PerformanceService(FirebasePerformance.instance),
      );
}
