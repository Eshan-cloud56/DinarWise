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
