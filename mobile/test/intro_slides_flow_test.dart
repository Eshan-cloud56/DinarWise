import 'package:dinarwise/core/constants.dart';
import 'package:dinarwise/core/preferences/app_preferences.dart';
import 'package:dinarwise/core/preferences/onboarding_controller.dart';
import 'package:dinarwise/features/onboarding/intro_slides_screen.dart';
import 'package:dinarwise/features/tutorial/tutorial_keys.dart';
import 'package:dinarwise/features/tutorial/tutorial_service.dart';
import 'package:dinarwise/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Startup State Machine and Destination Resolution', () {
    test('Empty preferences route to StartupDestination.language', () {
      const state = OnboardingState(
        locale: null,
        privacyAccepted: false,
        privacyVersion: null,
        onboardingCompleted: false,
        introCompleted: false,
        localProfileId: 'test-profile',
      );
      expect(state.destination, equals(StartupDestination.language));
    });

    test('Language set but intro incomplete routes to StartupDestination.intro', () {
      const state = OnboardingState(
        locale: Locale('en'),
        privacyAccepted: false,
        privacyVersion: null,
        onboardingCompleted: false,
        introCompleted: false,
        localProfileId: 'test-profile',
      );
      expect(state.destination, equals(StartupDestination.intro));
    });

    test('Intro complete but privacy consent missing routes to StartupDestination.privacy', () {
      const state = OnboardingState(
        locale: Locale('en'),
        privacyAccepted: false,
        privacyVersion: null,
        onboardingCompleted: false,
        introCompleted: true,
        localProfileId: 'test-profile',
      );
      expect(state.destination, equals(StartupDestination.privacy));
    });

    test('Outdated privacy version routes to StartupDestination.privacy', () {
      const state = OnboardingState(
        locale: Locale('en'),
        privacyAccepted: true,
        privacyVersion: '0.9', // outdated
        onboardingCompleted: false,
        introCompleted: true,
        localProfileId: 'test-profile',
      );
      expect(state.destination, equals(StartupDestination.privacy));
    });

    test('Privacy accepted but currency missing routes to StartupDestination.currency', () {
      const state = OnboardingState(
        locale: Locale('en'),
        privacyAccepted: true,
        privacyVersion: currentPrivacyPolicyVersion,
        onboardingCompleted: false,
        introCompleted: true,
        currencyCode: null,
        localProfileId: 'test-profile',
      );
      expect(state.destination, equals(StartupDestination.currency));
    });

    test('Privacy accepted with currency but onboarding incomplete routes to currency', () {
      const state = OnboardingState(
        locale: Locale('en'),
        privacyAccepted: true,
        privacyVersion: currentPrivacyPolicyVersion,
        onboardingCompleted: false,
        introCompleted: true,
        currencyCode: 'SAR',
        localProfileId: 'test-profile',
      );
      expect(state.destination, equals(StartupDestination.currency));
    });

    test('All onboarding steps complete routes to StartupDestination.dashboard', () {
      const state = OnboardingState(
        locale: Locale('en'),
        privacyAccepted: true,
        privacyVersion: currentPrivacyPolicyVersion,
        onboardingCompleted: true,
        introCompleted: true,
        currencyCode: 'SAR',
        localProfileId: 'test-profile',
      );
      expect(state.destination, equals(StartupDestination.dashboard));
    });

    test('Legacy returning user with onboardingCompleted true bypasses intro directly to dashboard', () async {
      SharedPreferences.setMockInitialValues({
        'selected_language': 'en',
        'privacy_policy_accepted': true,
        'privacy_policy_version': currentPrivacyPolicyVersion,
        'onboarding_completed': true,
        'selected_currency': 'SAR',
        'local_profile_id': 'legacy-profile-id',
        // 'intro_completed' is missing (pre-intro build)
      });
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);

      final state = await container.read(onboardingControllerProvider.future);
      expect(state.introCompleted, isTrue);
      expect(state.destination, equals(StartupDestination.dashboard));
    });
  });

  group('Intro Completion and Privacy Consent Isolation', () {
    test('Completing intro persists introCompleted=true and leaves privacy unaccepted', () async {
      SharedPreferences.setMockInitialValues({
        'selected_language': 'en',
        'local_profile_id': 'test-profile',
      });
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);

      // Verify initial state
      final initial = await container.read(onboardingControllerProvider.future);
      expect(initial.introCompleted, isFalse);
      expect(initial.privacyAccepted, isFalse);
      expect(initial.destination, equals(StartupDestination.intro));

      // User completes intro
      await container.read(onboardingControllerProvider.notifier).completeIntro();

      // State after intro
      final updated = container.read(onboardingControllerProvider).requireValue;
      expect(updated.introCompleted, isTrue);
      expect(AppPreferences(prefs).introCompleted, isTrue);

      // CRITICAL: Privacy consent must NOT be accepted or altered!
      expect(updated.privacyAccepted, isFalse);
      expect(updated.hasCurrentConsent, isFalse);
      expect(prefs.getBool('privacy_policy_accepted'), isNull);

      // Next destination is strictly privacy
      expect(updated.destination, equals(StartupDestination.privacy));
    });
  });

  group('IntroSlidesScreen Asset and Replay Widget Tests', () {
    Widget buildTestApp({
      required Locale locale,
      required SharedPreferences prefs,
      bool replay = false,
      VoidCallback? onPopped,
    }) {
      return ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: MaterialApp(
          locale: locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('ar'),
          ],
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: IntroSlidesScreen(replay: replay),
              );
            },
          ),
        ),
      );
    }

    testWidgets('English locale loads English intro assets', (tester) async {
      SharedPreferences.setMockInitialValues({
        'selected_language': 'en',
      });
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        buildTestApp(locale: const Locale('en'), prefs: prefs),
      );
      await tester.pumpAndSettle();

      // Find the currently rendered Image widget
      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);
      final imageWidget = tester.widget<Image>(imageFinder);
      final assetImage = imageWidget.image as AssetImage;

      expect(assetImage.assetName, equals('assets/intro/intro1_en.png'));
    });

    testWidgets('Arabic locale loads Arabic intro assets', (tester) async {
      SharedPreferences.setMockInitialValues({
        'selected_language': 'ar',
      });
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        buildTestApp(locale: const Locale('ar'), prefs: prefs),
      );
      await tester.pumpAndSettle();

      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);
      final imageWidget = tester.widget<Image>(imageFinder);
      final assetImage = imageWidget.image as AssetImage;

      expect(assetImage.assetName, equals('assets/intro/intro1_ar.png'));
    });

    testWidgets('Replay mode does not reset tutorial or privacy states upon exit', (tester) async {
      SharedPreferences.setMockInitialValues({
        'selected_language': 'en',
        'selected_currency': 'SAR',
        'privacy_policy_accepted': true,
        'privacy_policy_version': currentPrivacyPolicyVersion,
        'onboarding_completed': true,
        'intro_slides_completed': true,
        TutorialKeys.home: true,
      });
      final prefs = await SharedPreferences.getInstance();

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);

      final tutorialService = container.read(tutorialServiceProvider);
      expect(tutorialService.isTutorialCompleted(TutorialKeys.home), isTrue);

      // Launch intro in replay mode within Navigator
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            locale: const Locale('en'),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: Builder(
              builder: (context) => Scaffold(
                body: Center(
                  child: ElevatedButton(
                    key: const ValueKey('openReplayButton'),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const IntroSlidesScreen(replay: true),
                        ),
                      );
                    },
                    child: const Text('Open Replay'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Open replay
      await tester.tap(find.byKey(const ValueKey('openReplayButton')));
      await tester.pumpAndSettle();

      // Verify close button is visible in replay mode
      final closeButton = find.byIcon(Icons.close);
      expect(closeButton, findsOneWidget);

      await tester.tap(closeButton);
      await tester.pumpAndSettle();

      // Verify persistent values are completely unchanged
      expect(prefs.getString('selected_currency'), equals('SAR'));
      expect(prefs.getBool('privacy_policy_accepted'), isTrue);
      expect(prefs.getString('selected_language'), equals('en'));
      expect(tutorialService.isTutorialCompleted(TutorialKeys.home), isTrue);
    });
  });
}
