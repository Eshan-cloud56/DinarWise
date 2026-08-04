import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract interface class CrashReportingBackend {
  Future<void> setCollectionEnabled(bool enabled);
  Future<void> recordFlutterError(FlutterErrorDetails details, {bool fatal});
  Future<void> recordError(Object error, StackTrace stack, {bool fatal});
  Future<void> setKey(String key, Object value);
}

class FirebaseCrashReportingBackend implements CrashReportingBackend {
  FirebaseCrashReportingBackend(this.crashlytics);
  final FirebaseCrashlytics crashlytics;

  @override
  Future<void> setCollectionEnabled(bool enabled) =>
      crashlytics.setCrashlyticsCollectionEnabled(enabled);
  @override
  Future<void> recordFlutterError(FlutterErrorDetails details,
          {bool fatal = false}) =>
      fatal
          ? crashlytics.recordFlutterFatalError(details)
          : crashlytics.recordFlutterError(details);
  @override
  Future<void> recordError(Object error, StackTrace stack,
          {bool fatal = false}) =>
      crashlytics.recordError(error, stack, fatal: fatal);
  @override
  Future<void> setKey(String key, Object value) =>
      crashlytics.setCustomKey(key, value);
}

class CrashReportingService {
  CrashReportingService(this._backend, {bool enabled = false})
      : _enabled = enabled;
  final CrashReportingBackend? _backend;
  bool _enabled;

  bool get enabled => _enabled;

  Future<void> setEnabled(bool value) async {
    _enabled = value;
    try {
      await _backend?.setCollectionEnabled(value);
    } catch (_) {}
  }

  Future<void> setSafeContext({
    String? screen,
    String? operation,
    String? language,
  }) async {
    if (!_enabled) return;
    try {
      if (screen != null) await _backend?.setKey('screen', screen);
      if (operation != null) await _backend?.setKey('operation', operation);
      if (language != null) await _backend?.setKey('app_language', language);
    } catch (_) {}
  }

  Future<void> recordUnexpected(
    Object error,
    StackTrace stack, {
    bool fatal = false,
  }) async {
    if (!_enabled) return;
    try {
      await _backend?.recordError(error, stack, fatal: fatal);
    } catch (_) {}
  }

  void installGlobalHandlers() {
    final previousFlutterHandler = FlutterError.onError;
    FlutterError.onError = (details) {
      previousFlutterHandler?.call(details);
      if (_enabled) {
        _backend?.recordFlutterError(details, fatal: true);
      }
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      if (_enabled) _backend?.recordError(error, stack, fatal: true);
      return true;
    };
  }
}

final crashReportingServiceProvider = Provider<CrashReportingService>(
  (_) => CrashReportingService(null),
);
