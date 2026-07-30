import 'dart:async';

import 'package:dinarwise/core/constants.dart';
import 'package:dinarwise/core/preferences/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum StartupDestination { language, privacy, currency, dashboard }

class OnboardingState {
  const OnboardingState({
    required this.locale,
    required this.privacyAccepted,
    required this.privacyVersion,
    required this.onboardingCompleted,
    required this.localProfileId,
    this.currencyCode,
  });

  final Locale? locale;
  final bool privacyAccepted;
  final String? privacyVersion;
  final bool onboardingCompleted;
  final String localProfileId;
  final String? currencyCode;

  bool get hasCurrentConsent =>
      privacyAccepted && privacyVersion == currentPrivacyPolicyVersion;

  StartupDestination get destination {
    if (locale == null) return StartupDestination.language;
    if (!hasCurrentConsent) return StartupDestination.privacy;
    if (currencyCode == null || !onboardingCompleted) {
      return StartupDestination.currency;
    }
    return StartupDestination.dashboard;
  }

  OnboardingState copyWith({
    Locale? locale,
    bool? privacyAccepted,
    String? privacyVersion,
    bool? onboardingCompleted,
    String? localProfileId,
    String? currencyCode,
  }) {
    return OnboardingState(
      locale: locale ?? this.locale,
      privacyAccepted: privacyAccepted ?? this.privacyAccepted,
      privacyVersion: privacyVersion ?? this.privacyVersion,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      localProfileId: localProfileId ?? this.localProfileId,
      currencyCode: currencyCode ?? this.currencyCode,
    );
  }
}

final onboardingControllerProvider =
    AsyncNotifierProvider<OnboardingController, OnboardingState>(
  OnboardingController.new,
);

class OnboardingController extends AsyncNotifier<OnboardingState> {
  @override
  FutureOr<OnboardingState> build() {
    final preferences = ref.read(appPreferencesProvider);
    final existingProfileId = preferences.localProfileId;
    if (existingProfileId != null && existingProfileId.isNotEmpty) {
      return _stateFromPreferences(preferences, existingProfileId);
    }
    return _buildFirstLaunch(preferences);
  }

  Future<OnboardingState> _buildFirstLaunch(AppPreferences preferences) async {
    final profileId = await preferences.getOrCreateLocalProfileId();
    return _stateFromPreferences(preferences, profileId);
  }

  OnboardingState _stateFromPreferences(
    AppPreferences preferences,
    String profileId,
  ) {
    final languageCode = preferences.selectedLanguage;
    return OnboardingState(
      locale: languageCode == null ? null : Locale(languageCode),
      privacyAccepted: preferences.privacyAccepted,
      privacyVersion: preferences.privacyVersion,
      onboardingCompleted: preferences.onboardingCompleted,
      localProfileId: profileId,
      currencyCode: preferences.selectedCurrency,
    );
  }

  Future<void> selectLanguage(String languageCode) async {
    await ref.read(appPreferencesProvider).setLanguage(languageCode);
    final current = state.requireValue;
    state = AsyncData(current.copyWith(locale: Locale(languageCode)));
  }

  Future<void> acceptPrivacyPolicy() async {
    final acceptedAt = DateTime.now().toUtc();
    await ref.read(appPreferencesProvider).acceptPrivacyPolicy(
          version: currentPrivacyPolicyVersion,
          acceptedAt: acceptedAt,
        );
    final current = state.requireValue;
    state = AsyncData(
      current.copyWith(
        privacyAccepted: true,
        privacyVersion: currentPrivacyPolicyVersion,
        onboardingCompleted: false,
      ),
    );
  }

  Future<void> selectCurrency(String currencyCode) async {
    await ref.read(appPreferencesProvider).setCurrency(currencyCode);
    final current = state.requireValue;
    state = AsyncData(
      current.copyWith(
        currencyCode: currencyCode,
        onboardingCompleted: true,
      ),
    );
  }

  Future<void> resetPreferences() async {
    await ref.read(appPreferencesProvider).clearOnboardingAndPreferences();
    ref.invalidateSelf();
  }
}
