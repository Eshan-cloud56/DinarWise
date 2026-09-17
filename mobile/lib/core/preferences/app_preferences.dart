import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

const _selectedLanguageKey = 'selected_language';
const _privacyAcceptedKey = 'privacy_policy_accepted';
const _privacyVersionKey = 'privacy_policy_version';
const _privacyAcceptedAtKey = 'privacy_policy_accepted_at';
const _onboardingCompletedKey = 'onboarding_completed';
const _localProfileIdKey = 'local_profile_id';
const _selectedCurrencyKey = 'selected_currency';
const _analyticsAllowedKey = 'analytics_allowed';
const _diagnosticsAllowedKey = 'diagnostics_allowed';
const _dashboardTutorialCompletedV1Key = 'dashboard_tutorial_completed_v1';
const _smsDetectionEnabledKey = 'sms_detection_enabled';
const _processedSmsHashesKey = 'processed_sms_hashes';
const _dismissedRecurringMerchantsKey = 'dismissed_recurring_merchants';

final sharedPreferencesProvider = Provider<SharedPreferences>(
  (_) => throw UnimplementedError('SharedPreferences must be initialized'),
);

class AppPreferences {
  AppPreferences(this._preferences);

  final SharedPreferences _preferences;

  String? get selectedLanguage => _preferences.getString(_selectedLanguageKey);
  bool get privacyAccepted =>
      _preferences.getBool(_privacyAcceptedKey) ?? false;
  String? get privacyVersion => _preferences.getString(_privacyVersionKey);
  DateTime? get privacyAcceptedAt {
    final value = _preferences.getString(_privacyAcceptedAtKey);
    return value == null ? null : DateTime.tryParse(value);
  }

  bool get onboardingCompleted =>
      _preferences.getBool(_onboardingCompletedKey) ?? false;

  String? get localProfileId => _preferences.getString(_localProfileIdKey);
  String? get selectedCurrency => _preferences.getString(_selectedCurrencyKey);
  bool get dashboardTutorialCompletedV1 =>
      _preferences.getBool(_dashboardTutorialCompletedV1Key) ?? false;

  bool get smsTransactionDetectionEnabled =>
      _preferences.getBool(_smsDetectionEnabledKey) ?? false;

  Future<void> setSmsTransactionDetectionEnabled(bool enabled) =>
      _preferences.setBool(_smsDetectionEnabledKey, enabled);

  List<String> get processedSmsHashes =>
      _preferences.getStringList(_processedSmsHashesKey) ?? const [];

  bool isSmsProcessed(String hash) =>
      processedSmsHashes.contains(hash);

  Future<void> markSmsProcessed(String hash) async {
    final list = List<String>.from(processedSmsHashes);
    if (!list.contains(hash)) {
      list.add(hash);
      if (list.length > 1000) {
        list.removeRange(0, list.length - 1000);
      }
      await _preferences.setStringList(_processedSmsHashesKey, list);
    }
  }

  List<String> get dismissedRecurringMerchants =>
      _preferences.getStringList(_dismissedRecurringMerchantsKey) ?? const [];

  bool isRecurringMerchantDismissed(String merchant) =>
      dismissedRecurringMerchants.contains(merchant.trim().toLowerCase());

  Future<void> dismissRecurringMerchant(String merchant) async {
    final normalized = merchant.trim().toLowerCase();
    final list = List<String>.from(dismissedRecurringMerchants);
    if (!list.contains(normalized)) {
      list.add(normalized);
      await _preferences.setStringList(_dismissedRecurringMerchantsKey, list);
    }
  }

  Future<String> getOrCreateLocalProfileId() async {
    final existing = localProfileId;
    if (existing != null && existing.isNotEmpty) return existing;
    final created = const Uuid().v4();
    await _preferences.setString(_localProfileIdKey, created);
    return created;
  }

  Future<void> setLanguage(String languageCode) =>
      _preferences.setString(_selectedLanguageKey, languageCode);

  Future<void> setCurrency(String currencyCode) async {
    await _preferences.setString(_selectedCurrencyKey, currencyCode);
    await _preferences.setBool(_onboardingCompletedKey, true);
  }

  Future<void> setDashboardTutorialCompletedV1(bool completed) =>
      _preferences.setBool(_dashboardTutorialCompletedV1Key, completed);

  /// Removes retired telemetry consent preferences.
  ///
  /// Analytics is automatic from privacy disclosure version 1.2 onward. An
  /// old stored `false` value must not disable collection after an update.
  Future<void> migrateAutomaticTelemetryPreferences() async {
    await _preferences.remove(_analyticsAllowedKey);
    await _preferences.remove(_diagnosticsAllowedKey);
  }

  Future<void> acceptPrivacyPolicy({
    required String version,
    required DateTime acceptedAt,
  }) async {
    await _preferences.setBool(_privacyAcceptedKey, true);
    await _preferences.setString(_privacyVersionKey, version);
    await _preferences.setString(
      _privacyAcceptedAtKey,
      acceptedAt.toUtc().toIso8601String(),
    );
    await _preferences.setBool(_onboardingCompletedKey, false);
  }

  Future<void> clearOnboardingAndPreferences() async {
    await _preferences.clear();
  }
}

final appPreferencesProvider = Provider<AppPreferences>(
  (ref) => AppPreferences(ref.watch(sharedPreferencesProvider)),
);
