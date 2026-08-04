import 'dart:async';

import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PerformanceService {
  PerformanceService(this._performance, {bool enabled = false})
      : _enabled = enabled;
  final FirebasePerformance? _performance;
  bool _enabled;

  bool get enabled => _enabled;

  Future<void> setEnabled(bool value) async {
    _enabled = value;
    try {
      await _performance?.setPerformanceCollectionEnabled(value);
    } catch (_) {}
  }

  Future<T> trace<T>(String name, Future<T> Function() operation) async {
    if (!_enabled || _performance == null) return operation();
    Trace? trace;
    try {
      trace = _performance.newTrace(name);
      await trace.start();
    } catch (_) {
      trace = null;
    }
    try {
      return await operation();
    } finally {
      try {
        await trace?.stop();
      } catch (_) {}
    }
  }

  T traceSync<T>(String name, T Function() operation) {
    if (!_enabled || _performance == null) return operation();
    final trace = _performance.newTrace(name);
    unawaited(_safe(trace.start));
    try {
      return operation();
    } finally {
      unawaited(_safe(trace.stop));
    }
  }

  Future<void> _safe(Future<void> Function() operation) async {
    try {
      await operation();
    } catch (_) {}
  }
}

abstract final class PerformanceTraces {
  static const appInitialization = 'app_initialization';
  static const databaseInitialization = 'database_initialization';
  static const dashboardLoad = 'dashboard_load';
  static const transactionsLoad = 'transactions_load';
  static const analyticsCalculation = 'analytics_calculation';
  static const transactionSearch = 'transaction_search';
  static const dataExport = 'data_export';
}

final performanceServiceProvider = Provider<PerformanceService>(
  (_) => PerformanceService(null),
);
