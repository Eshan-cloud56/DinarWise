import 'package:dinarwise/core/constants.dart';
import 'package:dinarwise/core/database/app_database.dart';
import 'package:dinarwise/core/database/database_provider.dart';
import 'package:dinarwise/core/preferences/app_preferences.dart';
import 'package:dinarwise/features/settings/settings_screen.dart';
import 'package:drift/native.dart';
import 'package:dinarwise/features/sms_detection/sms_disclosure_dialog.dart';
import 'package:dinarwise/features/sms_detection/sms_platform_channel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dinarwise/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeSmsPlatformChannel implements SmsPlatformChannel {
  _FakeSmsPlatformChannel({
    this.permissionGranted = false,
    this.alreadyHasPermission = false,
    this.supported = true,
  });

  bool permissionGranted;
  bool alreadyHasPermission;
  bool supported;
  bool permissionRequested = false;

  @override
  Future<bool> isSupported() async => supported;

  @override
  Future<SmsPermissionResult> requestPermission() async {
    permissionRequested = true;
    return SmsPermissionResult(
      granted: permissionGranted,
      permanentlyDenied: false,
    );
  }

  @override
  Future<bool> openAppSettings() async => true;

  @override
  Future<bool> hasPermission() async => alreadyHasPermission;


  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Widget _wrapWithLocalization(Widget child, {Locale locale = const Locale('en')}) {
  return MaterialApp(
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
    home: Scaffold(body: child),
  );
}

