import 'package:dinarwise/core/analytics/analytics_events.dart';
import 'package:dinarwise/core/analytics/analytics_service.dart';
import 'package:dinarwise/core/diagnostics/crash_reporting_service.dart';
import 'package:dinarwise/core/firebase/firebase_bootstrap.dart';
import 'package:dinarwise/core/performance/performance_service.dart';
import 'package:dinarwise/core/preferences/app_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _RecordedEvent {
  const _RecordedEvent(this.name, this.parameters);
  final String name;
  final Map<String, Object>? parameters;
}

class _FakeAnalyticsBackend implements AnalyticsBackend {
  bool enabled = false;
  bool throwOnLog = false;
  final events = <_RecordedEvent>[];
  final properties = <String, String?>{};

  @override
  Future<void> log(String name, Map<String, Object>? parameters) async {
    if (throwOnLog) throw StateError('test failure');
    events.add(_RecordedEvent(name, parameters));
  }

  @override
  Future<void> setCollectionEnabled(bool enabled) async {
    this.enabled = enabled;
  }

  @override
  Future<void> setProperty(String name, String? value) async {
    properties[name] = value;
  }
}

class _FakeCrashBackend implements CrashReportingBackend {
  bool enabled = false;
  int errors = 0;

  @override
  Future<void> recordError(Object error, StackTrace stack,
      {bool fatal = false}) async {
    errors++;
  }

  @override
  Future<void> recordFlutterError(FlutterErrorDetails details,
      {bool fatal = false}) async {
    errors++;
  }

  @override
  Future<void> setCollectionEnabled(bool enabled) async {
    this.enabled = enabled;
  }

  @override
  Future<void> setKey(String key, Object value) async {}
}

