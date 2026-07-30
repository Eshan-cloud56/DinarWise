import 'package:dinarwise/core/constants.dart';
import 'package:dinarwise/core/preferences/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum StartupDestination { language, privacy, dashboard }

class OnboardingState {
  const OnboardingState({
    required this.locale,
    required this.privacyAccepted,
    required this.privacyVersion,
    required this.onboardingCompleted,
    required this.localProfileId,
  });

  final Locale? locale;
  final bool privacyAccepted;
  final String? privacyVersion;
  final bool onboardingCompleted;
  final String localProfileId;

  bool get hasCurrentConsent =>
      privacyAccepted &&
      onboardingCompleted &&
      privacyVersion == currentPrivacyPolicyVersion;

  StartupDestination get destination {
    if (locale == null) return StartupDestination.language;
    if (!hasCurrentConsent) return StartupDestination.privacy;
    return StartupDestination.dashboard;
  }

  OnboardingState copyWith({
    Locale? locale,
    bool? privacyAccepted,
    String? privacyVersion,
    bool? onboardingCompleted,
    String? localProfileId,
  }) {
    return OnboardingState(
      locale: locale ?? this.locale,
      privacyAccepted: privacyAccepted ?? this.privacyAccepted,
      privacyVersion: privacyVersion ?? this.privacyVersion,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      localProfileId: localProfileId ?? this.localProfileId,
    );
  }
}

final onboardingControllerProvider =
    AsyncNotifierProvider<OnboardingController, OnboardingState>(
  OnboardingController.new,
);

class OnboardingController extends AsyncNotifier<OnboardingState> {
  @override
  Future<OnboardingState> build() async {
    final preferences = ref.read(appPreferencesProvider);
    final languageCode = preferences.selectedLanguage;
    final profileId = await preferences.getOrCreateLocalProfileId();
    return OnboardingState(
      locale: languageCode == null ? null : Locale(languageCode),
      privacyAccepted: preferences.privacyAccepted,
      privacyVersion: preferences.privacyVersion,
      onboardingCompleted: preferences.onboardingCompleted,
      localProfileId: profileId,
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
        onboardingCompleted: true,
      ),
    );
  }

  Future<void> resetPreferences() async {
    await ref.read(appPreferencesProvider).clearOnboardingAndPreferences();
    ref.invalidateSelf();
  }
}