void main() {
  group('SMS Prominent Disclosure Dialog (Google Play Compliance)', () {
    testWidgets('Displays all required disclosures including on-device guarantee',
        (tester) async {
      bool? result;

      await tester.pumpWidget(
        _wrapWithLocalization(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                result = await showSmsDetectionDisclosure(context);
              },
              child: const Text('Open Disclosure'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Disclosure'));
      await tester.pumpAndSettle();

      // Check title and key disclosure items
      expect(find.text('SMS Transaction Detection'), findsOneWidget);
      expect(find.text('Automatic expense & income suggestions'), findsOneWidget);
      expect(find.textContaining('100% on-device & private'), findsOneWidget);
      expect(find.textContaining('Zero auto-save'), findsOneWidget);
      expect(find.textContaining('RECEIVE_SMS'), findsOneWidget);

      // Verify buttons
      expect(find.text('Agree & Enable'), findsOneWidget);
      expect(find.text('Not Now'), findsOneWidget);

      // Tap Agree & Enable
      await tester.tap(find.text('Agree & Enable'));
      await tester.pumpAndSettle();

      expect(result, isTrue);
    });

    testWidgets('Tapping Not Now declines disclosure and returns false',
        (tester) async {
      bool? result;

      await tester.pumpWidget(
        _wrapWithLocalization(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                result = await showSmsDetectionDisclosure(context);
              },
              child: const Text('Open Disclosure'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Disclosure'));
      await tester.pumpAndSettle();

      // Tap Not Now
      await tester.tap(find.text('Not Now'));
      await tester.pumpAndSettle();

      expect(result, isFalse);
    });

    testWidgets('Renders Arabic localization properly', (tester) async {
      await tester.pumpWidget(
        _wrapWithLocalization(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showSmsDetectionDisclosure(context),
              child: const Text('Open'),
            ),
          ),
          locale: const Locale('ar'),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('الكشف عن المعاملات عبر الرسائل النصية'), findsOneWidget);
      expect(find.textContaining('خصوصية تامة 100% على جهازك'), findsOneWidget);
      expect(find.text('موافق وتفعيل'), findsOneWidget);
      expect(find.text('ليس الآن'), findsOneWidget);
    });
  });

  group('Settings Screen Opt-In SMS Flow', () {
    late SharedPreferences prefs;
    late AppDatabase db;

    setUp(() async {
      SharedPreferences.setMockInitialValues({
        'selected_language': 'en',
        'selected_currency': 'SAR',
        'privacy_policy_accepted': true,
        'privacy_policy_version': currentPrivacyPolicyVersion,
        'onboarding_completed': true,
        'local_profile_id': 'sms-compliance-test',
        'sms_detection_enabled': false,
      });
      prefs = await SharedPreferences.getInstance();
      db = AppDatabase(NativeDatabase.memory());
    });

    tearDown(() async {
      await db.close();
    });

    testWidgets(
        'Declining disclosure keeps setting false and does NOT request OS permission',
        (tester) async {
      tester.view.physicalSize = const Size(412, 2000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final fakeChannel = _FakeSmsPlatformChannel(
        permissionGranted: true,
        alreadyHasPermission: false,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            databaseProvider.overrideWithValue(db),
            smsPlatformChannelProvider.overrideWithValue(fakeChannel),
          ],
          child: _wrapWithLocalization(const SettingsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      final switchFinder = find.byType(Switch);
      await tester.ensureVisible(switchFinder);
      expect(switchFinder, findsOneWidget);
      expect(tester.widget<Switch>(switchFinder).value, isFalse);

      // Tap the switch to enable
      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      // Disclosure dialog must appear
      expect(find.text('SMS Transaction Detection'), findsOneWidget);

      // User declines
      await tester.tap(find.text('Not Now'));
      await tester.pumpAndSettle();

      // OS permission must NOT have been requested
      expect(fakeChannel.permissionRequested, isFalse);

      // Setting must remain false
      expect(prefs.getBool('sms_detection_enabled'), isFalse);
      expect(tester.widget<Switch>(switchFinder).value, isFalse);
    });

    testWidgets(
        'Accepting disclosure when OS permission denied shows warning and stays false',
        (tester) async {
      tester.view.physicalSize = const Size(412, 2000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final fakeChannel = _FakeSmsPlatformChannel(
        permissionGranted: false,
        alreadyHasPermission: false,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            databaseProvider.overrideWithValue(db),
            smsPlatformChannelProvider.overrideWithValue(fakeChannel),
          ],
          child: _wrapWithLocalization(const SettingsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      final switchFinder = find.byType(Switch);
      await tester.ensureVisible(switchFinder);
      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      // Agree in dialog
      await tester.tap(find.text('Agree & Enable'));
      await tester.pumpAndSettle();

      // OS permission was requested
      expect(fakeChannel.permissionRequested, isTrue);

      // Since permission was denied by OS, preference stays false
      expect(prefs.getBool('sms_detection_enabled'), isFalse);
      expect(tester.widget<Switch>(switchFinder).value, isFalse);

      // Warning snackbar is shown
      expect(find.textContaining('SMS permission was not granted'), findsOneWidget);
    });

    testWidgets(
        'Accepting disclosure when OS permission granted enables setting',
        (tester) async {
      tester.view.physicalSize = const Size(412, 2000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final fakeChannel = _FakeSmsPlatformChannel(
        permissionGranted: true,
        alreadyHasPermission: false,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            databaseProvider.overrideWithValue(db),
            smsPlatformChannelProvider.overrideWithValue(fakeChannel),
          ],
          child: _wrapWithLocalization(const SettingsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      final switchFinder = find.byType(Switch);
      await tester.ensureVisible(switchFinder);
      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      // Agree in dialog
      await tester.tap(find.text('Agree & Enable'));
      await tester.pumpAndSettle();

      // Permission was requested
      expect(fakeChannel.permissionRequested, isTrue);

      // Setting updated to true
      expect(prefs.getBool('sms_detection_enabled'), isTrue);
      expect(tester.widget<Switch>(switchFinder).value, isTrue);

      // Confirmation snackbar is shown
      expect(find.text('Automatic transaction detection enabled.'), findsOneWidget);
    });

    testWidgets(
        'Does not show disclosure repeatedly when permission is already granted',
        (tester) async {
      tester.view.physicalSize = const Size(412, 2000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final fakeChannel = _FakeSmsPlatformChannel(
        permissionGranted: true,
        alreadyHasPermission: true,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            databaseProvider.overrideWithValue(db),
            smsPlatformChannelProvider.overrideWithValue(fakeChannel),
          ],
          child: _wrapWithLocalization(const SettingsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      final switchFinder = find.byType(Switch);
      await tester.ensureVisible(switchFinder);
      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      // Disclosure dialog must NOT appear
      expect(find.text('Agree & Enable'), findsNothing);

      // Setting directly updated to true
      expect(prefs.getBool('sms_detection_enabled'), isTrue);
      expect(tester.widget<Switch>(switchFinder).value, isTrue);
    });

    testWidgets(
        'QA flavor gracefully disables SMS toggle and shows unavailable subtitle',
        (tester) async {
      tester.view.physicalSize = const Size(412, 2000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final fakeChannel = _FakeSmsPlatformChannel(
        permissionGranted: false,
        alreadyHasPermission: false,
        supported: false,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            databaseProvider.overrideWithValue(db),
            smsPlatformChannelProvider.overrideWithValue(fakeChannel),
          ],
          child: _wrapWithLocalization(const SettingsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      final switchFinder = find.byType(Switch);
      await tester.ensureVisible(switchFinder);

      // Switch must be disabled (onChanged is null)
      expect(tester.widget<Switch>(switchFinder).onChanged, isNull);
      expect(find.text('Automatic transaction detection is not available in this build.'), findsOneWidget);
    });
  });
}
