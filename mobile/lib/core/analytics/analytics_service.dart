import 'dart:async';

import 'package:dinarwise/core/analytics/analytics_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract interface class AnalyticsBackend {
  Future<void> setCollectionEnabled(bool enabled);
  Future<void> log(String name, Map<String, Object>? parameters);
  Future<void> setProperty(String name, String? value);
}

class FirebaseAnalyticsBackend implements AnalyticsBackend {
  FirebaseAnalyticsBackend(this.analytics);

  final FirebaseAnalytics analytics;

  @override
  Future<void> setCollectionEnabled(bool enabled) =>
      analytics.setAnalyticsCollectionEnabled(enabled);

  @override
  Future<void> log(String name, Map<String, Object>? parameters) =>
      analytics.logEvent(name: name, parameters: parameters);

  @override
  Future<void> setProperty(String name, String? value) =>
      analytics.setUserProperty(name: name, value: value);
}

class NoopAnalyticsBackend implements AnalyticsBackend {
  const NoopAnalyticsBackend();

  @override
  Future<void> log(String name, Map<String, Object>? parameters) async {}

  @override
  Future<void> setCollectionEnabled(bool enabled) async {}

  @override
  Future<void> setProperty(String name, String? value) async {}
}

/// Single privacy boundary for all DinarWise Analytics calls.
///
/// Calls are fire-and-forget and failures are intentionally swallowed so
/// telemetry can never delay or interrupt a financial operation.
class AnalyticsService {
  AnalyticsService(this._backend, {bool enabled = false}) : _enabled = enabled;

  final AnalyticsBackend _backend;
  bool _enabled;
  String? _lastScreen;
  final Set<String> _screenEvents = {};

  bool get enabled => _enabled;
  Future<void> setEnabled(bool value) async {
    _enabled = value;
    try {
      await _backend.setCollectionEnabled(value);
    } catch (_) {}
  }

  void _event(String name, [Map<String, Object>? parameters]) {
    if (!_enabled) return;
    unawaited(_safe(() => _backend.log(name, parameters)));
  }

  Future<void> _safe(Future<void> Function() operation) async {
    try {
      await operation();
    } catch (_) {}
  }

  void screen(String name) {
    if (_lastScreen == name) return;
    _lastScreen = name;
    _screenEvents.clear();
    _event('screen_view', {'firebase_screen': name});
  }

  void _screenEvent(String name, [Map<String, Object>? parameters]) {
    if (!_screenEvents.add(name)) return;
    _event(name, parameters);
  }

  void setAppLanguage(String value) => _property('app_language', value);
  void setSelectedCurrency(String value) =>
      _property('selected_currency', value);
  void setOnboardingStatus(bool completed) => _property(
        'onboarding_status',
        completed ? 'completed' : 'incomplete',
      );
  void setCustomCategoriesUsed(bool value) =>
      _property('custom_categories_used', '$value');
  void setAppTheme(String value) => _property('app_theme', value);

  void _property(String name, String value) {
    if (!_enabled) return;
    unawaited(_safe(() => _backend.setProperty(name, value)));
  }

  void onboardingStarted(String language) => _event(
        AnalyticsEvents.onboardingStarted,
        {AnalyticsParameters.appLanguage: language},
      );
  void onboardingCompleted(String language) => _event(
        AnalyticsEvents.onboardingCompleted,
        {AnalyticsParameters.selectedLanguage: language},
      );
  void privacyConsentUpdated({
    required bool analyticsAllowed,
    required bool diagnosticsAllowed,
  }) =>
      _event(AnalyticsEvents.privacyConsentUpdated, {
        AnalyticsParameters.analyticsAllowed: analyticsAllowed ? 1 : 0,
        AnalyticsParameters.diagnosticsAllowed: diagnosticsAllowed ? 1 : 0,
      });
  void languageChanged(String from, String to) =>
      _event(AnalyticsEvents.languageChanged, {
        AnalyticsParameters.fromLanguage: from,
        AnalyticsParameters.toLanguage: to,
      });
  void currencyChanged(String from, String to) =>
      _event(AnalyticsEvents.currencyChanged, {
        AnalyticsParameters.fromCurrency: from,
        AnalyticsParameters.toCurrency: to,
      });

  void incomeAddStarted() => _event(AnalyticsEvents.incomeAddStarted);
  void incomeAdded(String currency) => _event(AnalyticsEvents.incomeAdded, {
        AnalyticsParameters.currency: currency,
        AnalyticsParameters.entrySource: 'manual',
      });
  void incomeEdited(String currency) => _event(
      AnalyticsEvents.incomeEdited, {AnalyticsParameters.currency: currency});
  void incomeDeleted(String currency) => _event(
      AnalyticsEvents.incomeDeleted, {AnalyticsParameters.currency: currency});
  void incomeFailed(String action, String reason) =>
      _event(AnalyticsEvents.incomeActionFailed, {
        AnalyticsParameters.action: action,
        AnalyticsParameters.reason: reason,
      });

  void expenseAddStarted() => _event(AnalyticsEvents.expenseAddStarted);
  void expenseSaved({
    required bool edited,
    required String categoryType,
    required String currency,
  }) =>
      _event(
        edited ? AnalyticsEvents.expenseEdited : AnalyticsEvents.expenseAdded,
        {
          AnalyticsParameters.categoryType: categoryType,
          AnalyticsParameters.currency: currency,
          if (!edited) AnalyticsParameters.entrySource: 'manual',
        },
      );
  void expenseDeleted(String categoryType, String currency) =>
      _event(AnalyticsEvents.expenseDeleted, {
        AnalyticsParameters.categoryType: categoryType,
        AnalyticsParameters.currency: currency,
      });
  void expenseFailed(String action, String reason) =>
      _event(AnalyticsEvents.expenseActionFailed, {
        AnalyticsParameters.action: action,
        AnalyticsParameters.reason: reason,
      });

  void customCategoryCreated() => _event(AnalyticsEvents.customCategoryCreated);
  void customCategoryEdited() => _event(AnalyticsEvents.customCategoryEdited);
  void customCategoryDeleted() => _event(AnalyticsEvents.customCategoryDeleted);
  void transactionsViewed() => _screenEvent(AnalyticsEvents.transactionsViewed);
  void transactionSearchUsed() => _event(AnalyticsEvents.transactionSearchUsed);
  void transactionFilterApplied(String type) => _event(
      AnalyticsEvents.transactionFilterApplied,
      {AnalyticsParameters.filterType: type});
  void analyticsViewed(String period) => _event(
      AnalyticsEvents.analyticsViewed, {AnalyticsParameters.period: period});
  void dashboardSummaryViewed() =>
      _screenEvent(AnalyticsEvents.dashboardSummaryViewed);
  void aiInformationViewed() =>
      _screenEvent(AnalyticsEvents.aiInformationViewed);
  void settingsViewed() => _screenEvent(AnalyticsEvents.settingsViewed);
  void themeChanged(String theme) =>
      _event(AnalyticsEvents.themeChanged, {AnalyticsParameters.theme: theme});
  void exportStarted(String format) => _event(
      AnalyticsEvents.dataExportStarted, {AnalyticsParameters.format: format});
  void exportSucceeded(String format) => _event(
      AnalyticsEvents.dataExportSucceeded,
      {AnalyticsParameters.format: format});
  void exportFailed(String format, String reason) =>
      _event(AnalyticsEvents.dataExportFailed, {
        AnalyticsParameters.format: format,
        AnalyticsParameters.reason: reason,
      });
}

final analyticsServiceProvider = Provider<AnalyticsService>(
  (_) => AnalyticsService(const NoopAnalyticsBackend()),
);
