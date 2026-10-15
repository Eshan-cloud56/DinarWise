import 'dart:async';

import 'package:dinarwise/core/constants.dart';
import 'package:dinarwise/core/preferences/onboarding_controller.dart';
import 'package:dinarwise/core/quick_widget_lifecycle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('QuickWidgetActions constants and matching', () {
    test('action constants match Android contract', () {
      expect(QuickWidgetActions.camera, 'com.sl.dinarwise.ACTION_WIDGET_CAMERA');
      expect(QuickWidgetActions.media, 'com.sl.dinarwise.ACTION_WIDGET_MEDIA');
      expect(QuickWidgetActions.voice, 'com.sl.dinarwise.ACTION_WIDGET_VOICE');
      expect(QuickWidgetActions.search, 'com.sl.dinarwise.ACTION_WIDGET_SEARCH');
    });

    test('helper matchers recognize both full actions and aliases', () {
      expect(
          QuickWidgetActions.isCamera('com.sl.dinarwise.ACTION_WIDGET_CAMERA'),
          isTrue);
      expect(QuickWidgetActions.isCamera('dinarwise_widget_camera'), isTrue);
      expect(QuickWidgetActions.isCamera('other'), isFalse);

      expect(
          QuickWidgetActions.isMedia('com.sl.dinarwise.ACTION_WIDGET_MEDIA'),
          isTrue);
      expect(QuickWidgetActions.isMedia('dinarwise_widget_media'), isTrue);
      expect(QuickWidgetActions.isMedia('other'), isFalse);

      expect(
          QuickWidgetActions.isVoice('com.sl.dinarwise.ACTION_WIDGET_VOICE'),
          isTrue);
      expect(QuickWidgetActions.isVoice('dinarwise_widget_voice'), isTrue);
      expect(QuickWidgetActions.isVoice('other'), isFalse);

      expect(
          QuickWidgetActions.isSearch('com.sl.dinarwise.ACTION_WIDGET_SEARCH'),
          isTrue);
      expect(QuickWidgetActions.isSearch('dinarwise_widget_search'), isTrue);
      expect(QuickWidgetActions.isSearch('other'), isFalse);
    });
  });

  group('QuickWidgetLifecycle', () {
    const channel = MethodChannel('dinarwise/quick_widget');
    final log = <String>[];
    String? mockInitialAction;

    setUp(() {
      log.clear();
      mockInitialAction = null;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
        log.add(call.method);
        if (call.method == 'consumeInitialAction') {
          final ret = mockInitialAction;
          mockInitialAction = null;
          return ret;
        }
        return null;
      });
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    testWidgets('consumes initial action once on startup', (tester) async {
      mockInitialAction = QuickWidgetActions.voice;
      final controller = _MockOnboardingController(
        const OnboardingState(
          locale: null,
          privacyAccepted: false,
          privacyVersion: null,
          onboardingCompleted: false,
          localProfileId: 'test-profile',
          currencyCode: null,
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            onboardingControllerProvider.overrideWith(() => controller),
          ],
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: QuickWidgetLifecycle(
              child: SizedBox(),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(log, contains('consumeInitialAction'));
      // Since onboarding is in language selection, action is queued, not executed yet
    });

    testWidgets('action remains queued until onboarding reaches dashboard',
        (tester) async {
      mockInitialAction = QuickWidgetActions.camera;
      final controller = _MockOnboardingController(
        const OnboardingState(
          locale: null,
          privacyAccepted: false,
          privacyVersion: null,
          onboardingCompleted: false,
          localProfileId: 'test-profile',
          currencyCode: null,
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            onboardingControllerProvider.overrideWith(() => controller),
          ],
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: QuickWidgetLifecycle(
              child: SizedBox(),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(log, contains('consumeInitialAction'));

      // Transition onboarding to dashboard
      controller.updateState(
        const OnboardingState(
          locale: Locale('en'),
          privacyAccepted: true,
          privacyVersion: currentPrivacyPolicyVersion,
          onboardingCompleted: true,
          localProfileId: 'test-profile',
          currencyCode: 'SAR',
        ),
      );
      await tester.pump();
    });

    testWidgets('warm-start onWidgetAction queues and handles action safely',
        (tester) async {
      final controller = _MockOnboardingController(
        const OnboardingState(
          locale: Locale('en'),
          privacyAccepted: true,
          privacyVersion: currentPrivacyPolicyVersion,
          onboardingCompleted: true,
          localProfileId: 'test-profile',
          currencyCode: 'SAR',
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            onboardingControllerProvider.overrideWith(() => controller),
          ],
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: QuickWidgetLifecycle(
              child: SizedBox(),
            ),
          ),
        ),
      );

      await tester.pump();

      // Simulate warm start intent from Android
      final messenger =
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
      await messenger.handlePlatformMessage(
        'dinarwise/quick_widget',
        const StandardMethodCodec().encodeMethodCall(
          const MethodCall('onWidgetAction', QuickWidgetActions.media),
        ),
        (_) {},
      );

      await tester.pump();
    });
  });
}

class _MockOnboardingController extends OnboardingController {
  _MockOnboardingController(this._initialState);
  final OnboardingState _initialState;

  @override
  FutureOr<OnboardingState> build() => _initialState;

  void updateState(OnboardingState newState) {
    state = AsyncData(newState);
  }
}
