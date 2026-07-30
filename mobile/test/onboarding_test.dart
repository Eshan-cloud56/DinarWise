import 'package:drift/native.dart';
import 'package:dinarwise/app.dart';
import 'package:dinarwise/core/constants.dart';
import 'package:dinarwise/core/database/app_database.dart';
import 'package:dinarwise/core/database/database_provider.dart';
import 'package:dinarwise/core/preferences/app_preferences.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<AppDatabase> pumpApp(
  WidgetTester tester, {
  Map<String, Object> preferences = const {},
}) async {
  SharedPreferences.setMockInitialValues(preferences);
  final sharedPreferences = await SharedPreferences.getInstance();
  final database = AppDatabase(NativeDatabase.memory());
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        databaseProvider.overrideWithValue(database),
      ],
      child: const DinarWiseApp(),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
  await tester.pump();
  return database;
}

void main() {
  testWidgets('fresh installation opens language selection without login', (
    tester,
  ) async {
    final database = await pumpApp(tester);
    expect(find.text('Choose your language'), findsOneWidget);
    expect(find.text('Sign in'), findsNothing);
    expect(find.text('Create account'), findsNothing);
    await database.close();
  });

  testWidgets('English selection opens English privacy consent',
      (tester) async {
    final database = await pumpApp(tester);
    await tester.tap(find.text('English').first);
    await tester.pumpAndSettle();
    expect(find.text('Welcome to DinarWise'), findsOneWidget);
    expect(
        find.byKey(const ValueKey('privacyPolicyConsentText')), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
    expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isFalse);
    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Get Started'),
    );
    expect(button.onPressed, isNull);

    final consentText = tester.widget<Text>(
      find.byKey(const ValueKey('privacyPolicyConsentText')),
    );
    final policyLink = (consentText.textSpan! as TextSpan)
        .children!
        .whereType<TextSpan>()
        .singleWhere((span) => span.recognizer != null);
    (policyLink.recognizer! as TapGestureRecognizer).onTap!();
    await tester.pump();
    expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isFalse);
    await database.close();
  });

  testWidgets('Arabic selection applies Arabic RTL privacy screen', (
    tester,
  ) async {
    final database = await pumpApp(tester);
    await tester.tap(find.text('العربية'));
    await tester.pumpAndSettle();
    expect(find.text('أهلاً بك في دينار وايز'), findsOneWidget);
    expect(
        find.byKey(const ValueKey('privacyPolicyConsentText')), findsOneWidget);
    expect(find.text('ابدأ الآن'), findsOneWidget);
    expect(
      tester
          .widget<Directionality>(
            find
                .ancestor(
                  of: find.text('ابدأ الآن'),
                  matching: find.byType(Directionality),
                )
                .first,
          )
          .textDirection,
      TextDirection.rtl,
    );
    await database.close();
  });

  testWidgets('consent gates dashboard and is persisted', (tester) async {
    final database = await pumpApp(tester);
    await tester.tap(find.text('English').first);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Get Started'),
    );
    expect(button.onPressed, isNotNull);
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();
    expect(find.text('Recent transactions'), findsOneWidget);
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getBool('privacy_policy_accepted'), isTrue);
    expect(
      preferences.getString('privacy_policy_version'),
      currentPrivacyPolicyVersion,
    );
    expect(preferences.getBool('onboarding_completed'), isTrue);
    expect(preferences.getString('privacy_policy_accepted_at'), isNotNull);
    await database.close();
  });

  testWidgets('completed onboarding opens dashboard directly', (tester) async {
    final database = await pumpApp(
      tester,
      preferences: {
        'selected_language': 'en',
        'privacy_policy_accepted': true,
        'privacy_policy_version': currentPrivacyPolicyVersion,
        'privacy_policy_accepted_at': '2026-07-29T00:00:00.000Z',
        'onboarding_completed': true,
        'local_profile_id': 'stable-test-profile',
      },
    );
    expect(find.text('Recent transactions'), findsOneWidget);
    expect(find.text('Total income'), findsOneWidget);
    expect(find.text('Total expenses'), findsOneWidget);
    expect(find.text('Your remaining balance is'), findsOneWidget);
    expect(find.text('Add income'), findsOneWidget);
    expect(find.text('Choose your language'), findsNothing);
    await tester.tap(find.byKey(const ValueKey('dashboardAddIncome')));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.byKey(const ValueKey('incomeAmountField')), findsOneWidget);
    expect(find.text('Merchant'), findsNothing);
    expect(find.byType(SegmentedButton<String>), findsNothing);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    await database.close();
  });

  testWidgets('outdated privacy version requires consent but not language', (
    tester,
  ) async {
    final database = await pumpApp(
      tester,
      preferences: {
        'selected_language': 'en',
        'privacy_policy_accepted': true,
        'privacy_policy_version': '0.9',
        'onboarding_completed': true,
      },
    );
    expect(find.text('Welcome to DinarWise'), findsOneWidget);
    expect(find.text('Choose your language'), findsNothing);
    await database.close();
  });

  testWidgets('changing language preserves financial data and consent', (
    tester,
  ) async {
    final database = await pumpApp(
      tester,
      preferences: {
        'selected_language': 'en',
        'privacy_policy_accepted': true,
        'privacy_policy_version': currentPrivacyPolicyVersion,
        'privacy_policy_accepted_at': '2026-07-29T00:00:00.000Z',
        'onboarding_completed': true,
        'local_profile_id': 'stable-test-profile',
      },
    );
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('العربية').last);
    await tester.pumpAndSettle();
    expect(find.text('الإعدادات'), findsOneWidget);
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getBool('privacy_policy_accepted'), isTrue);
    expect(preferences.getString('selected_language'), 'ar');
    await database.close();
  });

  testWidgets('Arabic dashboard, settings, expense, and AI fallback localize',
      (tester) async {
    final database = await pumpApp(
      tester,
      preferences: {
        'selected_language': 'ar',
        'privacy_policy_accepted': true,
        'privacy_policy_version': currentPrivacyPolicyVersion,
        'privacy_policy_accepted_at': '2026-07-29T00:00:00.000Z',
        'onboarding_completed': true,
        'local_profile_id': 'stable-test-profile',
      },
    );
    expect(find.text('المعاملات الأخيرة'), findsOneWidget);
    expect(find.text('إجمالي الدخل'), findsOneWidget);
    expect(find.text('إجمالي المصروفات'), findsOneWidget);
    expect(find.text('رصيدك المتبقي هو'), findsOneWidget);
    expect(find.text('إضافة دخل'), findsOneWidget);
    expect(find.text('Recent transactions'), findsNothing);
    expect(
      tester
          .widget<Directionality>(
            find
                .ancestor(
                  of: find.text('المعاملات الأخيرة'),
                  matching: find.byType(Directionality),
                )
                .first,
          )
          .textDirection,
      TextDirection.rtl,
    );
    await tester.drag(find.byType(ListView).first, const Offset(0, -700));
    await tester.pumpAndSettle();
    expect(find.text('التخطيط المالي'), findsOneWidget);
    expect(find.text('الميزانيات'), findsOneWidget);
    expect(find.text('خطط اشترِ الآن وادفع لاحقًا'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.auto_awesome_outlined));
    await tester.pumpAndSettle();
    expect(
      find.text(
        'تتطلب ميزة الذكاء الاصطناعي هذه اتصالاً بالإنترنت. '
        'لا يزال بإمكانك إضافة المصروف يدويًا.',
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('إضافة يدويًا'));
    await tester.pumpAndSettle();
    expect(find.text('إضافة مصروف'), findsWidgets);
    expect(find.text('المتجر'), findsOneWidget);
    expect(find.text('الفئة'), findsOneWidget);
    expect(find.text('Merchant'), findsNothing);
    expect(find.byType(SegmentedButton<String>), findsNothing);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    expect(find.text('الإعدادات'), findsOneWidget);
    expect(find.text('الميزانيات'), findsNothing);
    expect(find.text('خطط اشترِ الآن وادفع لاحقًا'), findsNothing);
    expect(find.text('Settings'), findsNothing);
    await database.close();
  });

  testWidgets('reset cancellation preserves data and confirmation resets', (
    tester,
  ) async {
    final database = await pumpApp(
      tester,
      preferences: {
        'selected_language': 'en',
        'privacy_policy_accepted': true,
        'privacy_policy_version': currentPrivacyPolicyVersion,
        'privacy_policy_accepted_at': '2026-07-29T00:00:00.000Z',
        'onboarding_completed': true,
        'local_profile_id': 'stable-test-profile',
      },
    );
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reset application data'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);
    await tester.tap(find.text('Reset application data'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete all data'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();
    expect(find.text('Choose your language'), findsOneWidget);
    await database.close();
  });
}
