import 'package:dinarwise/core/constants.dart';
import 'package:dinarwise/core/database/app_database.dart';
import 'package:dinarwise/core/database/database_provider.dart';
import 'package:dinarwise/core/preferences/app_preferences.dart';
import 'package:dinarwise/features/capture/capture_screen.dart';
import 'package:dinarwise/features/categories/data/category_repository.dart';
import 'package:dinarwise/features/payment_methods/payment_method_repository.dart';
import 'package:dinarwise/features/voice_expense/domain/voice_expense_parser.dart';
import 'package:dinarwise/features/voice_expense/application/voice_expense_coordinator.dart';
import 'package:dinarwise/features/voice_expense/models/voice_expense_draft.dart';
import 'package:dinarwise/features/voice_expense/presentation/voice_expense_modal.dart';
import 'package:dinarwise/l10n/generated/app_localizations.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final testCategories = [
    const CategoryRecord(
      id: 'cat-restaurants',
      name: 'Restaurants & Cafes',
      systemCode: 'restaurants',
      isSystem: true,
    ),
    const CategoryRecord(
      id: 'cat-groceries',
      name: 'Groceries',
      systemCode: 'groceries',
      isSystem: true,
    ),
    const CategoryRecord(
      id: 'cat-fuel',
      name: 'Fuel',
      systemCode: 'fuel',
      isSystem: true,
    ),
    const CategoryRecord(
      id: 'cat-transportation',
      name: 'Transportation',
      systemCode: 'transportation',
      isSystem: true,
    ),
    const CategoryRecord(
      id: 'cat-shopping',
      name: 'Shopping',
      systemCode: 'shopping',
      isSystem: true,
    ),
    const CategoryRecord(
      id: 'cat-utilities',
      name: 'Utilities',
      systemCode: 'utilities',
      isSystem: true,
    ),
    const CategoryRecord(
      id: 'cat-subscriptions',
      name: 'Subscriptions',
      systemCode: 'subscriptions',
      isSystem: true,
    ),
  ];

  final List<PaymentMethodDetails> testPaymentMethods = [
    const PaymentMethodDetails(
      id: 'pm-cash',
      systemCode: 'cash',
      name: 'Cash',
      iconName: 'cash',
      isSystem: true,
      isDefault: true,
      usageCount: 0,
      lastUsedAt: null,
    ),
    const PaymentMethodDetails(
      id: 'pm-visa',
      systemCode: 'card',
      name: 'Visa Card',
      iconName: 'credit_card',
      isSystem: true,
      isDefault: false,
      usageCount: 0,
      lastUsedAt: null,
    ),
    const PaymentMethodDetails(
      id: 'pm-mada',
      systemCode: 'card',
      name: 'Mada Debit',
      iconName: 'credit_card',
      isSystem: true,
      isDefault: false,
      usageCount: 0,
      lastUsedAt: null,
    ),
    const PaymentMethodDetails(
      id: 'pm-bank-transfer',
      systemCode: 'bank_transfer',
      name: 'Bank Transfer',
      iconName: 'bank_transfer',
      isSystem: true,
      isDefault: false,
      usageCount: 0,
      lastUsedAt: null,
    ),
    const PaymentMethodDetails(
      id: 'pm-stc-pay',
      systemCode: 'stc_pay',
      name: 'STC Pay',
      iconName: 'stc_pay',
      isSystem: true,
      isDefault: false,
      usageCount: 0,
      lastUsedAt: null,
    ),
    const PaymentMethodDetails(
      id: 'pm-mastercard',
      systemCode: 'mastercard',
      name: 'Mastercard',
      iconName: 'credit_card',
      isSystem: true,
      isDefault: false,
      usageCount: 0,
      lastUsedAt: null,
    ),
    const PaymentMethodDetails(
      id: 'pm-apple-pay',
      systemCode: 'apple_pay',
      name: 'Apple Pay',
      iconName: 'apple_pay',
      isSystem: true,
      isDefault: false,
      usageCount: 0,
      lastUsedAt: null,
    ),
  ];

  final referenceDate = DateTime(2026, 9, 17, 14, 0);

  group('VoiceExpenseParser - Required Prompts', () {
    test('I spent 100 SAR at AlBaik using cash.', () {
      final draft = VoiceExpenseParser.parse(
        transcript: 'I spent 100 SAR at AlBaik using cash.',
        categories: testCategories,
        paymentMethods: testPaymentMethods,
        now: referenceDate,
      );

      expect(draft.amountMinor, 10000); // 100 * 100
      expect(draft.currency, 'SAR');
      expect(draft.merchant, 'Al Baik');
      expect(draft.categoryId, 'cat-restaurants');
      expect(draft.paymentMethodId, 'pm-cash');
      expect(draft.date?.day, referenceDate.day);
    });

    test('I paid 120 AED at Carrefour with Visa yesterday.', () {
      final draft = VoiceExpenseParser.parse(
        transcript: 'I paid 120 AED at Carrefour with Visa yesterday.',
        categories: testCategories,
        paymentMethods: testPaymentMethods,
        now: referenceDate,
      );

      expect(draft.amountMinor, 12000); // 120 * 100
      expect(draft.currency, 'AED');
      expect(draft.merchant, 'Carrefour');
      expect(draft.categoryId, 'cat-groceries');
      expect(draft.paymentMethodId, 'pm-visa');
      expect(draft.date?.day, referenceDate.subtract(const Duration(days: 1)).day);
    });

    test('I bought shoes for 250 riyals.', () {
      final draft = VoiceExpenseParser.parse(
        transcript: 'I bought shoes for 250 riyals.',
        categories: testCategories,
        paymentMethods: testPaymentMethods,
        now: referenceDate,
      );

      expect(draft.amountMinor, 25000); // 250 * 100
      expect(draft.currency, 'SAR');
      expect(draft.categoryId, 'cat-shopping');
      expect(draft.paymentMethodId, isNull); // Never invent payment method
      expect(draft.description, isNull); // No explicit note spoken
    });

    test('Spent 80 SAR on fuel using cash.', () {
      final draft = VoiceExpenseParser.parse(
        transcript: 'Spent 80 SAR on fuel using cash.',
        categories: testCategories,
        paymentMethods: testPaymentMethods,
        now: referenceDate,
      );

      expect(draft.amountMinor, 8000);
      expect(draft.currency, 'SAR');
      expect(draft.categoryId, 'cat-fuel');
      expect(draft.paymentMethodId, 'pm-cash');
      expect(draft.date?.day, referenceDate.day);
    });

    test('Yesterday I spent 40 SAR on coffee.', () {
      final draft = VoiceExpenseParser.parse(
        transcript: 'Yesterday I spent 40 SAR on coffee.',
        categories: testCategories,
        paymentMethods: testPaymentMethods,
        now: referenceDate,
      );

      expect(draft.amountMinor, 4000);
      expect(draft.currency, 'SAR');
      expect(draft.categoryId, 'cat-restaurants');
      expect(draft.paymentMethodId, isNull);
      expect(draft.date?.day, referenceDate.subtract(const Duration(days: 1)).day);
    });
  });

  group('VoiceExpenseParser - Edge Cases & Robustness', () {
    test('Incomplete input: I spent 50 riyals', () {
      final draft = VoiceExpenseParser.parse(
        transcript: 'I spent 50 riyals',
        categories: testCategories,
        paymentMethods: testPaymentMethods,
        now: referenceDate,
      );

      expect(draft.amountMinor, 5000);
      expect(draft.currency, 'SAR');
      expect(draft.merchant, isNull);
      expect(draft.categoryId, isNull);
      expect(draft.paymentMethodId, isNull);
      expect(draft.hasAmount, isTrue);
    });

    test('Unknown merchant: Spent 75 SAR at CornerBoutique with card', () {
      final draft = VoiceExpenseParser.parse(
        transcript: 'Spent 75 SAR at CornerBoutique with card',
        categories: testCategories,
        paymentMethods: testPaymentMethods,
        now: referenceDate,
      );

      expect(draft.amountMinor, 7500);
      expect(draft.currency, 'SAR');
      expect(draft.merchant, 'CornerBoutique');
      expect(draft.categoryId, isNull); // Unknown category left unset
      expect(draft.paymentMethodId, 'pm-visa'); // Matches card
    });

    test('No payment method spoken does not invent payment method when no default provided', () {
      final draft = VoiceExpenseParser.parse(
        transcript: 'Bought groceries for 95 SAR at Panda',
        categories: testCategories,
        paymentMethods: testPaymentMethods,
        now: referenceDate,
      );

      expect(draft.amountMinor, 9500);
      expect(draft.merchant, 'Panda');
      expect(draft.categoryId, 'cat-groceries');
      expect(draft.paymentMethodId, isNull);
    });

    test('Handoff to CaptureLaunchArgs creates valid arguments for Add Expense', () {
      final draft = VoiceExpenseParser.parse(
        transcript: 'I spent 100 SAR at AlBaik using cash.',
        categories: testCategories,
        paymentMethods: testPaymentMethods,
        now: referenceDate,
      );

      final launchArgs = draft.toCaptureLaunchArgs();
      expect(launchArgs.prefilledMerchant, 'Al Baik');
      expect(launchArgs.prefilledAmountMinor, 10000);
      expect(launchArgs.prefilledCategoryId, 'cat-restaurants');
      expect(launchArgs.prefilledPaymentMethodId, 'pm-cash');
      expect(launchArgs.prefilledCurrency, 'SAR');
    });

    test('Stage 2 Targeted Acceptance Test: "I spend 100 Saudi riyal on Al Baik today using bank transfer"', () {
      final draft = VoiceExpenseParser.parse(
        transcript: 'I spend 100 Saudi riyal on Al Baik today using bank transfer.',
        categories: testCategories,
        paymentMethods: testPaymentMethods,
        now: referenceDate,
      );

      expect(draft.amountMinor, 10000); // 100 SAR in minor units
      expect(draft.currency, 'SAR');
      expect(draft.merchant, 'Al Baik');
      expect(draft.categoryId, 'cat-restaurants');
      expect(draft.paymentMethodId, 'pm-bank-transfer');
      expect(draft.date?.day, referenceDate.day);

      // Verify handoff to Add Expense prefill
      final launchArgs = draft.toCaptureLaunchArgs();
      expect(launchArgs.prefilledPaymentMethodId, 'pm-bank-transfer');
      expect(launchArgs.prefilledAmountMinor, 10000);
      expect(launchArgs.prefilledMerchant, 'Al Baik');
      expect(launchArgs.prefilledCategoryId, 'cat-restaurants');
    });

    test('Stage 2 Latest Real-Device Transcript: "Hey, then I rise, I have just spend it 100 Saudi riyal on Al Baik using my bank transfer."', () {
      final draft = VoiceExpenseParser.parse(
        transcript: 'Hey, then I rise, I have just spend it 100 Saudi riyal on Al Baik using my bank transfer.',
        categories: testCategories,
        paymentMethods: testPaymentMethods,
        now: referenceDate,
      );

      expect(draft.amountMinor, 10000); // 100.00 SAR
      expect(draft.currency, 'SAR');
      expect(draft.merchant, 'Al Baik');
      expect(draft.categoryId, 'cat-restaurants');
      expect(draft.paymentMethodId, 'pm-bank-transfer');
      expect(draft.date?.day, referenceDate.day);

      final launchArgs = draft.toCaptureLaunchArgs();
      expect(launchArgs.prefilledPaymentMethodId, 'pm-bank-transfer');
      expect(launchArgs.prefilledAmountMinor, 10000);
      expect(launchArgs.prefilledMerchant, 'Al Baik');
      expect(launchArgs.prefilledCategoryId, 'cat-restaurants');
      expect(launchArgs.prefilledCurrency, 'SAR');
    });

    test('Filters [BLANK_AUDIO] tokens and extracts entities accurately', () {
      final draft = VoiceExpenseParser.parse(
        transcript: 'I spent 100 SAR at Al Baik today using bank transfer. [BLANK_AUDIO]',
        categories: testCategories,
        paymentMethods: testPaymentMethods,
        now: referenceDate,
      );

      expect(draft.amountMinor, 10000);
      expect(draft.currency, 'SAR');
      expect(draft.merchant, 'Al Baik');
      expect(draft.paymentMethodId, 'pm-bank-transfer');
      expect(draft.rawTranscript, 'I spent 100 SAR at Al Baik today using bank transfer.');
    });

    test('Bank Transfer recognition across variants (via, paid by, through, Arabic)', () {
      final variants = [
        'Spent 500 SAR at Ikea via bank transfer',
        'Paid 300 SAR at Jarir paid by bank transfer',
        'Spent 200 SAR through bank transfer at Danube',
        'دفعت 150 ريال في جرير تحويل بنكي',
      ];

      for (final text in variants) {
        final draft = VoiceExpenseParser.parse(
          transcript: text,
          categories: testCategories,
          paymentMethods: testPaymentMethods,
          now: referenceDate,
        );
        expect(draft.paymentMethodId, 'pm-bank-transfer', reason: 'Failed for: $text');
      }
    });

    testWidgets('CaptureScreen initializes with prefilled Bank Transfer and preserves it', (tester) async {
      SharedPreferences.setMockInitialValues({
        'selected_language': 'en',
        'privacy_policy_accepted': true,
        'privacy_policy_version': currentPrivacyPolicyVersion,
        'privacy_policy_accepted_at': '2026-09-04T00:00:00Z',
        'onboarding_completed': true,
        'selected_currency': 'SAR',
        'local_profile_id': 'voice-test-profile',
      });
      final db = AppDatabase(NativeDatabase.memory());
      final prefs = await SharedPreferences.getInstance();

      final pmRepo = PaymentMethodRepository(db);
      await pmRepo.ensureDefaults('voice-test-profile');
      final allMethods = await pmRepo.watchAll('voice-test-profile').first;

      // Full end-to-end chain from raw transcript -> parser -> draft -> launchArgs -> CaptureScreen
      final draft = VoiceExpenseParser.parse(
        transcript: 'Hey, then I rise, I have just spend it 100 Saudi riyal on Al Baik using my bank transfer.',
        categories: testCategories,
        paymentMethods: allMethods,
      );
      expect(draft.paymentMethodId, isNotNull);
      final bankTransfer = allMethods.firstWhere((m) => m.id == draft.paymentMethodId);
      expect(bankTransfer.systemCode, 'bank_transfer');

      final launchArgs = draft.toCaptureLaunchArgs();

      tester.view.physicalSize = const Size(800, 2000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            databaseProvider.overrideWithValue(db),
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: CaptureScreen(
                prefilledMerchant: launchArgs.prefilledMerchant,
                prefilledAmountMinor: launchArgs.prefilledAmountMinor,
                prefilledPaymentMethodId: launchArgs.prefilledPaymentMethodId,
                prefilledCurrency: launchArgs.prefilledCurrency,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Amount field is prefilled with 100.00
      expect(
        find.byWidgetPredicate((w) => w is EditableText && w.controller.text == '100.00'),
        findsOneWidget,
      );
      // Verify Merchant field is prefilled with Al Baik
      expect(
        find.byWidgetPredicate((w) => w is EditableText && w.controller.text == 'Al Baik'),
        findsOneWidget,
      );
      // Verify Payment Method field displays Bank Transfer (and NOT Cash)
      expect(find.text('Bank Transfer'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      await tester.runAsync(db.close);
    });

    testWidgets('VoiceExpenseModal renders without overflow at small screen heights', (tester) async {
      tester.view.physicalSize = const Size(360, 480);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Put coordinator into result state with a draft
      final coordinator = container.read(voiceExpenseCoordinatorProvider.notifier);
      coordinator.state = VoiceExpenseState(
        status: VoiceExpenseStatus.result,
        draft: VoiceExpenseDraft(
          rawTranscript: 'I spend 100 Saudi riyal on Al Baik today using bank transfer.',
          amountMinor: 10000,
          currency: 'SAR',
          merchant: 'Al Baik',
          categoryId: 'cat-restaurants',
          paymentMethodId: 'pm-bank-transfer',
          date: DateTime.now(),
        ),
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: VoiceExpenseModal(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Ensure NO Flutter RenderFlex exception occurred
      expect(tester.takeException(), isNull);

      // Verify Cancel and Review in Add Expense buttons are present
      expect(find.byKey(const ValueKey('voiceExpenseCancelButton')), findsOneWidget);
      expect(find.byKey(const ValueKey('voiceExpenseReviewButton')), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    });

    testWidgets('VoiceExpenseModal Cancel button discards draft and resets coordinator to fresh ready state', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final coordinator = container.read(voiceExpenseCoordinatorProvider.notifier);
      coordinator.state = VoiceExpenseState(
        status: VoiceExpenseStatus.result,
        draft: VoiceExpenseDraft(
          rawTranscript: 'I spend 100 Saudi riyal on Al Baik today using bank transfer.',
          amountMinor: 10000,
          currency: 'SAR',
          merchant: 'Al Baik',
          categoryId: 'cat-restaurants',
          paymentMethodId: 'pm-bank-transfer',
          date: DateTime.now(),
        ),
        rawTranscript: 'I spend 100 Saudi riyal on Al Baik today using bank transfer.',
        hasCachedAudio: true,
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: VoiceExpenseModal(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Cancel button
      await tester.tap(find.byKey(const ValueKey('voiceExpenseCancelButton')));
      await tester.pumpAndSettle();

      // Verify coordinator state is reset to Ready with draft cleared
      final stateAfter = container.read(voiceExpenseCoordinatorProvider);
      expect(stateAfter.status, VoiceExpenseStatus.ready);
      expect(stateAfter.draft, isNull);
      expect(stateAfter.rawTranscript, isNull);
      expect(stateAfter.hasCachedAudio, isFalse);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    });

    testWidgets('VoiceExpenseModal Close button discards draft and resets coordinator to fresh ready state', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final coordinator = container.read(voiceExpenseCoordinatorProvider.notifier);
      coordinator.state = VoiceExpenseState(
        status: VoiceExpenseStatus.result,
        draft: VoiceExpenseDraft(
          rawTranscript: 'I spend 100 Saudi riyal on Al Baik today using bank transfer.',
          amountMinor: 10000,
          currency: 'SAR',
          merchant: 'Al Baik',
          categoryId: 'cat-restaurants',
          paymentMethodId: 'pm-bank-transfer',
          date: DateTime.now(),
        ),
        rawTranscript: 'I spend 100 Saudi riyal on Al Baik today using bank transfer.',
        hasCachedAudio: true,
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: VoiceExpenseModal(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Close button
      await tester.tap(find.byKey(const ValueKey('voiceExpenseCloseButton')));
      await tester.pumpAndSettle();

      final stateAfter = container.read(voiceExpenseCoordinatorProvider);
      expect(stateAfter.status, VoiceExpenseStatus.ready);
      expect(stateAfter.draft, isNull);
      expect(stateAfter.rawTranscript, isNull);
      expect(stateAfter.hasCachedAudio, isFalse);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    });

    testWidgets('VoiceExpenseModal displays real Category and Payment Method names and never shows "Matched"', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final coordinator = container.read(voiceExpenseCoordinatorProvider.notifier);
      coordinator.state = VoiceExpenseState(
        status: VoiceExpenseStatus.result,
        draft: VoiceExpenseDraft(
          rawTranscript: 'I spent 100 SAR at Al Baik today using bank transfer',
          amountMinor: 10000,
          currency: 'SAR',
          merchant: 'Al Baik',
          categoryId: 'cat-restaurants',
          categoryName: 'Restaurants & Cafés',
          paymentMethodId: 'pm-bank-transfer',
          paymentMethodName: 'Bank Transfer',
          date: DateTime.now(),
        ),
        rawTranscript: 'I spent 100 SAR at Al Baik today using bank transfer',
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: VoiceExpenseModal(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Restaurants & Cafés'), findsOneWidget);
      expect(find.text('Bank Transfer'), findsOneWidget);
      expect(find.text('Matched'), findsNothing);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    });
  });

  group('Voice Expense - Section 8 Acceptance Cases', () {
    test('Case 1: I spent 100 SAR at Al Baik today using bank transfer', () {
      final draft = VoiceExpenseParser.parse(
        transcript: 'I spent 100 SAR at Al Baik today using bank transfer',
        categories: testCategories,
        paymentMethods: testPaymentMethods,
        now: referenceDate,
      );

      expect(draft.amountMinor, 10000); // 100 SAR
      expect(draft.currency, 'SAR');
      expect(draft.merchant, 'Al Baik');
      expect(draft.categoryId, 'cat-restaurants');
      expect(draft.categoryName, 'Restaurants & Cafes');
      expect(draft.paymentMethodId, 'pm-bank-transfer');
      expect(draft.paymentMethodName, 'Bank Transfer');
      expect(draft.date?.day, referenceDate.day);

      // Verify handoff to CaptureLaunchArgs
      final launchArgs = draft.toCaptureLaunchArgs();
      expect(launchArgs.prefilledAmountMinor, 10000);
      expect(launchArgs.prefilledCurrency, 'SAR');
      expect(launchArgs.prefilledMerchant, 'Al Baik');
      expect(launchArgs.prefilledCategoryId, 'cat-restaurants');
      expect(launchArgs.prefilledPaymentMethodId, 'pm-bank-transfer');
    });

    test('Case 2: I paid 250 SAR at Apple Store using Visa', () {
      final draft = VoiceExpenseParser.parse(
        transcript: 'I paid 250 SAR at Apple Store using Visa',
        categories: testCategories,
        paymentMethods: testPaymentMethods,
        now: referenceDate,
      );

      expect(draft.amountMinor, 25000); // 250 SAR
      expect(draft.currency, 'SAR');
      expect(draft.merchant, 'Apple Store');
      expect(draft.categoryId, 'cat-shopping');
      expect(draft.paymentMethodId, 'pm-visa');
      expect(draft.date?.day, referenceDate.day);
    });

    test('Case 3: I spent 80 SAR on fuel using cash', () {
      final draft = VoiceExpenseParser.parse(
        transcript: 'I spent 80 SAR on fuel using cash',
        categories: testCategories,
        paymentMethods: testPaymentMethods,
        now: referenceDate,
      );

      expect(draft.amountMinor, 8000); // 80 SAR
      expect(draft.currency, 'SAR');
      expect(draft.categoryId, 'cat-fuel');
      expect(draft.paymentMethodId, 'pm-cash');
      expect(draft.date?.day, referenceDate.day);
    });

    test('Case 4: Yesterday I spent 40 SAR at Starbucks', () {
      final draft = VoiceExpenseParser.parse(
        transcript: 'Yesterday I spent 40 SAR at Starbucks',
        categories: testCategories,
        paymentMethods: testPaymentMethods,
        now: referenceDate,
      );

      expect(draft.amountMinor, 4000); // 40 SAR
      expect(draft.currency, 'SAR');
      expect(draft.merchant, 'Starbucks');
      expect(draft.categoryId, 'cat-restaurants');
      expect(draft.date?.day, referenceDate.subtract(const Duration(days: 1)).day);
    });

    test('Case 5: I paid 120 AED at Carrefour using Visa', () {
      final draft = VoiceExpenseParser.parse(
        transcript: 'I paid 120 AED at Carrefour using Visa',
        categories: testCategories,
        paymentMethods: testPaymentMethods,
        now: referenceDate,
      );

      expect(draft.amountMinor, 12000); // 120 AED
      expect(draft.currency, 'AED');
      expect(draft.merchant, 'Carrefour');
      expect(draft.categoryId, 'cat-groceries');
      expect(draft.paymentMethodId, 'pm-visa');
    });

    test('Case 6: I just spent 1000 SAR at Apple Store', () {
      final draft = VoiceExpenseParser.parse(
        transcript: 'I just spent 1000 SAR at Apple Store',
        categories: testCategories,
        paymentMethods: testPaymentMethods,
        now: referenceDate,
      );

      expect(draft.amountMinor, 100000); // 1000 SAR
      expect(draft.currency, 'SAR');
      expect(draft.merchant, 'Apple Store');
      expect(draft.categoryId, 'cat-shopping');
      // No falsely voice-recognized payment method
      expect(draft.paymentMethodId, isNull);
    });

    test('Case 7: I spent one hundred SAR at Al Baik', () {
      final draft = VoiceExpenseParser.parse(
        transcript: 'I spent one hundred SAR at Al Baik',
        categories: testCategories,
        paymentMethods: testPaymentMethods,
        now: referenceDate,
      );

      expect(draft.amountMinor, 10000); // 100 SAR
      expect(draft.currency, 'SAR');
      expect(draft.merchant, 'Al Baik');
      expect(draft.categoryId, 'cat-restaurants');
    });

    test('Partial input: I spent 50 SAR', () {
      final draft = VoiceExpenseParser.parse(
        transcript: 'I spent 50 SAR',
        categories: testCategories,
        paymentMethods: testPaymentMethods,
        now: referenceDate,
      );

      expect(draft.amountMinor, 5000); // 50 SAR
      expect(draft.currency, 'SAR');
      expect(draft.merchant, isNull);
      expect(draft.categoryId, isNull);
      expect(draft.paymentMethodId, isNull);
      expect(draft.hasAmount, isTrue);

      final args = draft.toCaptureLaunchArgs();
      expect(args.prefilledAmountMinor, 5000);
      expect(args.prefilledMerchant, isNull);
    });
  });

  group('Voice Expense - Section 3 Parser Verification', () {
    test('Amount: numbers, decimals, and spoken compound numbers', () {
      // 100
      var d = VoiceExpenseParser.parse(transcript: '100 SAR', categories: testCategories);
      expect(d.amountMinor, 10000);

      // 100.50
      d = VoiceExpenseParser.parse(transcript: '100.50 SAR', categories: testCategories);
      expect(d.amountMinor, 10050);

      // one hundred
      d = VoiceExpenseParser.parse(transcript: 'one hundred SAR', categories: testCategories);
      expect(d.amountMinor, 10000);

      // two hundred fifty
      d = VoiceExpenseParser.parse(transcript: 'two hundred fifty SAR', categories: testCategories);
      expect(d.amountMinor, 25000);

      // two hundred and fifty
      d = VoiceExpenseParser.parse(transcript: 'two hundred and fifty SAR', categories: testCategories);
      expect(d.amountMinor, 25000);

      // forty
      d = VoiceExpenseParser.parse(transcript: 'forty SAR', categories: testCategories);
      expect(d.amountMinor, 4000);

      // one thousand
      d = VoiceExpenseParser.parse(transcript: 'one thousand SAR', categories: testCategories);
      expect(d.amountMinor, 100000);
    });

    test('Currency: all 6 GCC currencies recognized; unsupported not converted', () {
      // SAR / Saudi riyal / riyals
      var d = VoiceExpenseParser.parse(transcript: 'spent 50 Saudi riyal', categories: testCategories);
      expect(d.currency, 'SAR');
      d = VoiceExpenseParser.parse(transcript: 'spent 50 riyals', categories: testCategories);
      expect(d.currency, 'SAR');

      // AED / dirham
      d = VoiceExpenseParser.parse(transcript: 'spent 50 dirham', categories: testCategories);
      expect(d.currency, 'AED');

      // KWD
      d = VoiceExpenseParser.parse(transcript: 'spent 50 KWD', categories: testCategories);
      expect(d.currency, 'KWD');

      // BHD
      d = VoiceExpenseParser.parse(transcript: 'spent 50 BHD', categories: testCategories);
      expect(d.currency, 'BHD');

      // QAR
      d = VoiceExpenseParser.parse(transcript: 'spent 50 QAR', categories: testCategories);
      expect(d.currency, 'QAR');

      // OMR
      d = VoiceExpenseParser.parse(transcript: 'spent 50 OMR', categories: testCategories);
      expect(d.currency, 'OMR');

      // Unsupported currency never converted to another currency
      d = VoiceExpenseParser.parse(transcript: 'spent 50 dollars', categories: testCategories);
      expect(d.currency, isNull);
      d = VoiceExpenseParser.parse(transcript: 'spent 50 USD', categories: testCategories);
      expect(d.currency, isNull);
      d = VoiceExpenseParser.parse(transcript: 'spent 50 euros', categories: testCategories);
      expect(d.currency, isNull);
    });

    test('Payment Method: Cash, Bank Transfer, Visa, Mastercard, Mada, Apple Pay, STC Pay', () {
      // Cash
      var d = VoiceExpenseParser.parse(
        transcript: 'spent 50 SAR with cash',
        categories: testCategories,
        paymentMethods: testPaymentMethods,
      );
      expect(d.paymentMethodId, 'pm-cash');

      // Bank Transfer
      d = VoiceExpenseParser.parse(
        transcript: 'spent 50 SAR via bank transfer',
        categories: testCategories,
        paymentMethods: testPaymentMethods,
      );
      expect(d.paymentMethodId, 'pm-bank-transfer');

      // Visa
      d = VoiceExpenseParser.parse(
        transcript: 'spent 50 SAR using Visa',
        categories: testCategories,
        paymentMethods: testPaymentMethods,
      );
      expect(d.paymentMethodId, 'pm-visa');

      // Mastercard
      d = VoiceExpenseParser.parse(
        transcript: 'spent 50 SAR using Mastercard',
        categories: testCategories,
        paymentMethods: testPaymentMethods,
      );
      expect(d.paymentMethodId, 'pm-mastercard');

      // Mada
      d = VoiceExpenseParser.parse(
        transcript: 'spent 50 SAR using Mada',
        categories: testCategories,
        paymentMethods: testPaymentMethods,
      );
      expect(d.paymentMethodId, 'pm-mada');

      // Apple Pay
      d = VoiceExpenseParser.parse(
        transcript: 'spent 50 SAR using Apple Pay',
        categories: testCategories,
        paymentMethods: testPaymentMethods,
      );
      expect(d.paymentMethodId, 'pm-apple-pay');

      // STC Pay
      d = VoiceExpenseParser.parse(
        transcript: 'spent 50 SAR using STC Pay',
        categories: testCategories,
        paymentMethods: testPaymentMethods,
      );
      expect(d.paymentMethodId, 'pm-stc-pay');

      // Spoken payment method overrides default Cash
      d = VoiceExpenseParser.parse(
        transcript: 'spent 50 SAR using bank transfer',
        categories: testCategories,
        paymentMethods: testPaymentMethods,
        defaultPaymentMethodId: 'pm-cash',
      );
      expect(d.paymentMethodId, 'pm-bank-transfer');
    });

    test('Date: Today, Yesterday, this morning, tonight, default', () {
      var d = VoiceExpenseParser.parse(
        transcript: 'spent 50 SAR today',
        categories: testCategories,
        now: referenceDate,
      );
      expect(d.date?.day, referenceDate.day);

      d = VoiceExpenseParser.parse(
        transcript: 'spent 50 SAR yesterday',
        categories: testCategories,
        now: referenceDate,
      );
      expect(d.date?.day, referenceDate.subtract(const Duration(days: 1)).day);

      d = VoiceExpenseParser.parse(
        transcript: 'spent 50 SAR this morning',
        categories: testCategories,
        now: referenceDate,
      );
      expect(d.date?.day, referenceDate.day);

      d = VoiceExpenseParser.parse(
        transcript: 'spent 50 SAR tonight',
        categories: testCategories,
        now: referenceDate,
      );
      expect(d.date?.day, referenceDate.day);

      // No spoken date -> Today
      d = VoiceExpenseParser.parse(
        transcript: 'spent 50 SAR',
        categories: testCategories,
        now: referenceDate,
      );
      expect(d.date?.day, referenceDate.day);
    });
  });

  group('Voice Expense - Plan Tests 1-8', () {
    test('Plan Test 1: Spoken merchant Al Baik → Merchant: Al Baik, Notes: empty', () {
      final draft = VoiceExpenseParser.parse(
        transcript: 'I spent 100 SAR at Al Baik using cash',
        categories: testCategories,
        paymentMethods: testPaymentMethods,
        now: referenceDate,
      );

      expect(draft.amountMinor, 10000);
      expect(draft.currency, 'SAR');
      expect(draft.merchant, 'Al Baik');
      expect(draft.description, isNull); // No explicit note spoken
      expect(draft.categoryId, 'cat-restaurants');
      expect(draft.paymentMethodId, 'pm-cash');
    });

    test('Plan Test 2: I spent 600 SAR on taxi → Merchant: empty, Category: Transportation, Notes: empty, Save blocked', () {
      final draft = VoiceExpenseParser.parse(
        transcript: 'I spent 600 SAR on taxi',
        categories: testCategories,
        paymentMethods: testPaymentMethods,
        now: referenceDate,
      );

      expect(draft.amountMinor, 60000);
      expect(draft.currency, 'SAR');
      expect(draft.merchant, isNull); // taxi is NOT a merchant
      expect(draft.categoryId, 'cat-transportation');
      expect(draft.description, isNull); // No notes
      // autoFocusMerchant should be true in CaptureLaunchArgs
      final args = draft.toCaptureLaunchArgs();
      expect(args.autoFocusMerchant, isTrue);
    });

    test('Plan Test 3: I purchased a subscription for 600 SAR → Merchant: empty, Category: Subscriptions', () {
      final draft = VoiceExpenseParser.parse(
        transcript: 'I purchased a subscription for 600 SAR',
        categories: testCategories,
        paymentMethods: testPaymentMethods,
        now: referenceDate,
      );

      expect(draft.amountMinor, 60000);
      expect(draft.currency, 'SAR');
      expect(draft.merchant, isNull); // subscription is NOT a merchant
      expect(draft.categoryId, 'cat-subscriptions');
      expect(draft.description, isNull);
    });

    test('Plan Test 4: I spent 1000 SAR using Faisal Movers → Merchant: Faisal Movers, Category: Transportation', () {
      final draft = VoiceExpenseParser.parse(
        transcript: 'I spent 1000 SAR using Faisal Movers',
        categories: testCategories,
        paymentMethods: testPaymentMethods,
        now: referenceDate,
      );

      expect(draft.amountMinor, 100000);
      expect(draft.currency, 'SAR');
      expect(draft.merchant, 'Faisal Movers');
      expect(draft.categoryId, 'cat-transportation');
    });

    test('Plan Test 5: I paid 250 SAR at Apple Store using Visa → Merchant: Apple Store, Payment: Visa', () {
      final draft = VoiceExpenseParser.parse(
        transcript: 'I paid 250 SAR at Apple Store using Visa',
        categories: testCategories,
        paymentMethods: testPaymentMethods,
        now: referenceDate,
      );

      expect(draft.amountMinor, 25000);
      expect(draft.currency, 'SAR');
      expect(draft.merchant, 'Apple Store');
      expect(draft.categoryId, 'cat-shopping');
      expect(draft.paymentMethodId, 'pm-visa');
    });

    test('Plan Test 6: I spent 80 SAR on fuel using cash → Merchant: empty, Payment: Cash, Category: Fuel', () {
      final draft = VoiceExpenseParser.parse(
        transcript: 'I spent 80 SAR on fuel using cash',
        categories: testCategories,
        paymentMethods: testPaymentMethods,
        now: referenceDate,
      );

      expect(draft.amountMinor, 8000);
      expect(draft.currency, 'SAR');
      expect(draft.merchant, isNull); // fuel is NOT a merchant
      expect(draft.categoryId, 'cat-fuel');
      expect(draft.paymentMethodId, 'pm-cash');
    });

    test('Plan Test 7: I spent 40 SAR on coffee → Merchant: empty, Category: Restaurants & Cafés', () {
      final draft = VoiceExpenseParser.parse(
        transcript: 'I spent 40 SAR on coffee',
        categories: testCategories,
        paymentMethods: testPaymentMethods,
        now: referenceDate,
      );

      expect(draft.amountMinor, 4000);
      expect(draft.currency, 'SAR');
      expect(draft.merchant, isNull); // coffee is NOT a merchant
      expect(draft.categoryId, 'cat-restaurants');
    });

    test('Plan Test 8: I spent 120 AED at Carrefour using Visa → Merchant: Carrefour, Category: Groceries, Currency: AED', () {
      final draft = VoiceExpenseParser.parse(
        transcript: 'I spent 120 AED at Carrefour using Visa',
        categories: testCategories,
        paymentMethods: testPaymentMethods,
        now: referenceDate,
      );

      expect(draft.amountMinor, 12000);
      expect(draft.currency, 'AED');
      expect(draft.merchant, 'Carrefour');
      expect(draft.categoryId, 'cat-groceries');
      expect(draft.paymentMethodId, 'pm-visa');
    });

    test('Explicit note is extracted from transcript', () {
      final draft = VoiceExpenseParser.parse(
        transcript: 'I spent 200 SAR at Al Baik note dinner with client',
        categories: testCategories,
        paymentMethods: testPaymentMethods,
        now: referenceDate,
      );

      expect(draft.amountMinor, 20000);
      expect(draft.merchant, 'Al Baik');
      expect(draft.description, 'Dinner with client');
    });

    test('No explicit note → description is null, not raw transcript', () {
      final draft = VoiceExpenseParser.parse(
        transcript: 'I spent 50 SAR',
        categories: testCategories,
        paymentMethods: testPaymentMethods,
        now: referenceDate,
      );

      expect(draft.description, isNull);
      final args = draft.toCaptureLaunchArgs();
      expect(args.prefilledDescription, isNull);
    });

    test('autoFocusMerchant is false when merchant is detected', () {
      final draft = VoiceExpenseParser.parse(
        transcript: 'I spent 100 SAR at Al Baik',
        categories: testCategories,
        paymentMethods: testPaymentMethods,
        now: referenceDate,
      );

      final args = draft.toCaptureLaunchArgs();
      expect(args.autoFocusMerchant, isFalse);
    });

    test('autoFocusMerchant is true when merchant is missing', () {
      final draft = VoiceExpenseParser.parse(
        transcript: 'I spent 50 SAR on fuel',
        categories: testCategories,
        paymentMethods: testPaymentMethods,
        now: referenceDate,
      );

      expect(draft.merchant, isNull);
      final args = draft.toCaptureLaunchArgs();
      expect(args.autoFocusMerchant, isTrue);
    });

    group('Relative Date & Calendar Boundaries', () {
      test('Yesterday I spent 100 SAR at Al Baik using bank transfer', () {
        final draft = VoiceExpenseParser.parse(
          transcript: 'Yesterday I spent 100 SAR at Al Baik using bank transfer',
          categories: testCategories,
          paymentMethods: testPaymentMethods,
          now: referenceDate,
        );

        expect(draft.isYesterday, isTrue);
        expect(draft.date?.day, referenceDate.day - 1);
        expect(draft.amountMinor, 10000);
        expect(draft.merchant, 'Al Baik');
        expect(draft.categoryId, 'cat-restaurants');
        expect(draft.paymentMethodId, 'pm-bank-transfer');
      });

      test('I spent 100 SAR at Al Baik yesterday', () {
        final draft = VoiceExpenseParser.parse(
          transcript: 'I spent 100 SAR at Al Baik yesterday',
          categories: testCategories,
          paymentMethods: testPaymentMethods,
          now: referenceDate,
        );

        expect(draft.isYesterday, isTrue);
        expect(draft.date?.day, referenceDate.day - 1);
      });

      test('Yesterday morning I spent 50 SAR at Starbucks', () {
        final draft = VoiceExpenseParser.parse(
          transcript: 'Yesterday morning I spent 50 SAR at Starbucks',
          categories: testCategories,
          paymentMethods: testPaymentMethods,
          now: referenceDate,
        );

        expect(draft.isYesterday, isTrue);
        expect(draft.date?.day, referenceDate.day - 1);
        expect(draft.merchant, 'Starbucks');
      });

      test('I spent 50 SAR today', () {
        final draft = VoiceExpenseParser.parse(
          transcript: 'I spent 50 SAR today',
          categories: testCategories,
          paymentMethods: testPaymentMethods,
          now: referenceDate,
        );

        expect(draft.isYesterday, isFalse);
        expect(draft.date?.day, referenceDate.day);
      });

      test('No explicit date defaults to today', () {
        final draft = VoiceExpenseParser.parse(
          transcript: 'I spent 50 SAR at Starbucks',
          categories: testCategories,
          paymentMethods: testPaymentMethods,
          now: referenceDate,
        );

        expect(draft.isYesterday, isFalse);
        expect(draft.date?.day, referenceDate.day);
      });

      test('Midnight boundary test: 00:10 rolls back to previous calendar day', () {
        final midnightNow = DateTime(2026, 9, 21, 0, 10);
        final draft = VoiceExpenseParser.parse(
          transcript: 'Yesterday I spent 100 SAR at Al Baik',
          categories: testCategories,
          paymentMethods: testPaymentMethods,
          now: midnightNow,
        );

        expect(draft.isYesterday, isTrue);
        expect(draft.date?.year, 2026);
        expect(draft.date?.month, 9);
        expect(draft.date?.day, 20);
        expect(draft.date?.hour, 0);
        expect(draft.date?.minute, 10);
      });

      test('Beginning of month rollback (May 1 -> April 30)', () {
        final monthStart = DateTime(2026, 5, 1, 14, 0);
        final draft = VoiceExpenseParser.parse(
          transcript: 'yesterday I paid 80 SAR on fuel',
          categories: testCategories,
          paymentMethods: testPaymentMethods,
          now: monthStart,
        );

        expect(draft.isYesterday, isTrue);
        expect(draft.date?.year, 2026);
        expect(draft.date?.month, 4);
        expect(draft.date?.day, 30);
      });

      test('Beginning of year rollback (Jan 1 -> Dec 31)', () {
        final yearStart = DateTime(2026, 1, 1, 10, 0);
        final draft = VoiceExpenseParser.parse(
          transcript: 'yesterday I spent 100 SAR at Al Baik',
          categories: testCategories,
          paymentMethods: testPaymentMethods,
          now: yearStart,
        );

        expect(draft.isYesterday, isTrue);
        expect(draft.date?.year, 2025);
        expect(draft.date?.month, 12);
        expect(draft.date?.day, 31);
      });

      test('Leap-year transition rollback (Mar 1 2024 -> Feb 29 2024)', () {
        final leapMarchFirst = DateTime(2024, 3, 1, 8, 30);
        final draft = VoiceExpenseParser.parse(
          transcript: 'yesterday I spent 100 SAR at Al Baik',
          categories: testCategories,
          paymentMethods: testPaymentMethods,
          now: leapMarchFirst,
        );

        expect(draft.isYesterday, isTrue);
        expect(draft.date?.year, 2024);
        expect(draft.date?.month, 2);
        expect(draft.date?.day, 29);
      });
    });

    group('Amount Robustness Tests', () {
      test('I spent 100 Saudi riyal at Al Baik -> Amount = 100', () {
        final draft = VoiceExpenseParser.parse(
          transcript: 'I spent 100 Saudi riyal at Al Baik',
          categories: testCategories,
          paymentMethods: testPaymentMethods,
        );
        expect(draft.amountMinor, 10000);
        expect(draft.currency, 'SAR');
      });

      test('I spent one hundred Saudi riyals at Al Baik -> Amount = 100', () {
        final draft = VoiceExpenseParser.parse(
          transcript: 'I spent one hundred Saudi riyals at Al Baik',
          categories: testCategories,
          paymentMethods: testPaymentMethods,
        );
        expect(draft.amountMinor, 10000);
        expect(draft.currency, 'SAR');
      });

      test('I spent a hundred SAR at Al Baik -> Amount = 100', () {
        final draft = VoiceExpenseParser.parse(
          transcript: 'I spent a hundred SAR at Al Baik',
          categories: testCategories,
          paymentMethods: testPaymentMethods,
        );
        expect(draft.amountMinor, 10000);
        expect(draft.currency, 'SAR');
      });

      test('I paid two hundred and fifty SAR at Apple Store -> Amount = 250', () {
        final draft = VoiceExpenseParser.parse(
          transcript: 'I paid two hundred and fifty SAR at Apple Store',
          categories: testCategories,
          paymentMethods: testPaymentMethods,
        );
        expect(draft.amountMinor, 25000);
        expect(draft.currency, 'SAR');
      });

      test('I spent 100.50 SAR at Carrefour -> Amount = 100.50', () {
        final draft = VoiceExpenseParser.parse(
          transcript: 'I spent 100.50 SAR at Carrefour',
          categories: testCategories,
          paymentMethods: testPaymentMethods,
        );
        expect(draft.amountMinor, 10050);
        expect(draft.currency, 'SAR');
      });

      test('Attached currency code (100sar) parses correctly', () {
        final draft = VoiceExpenseParser.parse(
          transcript: 'I spent 100sar at Al Baik',
          categories: testCategories,
          paymentMethods: testPaymentMethods,
        );
        expect(draft.amountMinor, 10000);
      });

      test('Arabic-Indic numerals parse correctly', () {
        final draft = VoiceExpenseParser.parse(
          transcript: 'صرفت ١٠٠ ريال في البيك',
          categories: testCategories,
          paymentMethods: testPaymentMethods,
        );
        expect(draft.amountMinor, 10000);
      });
    });

    testWidgets('VoiceExpenseModal displays Yesterday when draft.isYesterday is true',
        (tester) async {
      final draft = VoiceExpenseDraft(
        rawTranscript: 'Yesterday I spent 100 SAR at Al Baik',
        amountMinor: 10000,
        currency: 'SAR',
        merchant: 'Al Baik',
        categoryId: 'cat-restaurants',
        categoryName: 'Restaurants & Cafes',
        paymentMethodId: 'pm-bank-transfer',
        paymentMethodName: 'Bank Transfer',
        date: DateTime(2026, 9, 20),
        isYesterday: true,
      );

      final container = ProviderContainer();
      addTearDown(container.dispose);

      final coordinator = container.read(voiceExpenseCoordinatorProvider.notifier);
      coordinator.state = VoiceExpenseState(
        status: VoiceExpenseStatus.result,
        draft: draft,
        rawTranscript: 'Yesterday I spent 100 SAR at Al Baik',
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: VoiceExpenseModal(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Yesterday'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    });

    group('Required Production Phrase Tests (Part A.5)', () {
      test('I spent 100 PKR at Emporium', () {
        final draft = VoiceExpenseParser.parse(
          transcript: 'I spent 100 PKR at Emporium',
          categories: testCategories,
          paymentMethods: testPaymentMethods,
          defaultCurrencyCode: 'PKR',
        );
        expect(draft.merchant, 'Emporium');
        expect(draft.amountMinor, 10000);
        expect(draft.currency, 'PKR');
      });

      test('I spent 100 SAR at Al Baik', () {
        final draft = VoiceExpenseParser.parse(
          transcript: 'I spent 100 SAR at Al Baik',
          categories: testCategories,
          paymentMethods: testPaymentMethods,
          defaultCurrencyCode: 'SAR',
        );
        expect(draft.merchant, 'Al Baik');
        expect(draft.amountMinor, 10000);
        expect(draft.currency, 'SAR');
      });

      test('I spent 20 dollars at Walmart', () {
        final draft = VoiceExpenseParser.parse(
          transcript: 'I spent 20 dollars at Walmart',
          categories: testCategories,
          paymentMethods: testPaymentMethods,
          defaultCurrencyCode: 'USD',
        );
        expect(draft.merchant, 'Walmart');
        expect(draft.amountMinor, 2000);
        expect(draft.currency, 'USD');
      });

      test('I paid 30 euros at Zara', () {
        final draft = VoiceExpenseParser.parse(
          transcript: 'I paid 30 euros at Zara',
          categories: testCategories,
          paymentMethods: testPaymentMethods,
          defaultCurrencyCode: 'EUR',
        );
        expect(draft.merchant, 'Zara');
        expect(draft.amountMinor, 3000);
        expect(draft.currency, 'EUR');
      });

      test('Spent 500 PKR at Foodpanda yesterday', () {
        final draft = VoiceExpenseParser.parse(
          transcript: 'Spent 500 PKR at Foodpanda yesterday',
          categories: testCategories,
          paymentMethods: testPaymentMethods,
          defaultCurrencyCode: 'PKR',
        );
        expect(draft.merchant, 'Foodpanda');
        expect(draft.amountMinor, 50000);
        expect(draft.currency, 'PKR');
        expect(draft.isYesterday, isTrue);
      });

      test('I bought coffee for 5 USD at Starbucks', () {
        final draft = VoiceExpenseParser.parse(
          transcript: 'I bought coffee for 5 USD at Starbucks',
          categories: testCategories,
          paymentMethods: testPaymentMethods,
          defaultCurrencyCode: 'USD',
        );
        expect(draft.merchant, 'Starbucks');
        expect(draft.amountMinor, 500);
        expect(draft.currency, 'USD');
        expect(draft.categoryId, 'cat-restaurants');
      });

      test('Preserves multi-word merchants without fake inference', () {
        final draft = VoiceExpenseParser.parse(
          transcript: 'I spent 150 AED at Mega Hypermarket',
          categories: testCategories,
          paymentMethods: testPaymentMethods,
          defaultCurrencyCode: 'AED',
        );
        expect(draft.merchant, 'Mega Hypermarket');
        expect(draft.amountMinor, 15000);
        expect(draft.currency, 'AED');
      });

      test('Generic nouns never infer fake merchants', () {
        final draft = VoiceExpenseParser.parse(
          transcript: 'I spent 50 SAR on taxi yesterday',
          categories: testCategories,
          paymentMethods: testPaymentMethods,
          defaultCurrencyCode: 'SAR',
        );
        expect(draft.merchant, isNull);
        expect(draft.amountMinor, 5000);
      });
    });
  });
}
