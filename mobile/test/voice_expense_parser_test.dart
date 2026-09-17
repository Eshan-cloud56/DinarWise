import 'package:dinarwise/features/categories/data/category_repository.dart';
import 'package:dinarwise/features/payment_methods/payment_method_repository.dart';
import 'package:dinarwise/features/voice_expense/domain/voice_expense_parser.dart';
import 'package:flutter_test/flutter_test.dart';

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
      expect(draft.merchant, 'AlBaik');
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
      expect(draft.description, 'Shoes');
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
      expect(draft.merchant, 'Cornerboutique');
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
      expect(launchArgs.prefilledMerchant, 'AlBaik');
      expect(launchArgs.prefilledAmountMinor, 10000);
      expect(launchArgs.prefilledCategoryId, 'cat-restaurants');
      expect(launchArgs.prefilledPaymentMethodId, 'pm-cash');
      expect(launchArgs.prefilledCurrency, 'SAR');
    });
  });
}
