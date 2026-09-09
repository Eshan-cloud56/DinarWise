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
  bool tutorialCompleted = true,
}) async {
  SharedPreferences.setMockInitialValues({
    'dashboard_tutorial_completed_v1': tutorialCompleted,
    ...preferences,
  });
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
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await tester.runAsync(database.close);
  });

  testWidgets('English selection opens English privacy consent',
      (tester) async {
    final database = await pumpApp(tester);
    await tester.tap(find.text('English').first);
    await tester.pumpAndSettle();
    expect(find.text('Welcome to DinarWise'), findsOneWidget);
    expect(find.byKey(const ValueKey('privacyPolicyAcknowledgementText')),
        findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
    expect(find.text('Allow anonymous analytics'), findsNothing);
    expect(find.text('Allow diagnostic data'), findsNothing);
    expect(find.byType(Checkbox), findsNothing);
    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Get Started'),
    );
    expect(button.onPressed, isNotNull);

    final acknowledgementText = tester.widget<Text>(
      find.byKey(const ValueKey('privacyPolicyAcknowledgementText')),
    );
    final policyLink = (acknowledgementText.textSpan! as TextSpan)
        .children!
        .whereType<TextSpan>()
        .singleWhere((span) => span.recognizer != null);
    (policyLink.recognizer! as TapGestureRecognizer).onTap!();
    await tester.pump();
    expect(find.byType(Checkbox), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await tester.runAsync(database.close);
  });

  testWidgets('Arabic selection applies Arabic RTL privacy screen', (
    tester,
  ) async {
    final database = await pumpApp(tester);
    await tester.tap(find.text('العربية'));
    await tester.pumpAndSettle();
    expect(find.text('أهلاً بك في دينار وايز'), findsOneWidget);
    expect(find.byKey(const ValueKey('privacyPolicyAcknowledgementText')),
        findsOneWidget);
    expect(find.text('ابدأ الآن'), findsOneWidget);
    expect(find.text('السماح بالتحليلات المجهولة'), findsNothing);
    expect(find.text('السماح ببيانات التشخيص'), findsNothing);
    expect(find.byType(Checkbox), findsNothing);
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
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await tester.runAsync(database.close);
  });

  testWidgets('consent gates dashboard and is persisted', (tester) async {
    final database = await pumpApp(tester);
    await tester.tap(find.text('English').first);
    await tester.pumpAndSettle();
    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Get Started'),
    );
    expect(button.onPressed, isNotNull);
    await tester.ensureVisible(find.text('Get Started'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();
    expect(find.text('Choose your currency'), findsOneWidget);
    await tester.tap(find.text('Saudi Riyal'));
    await tester.pump();
    await tester.ensureVisible(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Recent expenses'), findsOneWidget);
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getBool('privacy_policy_accepted'), isTrue);
    expect(
      preferences.getString('privacy_policy_version'),
      currentPrivacyPolicyVersion,
    );
    expect(preferences.getBool('onboarding_completed'), isTrue);
    expect(preferences.getString('selected_currency'), 'SAR');
    expect(preferences.getString('privacy_policy_accepted_at'), isNotNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await tester.runAsync(database.close);
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
        'selected_currency': 'SAR',
        'local_profile_id': 'stable-test-profile',
      },
    );
    expect(find.text('Recent expenses'), findsOneWidget);
    expect(find.text('Total income'), findsOneWidget);
    expect(find.text('Total expenses'), findsOneWidget);
    expect(find.text('Available to spend'), findsOneWidget);
    expect(find.text('Add income'), findsOneWidget);
    expect(find.text('Choose your language'), findsNothing);
    await tester
        .ensureVisible(find.byKey(const ValueKey('dashboardAddIncome')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('dashboardAddIncome')));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.byKey(const ValueKey('incomeAmountField')), findsOneWidget);
    expect(find.text('Merchant'), findsNothing);
    expect(find.byType(SegmentedButton<String>), findsNothing);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await tester.runAsync(database.close);
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
        'selected_currency': 'SAR',
      },
    );
    expect(find.text('Welcome to DinarWise'), findsOneWidget);
    expect(find.text('Choose your language'), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await tester.runAsync(database.close);
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
        'selected_currency': 'SAR',
        'local_profile_id': 'stable-test-profile',
      },
    );
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Allow anonymous analytics'), findsNothing);
    expect(find.text('Allow diagnostic data'), findsNothing);
    await tester.tap(find.byType(DropdownButton<String>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('العربية').last);
    await tester.pumpAndSettle();
    expect(find.text('الإعدادات'), findsOneWidget);
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getBool('privacy_policy_accepted'), isTrue);
    expect(preferences.getString('selected_language'), 'ar');
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await tester.runAsync(database.close);
  });

  testWidgets('tutorial appears once and Skip persists completion',
      (tester) async {
    final database = await pumpApp(
      tester,
      tutorialCompleted: false,
      preferences: {
        'selected_language': 'en',
        'privacy_policy_accepted': true,
        'privacy_policy_version': currentPrivacyPolicyVersion,
        'privacy_policy_accepted_at': '2026-08-24T00:00:00.000Z',
        'onboarding_completed': true,
        'selected_currency': 'SAR',
        'local_profile_id': 'stable-test-profile',
      },
    );
    await tester.pumpAndSettle();
    expect(find.text('Dashboard summary'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);

    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    final preferences = AppPreferences(await SharedPreferences.getInstance());
    expect(preferences.dashboardTutorialCompletedV1, isTrue);
    expect(find.text('Dashboard summary'), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await tester.runAsync(database.close);
  });

  testWidgets('tutorial Finish persists completion', (tester) async {
    final database = await pumpApp(
      tester,
      tutorialCompleted: false,
      preferences: {
        'selected_language': 'en',
        'privacy_policy_accepted': true,
        'privacy_policy_version': currentPrivacyPolicyVersion,
        'privacy_policy_accepted_at': '2026-08-24T00:00:00.000Z',
        'onboarding_completed': true,
        'selected_currency': 'SAR',
        'local_profile_id': 'stable-test-profile',
      },
    );
    await tester.pumpAndSettle();
    for (var index = 0; index < 6; index++) {
      expect(find.text('Next'), findsOneWidget);
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
    }
    expect(find.text('Finish'), findsOneWidget);
    await tester.tap(find.text('Finish'));
    await tester.pumpAndSettle();

    final preferences = AppPreferences(await SharedPreferences.getInstance());
    expect(preferences.dashboardTutorialCompletedV1, isTrue);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await tester.runAsync(database.close);
  });

  testWidgets('Settings replays tutorial without changing financial data',
      (tester) async {
    final database = await pumpApp(
      tester,
      preferences: {
        'selected_language': 'en',
        'privacy_policy_accepted': true,
        'privacy_policy_version': currentPrivacyPolicyVersion,
        'privacy_policy_accepted_at': '2026-08-24T00:00:00.000Z',
        'onboarding_completed': true,
        'selected_currency': 'SAR',
        'local_profile_id': 'stable-test-profile',
      },
    );
    final categoryCountBefore =
        await database.select(database.expenseCategories).get().then(
              (rows) => rows.length,
            );
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Replay app tutorial'), findsOneWidget);
    await tester.tap(find.text('Replay app tutorial'));
    await tester.pumpAndSettle();
    expect(find.text('Dashboard summary'), findsOneWidget);
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    final categoryCountAfter =
        await database.select(database.expenseCategories).get().then(
              (rows) => rows.length,
            );
    expect(categoryCountAfter, categoryCountBefore);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await tester.runAsync(database.close);
  });

  testWidgets('Arabic tutorial renders RTL without overflow', (tester) async {
    final database = await pumpApp(
      tester,
      tutorialCompleted: false,
      preferences: {
        'selected_language': 'ar',
        'privacy_policy_accepted': true,
        'privacy_policy_version': currentPrivacyPolicyVersion,
        'privacy_policy_accepted_at': '2026-08-24T00:00:00.000Z',
        'onboarding_completed': true,
        'selected_currency': 'SAR',
        'local_profile_id': 'stable-test-profile',
      },
    );
    await tester.pumpAndSettle();
    expect(find.text('ملخص لوحة التحكم'), findsOneWidget);
    expect(find.text('تخطي'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('تخطي'));
    await tester.pumpAndSettle();
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await tester.runAsync(database.close);
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
        'selected_currency': 'SAR',
        'local_profile_id': 'stable-test-profile',
      },
    );
    expect(find.text('المصروفات الأخيرة'), findsOneWidget);
    expect(find.text('إجمالي الدخل'), findsOneWidget);
    expect(find.text('إجمالي المصروفات'), findsOneWidget);
    expect(find.text('المتاح للإنفاق'), findsOneWidget);
    expect(find.text('إضافة دخل'), findsOneWidget);
    expect(find.text('Recent expenses'), findsNothing);
    expect(
      tester
          .widget<Directionality>(
            find
                .ancestor(
                  of: find.text('المصروفات الأخيرة'),
                  matching: find.byType(Directionality),
                )
                .first,
          )
          .textDirection,
      TextDirection.rtl,
    );
    await tester.ensureVisible(find.text('الميزانيات'));
    await tester.pumpAndSettle();
    await tester.pumpAndSettle();
    expect(find.text('التخطيط المالي'), findsWidgets);
    expect(find.text('الميزانيات'), findsOneWidget);
    expect(find.text('خطط اشترِ الآن وادفع لاحقًا'), findsOneWidget);

    await tester.ensureVisible(find.byIcon(Icons.auto_awesome_outlined));
    await tester.pumpAndSettle();
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
    await tester.scrollUntilVisible(
        find.byKey(const ValueKey('expenseMerchantField')), 150,
        scrollable: find
            .descendant(
                of: find.byType(ListView).first,
                matching: find.byType(Scrollable))
            .first);
    await tester.pumpAndSettle();
    expect(find.text('المتجر *'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('الفئة'), -100,
        scrollable: find
            .descendant(
                of: find.byType(ListView).first,
                matching: find.byType(Scrollable))
            .first);
    await tester.pumpAndSettle();
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
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await tester.runAsync(database.close);
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
        'selected_currency': 'SAR',
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
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await tester.runAsync(database.close);
  });
}
