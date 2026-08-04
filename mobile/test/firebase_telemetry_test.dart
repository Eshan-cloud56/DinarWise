import 'package:dinarwise/core/analytics/analytics_events.dart';
import 'package:dinarwise/core/analytics/analytics_service.dart';
import 'package:dinarwise/core/diagnostics/crash_reporting_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

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
  test('analytics is disabled before consent and after withdrawal', () async {
    final backend = _FakeAnalyticsBackend();
    final service = AnalyticsService(backend);
    service.incomeAdded('SAR');
    await Future<void>.delayed(Duration.zero);
    expect(backend.events, isEmpty);

    await service.setEnabled(true);
    service.incomeAdded('SAR');
    await Future<void>.delayed(Duration.zero);
    expect(backend.events.single.name, AnalyticsEvents.incomeAdded);

    await service.setEnabled(false);
    service.incomeAdded('SAR');
    await Future<void>.delayed(Duration.zero);
    expect(backend.events, hasLength(1));
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

  test('Crashlytics respects diagnostic consent', () async {
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
}