void main() {
  test('analytics service can be enabled automatically', () async {
    final backend = _FakeAnalyticsBackend();
    final service = AnalyticsService(backend);
    await service.setEnabled(true);
    service.incomeAdded('SAR');
    await Future<void>.delayed(Duration.zero);
    expect(service.enabled, isTrue);
    expect(backend.enabled, isTrue);
    expect(backend.events.single.name, AnalyticsEvents.incomeAdded);
  });

  test('Firebase bootstrap enables Analytics regardless of old preference',
      () async {
    SharedPreferences.setMockInitialValues({
      'analytics_allowed': false,
      'diagnostics_allowed': false,
    });
    final preferences = AppPreferences(await SharedPreferences.getInstance());
    await preferences.migrateAutomaticTelemetryPreferences();
    final backend = _FakeAnalyticsBackend();
    final crashBackend = _FakeCrashBackend();

    final services = await FirebaseBootstrap.initialize(
      initializer: () async {},
      componentsFactory: () => (
        analytics: AnalyticsService(backend),
        crashReporting: CrashReportingService(crashBackend),
        performance: PerformanceService(null),
      ),
    );

    expect(services.initializationStatus.isInitialized, isTrue);
    expect(services.analytics.enabled, isTrue);
    expect(backend.enabled, isTrue);
    expect(services.crashReporting.enabled, isTrue);
    expect(crashBackend.enabled, isTrue);
    expect(services.performance.enabled, isTrue);
    expect(
      (await SharedPreferences.getInstance()).containsKey('analytics_allowed'),
      isFalse,
    );
    expect(
      (await SharedPreferences.getInstance())
          .containsKey('diagnostics_allowed'),
      isFalse,
    );

    final restartedBackend = _FakeAnalyticsBackend();
    final restartedServices = await FirebaseBootstrap.initialize(
      initializer: () async {},
      componentsFactory: () => (
        analytics: AnalyticsService(restartedBackend),
        crashReporting: CrashReportingService(null),
        performance: PerformanceService(null),
      ),
    );
    expect(restartedServices.analytics.enabled, isTrue);
    expect(restartedBackend.enabled, isTrue);
  });

  test('Firebase initialization failure is observable and non-blocking',
      () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = AppPreferences(await SharedPreferences.getInstance());

    final services = await FirebaseBootstrap.initialize(
      initializer: () async => throw StateError('safe test failure'),
    );

    expect(services.initializationStatus.isInitialized, isFalse);
    expect(services.initializationStatus.errorType, 'StateError');
    expect(services.analytics.enabled, isFalse);
    expect(await preferences.getOrCreateLocalProfileId(), isNotEmpty);
  });

  test('typed expense event contains only privacy-safe parameters', () async {
    final backend = _FakeAnalyticsBackend();
    final service = AnalyticsService(backend, enabled: true);
    service.expenseSaved(
      edited: false,
      categoryType: 'custom',
      currency: 'AED',
    );
    await Future<void>.delayed(Duration.zero);
    final event = backend.events.single;
    expect(event.name, AnalyticsEvents.expenseAdded);
    expect(event.parameters, {
      AnalyticsParameters.categoryType: 'custom',
      AnalyticsParameters.currency: 'AED',
      AnalyticsParameters.entrySource: 'manual',
    });
    const forbidden = {
      'amount',
      'balance',
      'merchant',
      'notes',
      'description',
      'profile_id',
      'record_id',
    };
    expect(event.parameters!.keys.toSet().intersection(forbidden), isEmpty);
    expect(event.parameters!.values, isNot(contains('Private merchant')));
    expect(event.parameters!.values, isNot(contains('Private notes')));
  });

  test('user-created category names are always normalized to custom', () async {
    final backend = _FakeAnalyticsBackend();
    final service = AnalyticsService(backend, enabled: true);

    service.expenseSaved(
      edited: false,
      categoryType: 'Private family category',
      currency: 'SAR',
    );
    await Future<void>.delayed(Duration.zero);

    expect(
      backend.events.single.parameters![AnalyticsParameters.categoryType],
      'custom',
    );
    expect(
      backend.events.single.parameters!.values,
      isNot(contains('Private family category')),
    );
  });

  test('duplicate screen calls do not create duplicate events', () async {
    final backend = _FakeAnalyticsBackend();
    final service = AnalyticsService(backend, enabled: true);
    service.screen('dashboard');
    service.screen('dashboard');
    await Future<void>.delayed(Duration.zero);
    expect(backend.events.where((event) => event.name == 'screen_view'),
        hasLength(1));
  });

  test('analytics backend failures never escape to user actions', () async {
    final backend = _FakeAnalyticsBackend()..throwOnLog = true;
    final service = AnalyticsService(backend, enabled: true);
    expect(() => service.expenseAddStarted(), returnsNormally);
    await Future<void>.delayed(Duration.zero);
  });

  test('automatic Firebase lifecycle events are not manually declared', () {
    const automaticEvents = {
      'first_open',
      'app_open',
      'session_start',
      'user_engagement',
      'app_update',
    };
    const customEvents = {
      AnalyticsEvents.onboardingStarted,
      AnalyticsEvents.onboardingCompleted,
      AnalyticsEvents.privacyPolicyAccepted,
      AnalyticsEvents.tutorialStarted,
      AnalyticsEvents.incomeAdded,
      AnalyticsEvents.expenseAdded,
    };
    expect(customEvents.intersection(automaticEvents), isEmpty);
  });

  test('Crashlytics supports automatic enablement', () async {
    final backend = _FakeCrashBackend();
    final service = CrashReportingService(backend);
    await service.recordUnexpected(StateError('test'), StackTrace.current);
    expect(backend.errors, 0);

    await service.setEnabled(true);
    await service.recordUnexpected(StateError('test'), StackTrace.current);
    expect(backend.enabled, isTrue);
    expect(backend.errors, 1);

    await service.setEnabled(false);
    await service.recordUnexpected(StateError('test'), StackTrace.current);
    expect(backend.errors, 1);
  });

  test('tutorial events suppress rebuild duplicates and contain safe IDs',
      () async {
    final backend = _FakeAnalyticsBackend();
    final service = AnalyticsService(backend, enabled: true);

    service.tutorialStarted(1, replayed: false);
    service.tutorialStepViewed(1, 'dashboard_summary');
    service.tutorialStepViewed(1, 'dashboard_summary');
    service.tutorialCompleted(1);
    service.tutorialCompleted(1);
    await Future<void>.delayed(Duration.zero);

    expect(
      backend.events
          .where((event) => event.name == AnalyticsEvents.tutorialStepViewed),
      hasLength(1),
    );
    expect(
      backend.events
          .where((event) => event.name == AnalyticsEvents.tutorialCompleted),
      hasLength(1),
    );
    expect(
      backend.events.expand((event) => event.parameters?.values ?? const []),
      isNot(contains('merchant name')),
    );
  });
}
