import 'dart:convert';
import 'package:dinarwise/core/currency/app_currency.dart';
import 'package:dinarwise/core/database/app_database.dart';
import 'package:dinarwise/features/expenses/data/drift_expense_repository.dart';
import 'package:dinarwise/features/expenses/data/history_filter.dart';
import 'package:dinarwise/features/voice_expense/domain/voice_expense_parser.dart';
import 'package:dinarwise/features/categories/data/category_repository.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Part D — Adversarial Input & Injection Security Tests', () {
    late AppDatabase database;
    late DriftExpenseRepository repository;
    const testProfileId = 'sec-audit-profile';

    setUp(() async {
      database = AppDatabase(NativeDatabase.memory());
      repository = DriftExpenseRepository(database);
      await database.into(database.financialPreferences).insert(
            FinancialPreferencesCompanion.insert(
              profileId: testProfileId,
              currency: const Value('SAR'),
            ),
          );
      await database.into(database.expenseCategories).insert(
            ExpenseCategoriesCompanion.insert(
              id: 'cat-test',
              profileId: testProfileId,
              name: 'General',
              systemCode: const Value('general'),
              isSystem: const Value(true),
            ),
          );
      // Seed income so proposed balance checks succeed
      await repository.create(
        profileId: testProfileId,
        amountMinor: 100000000000000, // 1 trillion SAR
        currency: 'SAR',
        merchant: 'Initial Income',
        categoryId: 'cat-test',
        type: 'income',
        transactedAt: DateTime.now().subtract(const Duration(days: 1)),
        description: 'Income seed',
      );
    });

    tearDown(() async {
      await database.close();
    });

    test('SQL Injection in merchant field does not leak or alter data', () async {
      const sqlInjectionMerchant = "' OR 1=1 --; DROP TABLE financial_transactions; --";
      final id = await repository.create(
        profileId: testProfileId,
        amountMinor: 5000,
        currency: 'SAR',
        merchant: sqlInjectionMerchant,
        categoryId: 'cat-test',
        transactedAt: DateTime.now(),
        description: "SQL injection test: ' UNION SELECT * FROM users --",
      );
      expect(id, isNotEmpty);

      // Verify transaction table was NOT dropped and both seeded income + created expense exist
      final all = await repository.search(
        profileId: testProfileId,
        filter: const TransactionHistoryFilter(),
      );
      expect(all.length, 2);
      final created = all.firstWhere((e) => e.id == id);
      expect(created.merchant, sqlInjectionMerchant);

      // Search using SQL injection payload
      final searchResult = await repository.search(
        profileId: testProfileId,
        filter: const TransactionHistoryFilter(search: "' OR 1=1 --"),
      );
      expect(searchResult.length, 1);
      expect(searchResult.first.id, id);

      // Search using a payload that should not match anything
      final falseSearch = await repository.search(
        profileId: testProfileId,
        filter: const TransactionHistoryFilter(search: "' OR 'a'='b"),
      );
      expect(falseSearch, isEmpty);
    });

    test('XSS and script injection payload stored safely without execution', () async {
      const xssMerchant = '<script>alert("XSS")</script><img src=x onerror=alert(1)>';
      const xssDescription = '<svg onload=alert(document.cookie)>';
      await repository.create(
        profileId: testProfileId,
        amountMinor: 7500,
        currency: 'SAR',
        merchant: xssMerchant,
        categoryId: 'cat-test',
        transactedAt: DateTime.now(),
        description: xssDescription,
      );

      final all = await repository.search(
        profileId: testProfileId,
        filter: const TransactionHistoryFilter(),
      );
      expect(all.first.merchant, xssMerchant);
      expect(all.first.description, xssDescription);
    });

    test('Very long notes (10,000+ chars) persist without buffer overflow or truncation', () async {
      final hugeDescription = 'A' * 15000;
      await repository.create(
        profileId: testProfileId,
        amountMinor: 1000,
        currency: 'SAR',
        merchant: 'Long Notes Store',
        categoryId: 'cat-test',
        transactedAt: DateTime.now(),
        description: hugeDescription,
      );

      final all = await repository.search(
        profileId: testProfileId,
        filter: const TransactionHistoryFilter(),
      );
      expect(all.first.description?.length, 15000);
      expect(all.first.description, hugeDescription);
    });

    test('Malformed and exotic Unicode sequences handled cleanly', () async {
      const complexUnicode = '🛒 Emporium \u202E\u200B\uFEFF\u0000\uD83D\uDCA9 \u0627\u0644\u0628\u064A\u0643';
      await repository.create(
        profileId: testProfileId,
        amountMinor: 2500,
        currency: 'SAR',
        merchant: complexUnicode,
        categoryId: 'cat-test',
        transactedAt: DateTime.now(),
        description: 'Null byte and RTL: \u0000 \u200E\u200F',
      );

      final all = await repository.search(
        profileId: testProfileId,
        filter: const TransactionHistoryFilter(),
      );
      expect(all.first.merchant, complexUnicode);
    });

    test('Huge numerical monetary values within 64-bit bounds are preserved', () async {
      // 100,000,000,000.00 SAR = 10,000,000,000,000 minor units
      const hugeAmountMinor = 10000000000000;
      await repository.create(
        profileId: testProfileId,
        amountMinor: hugeAmountMinor,
        currency: 'SAR',
        merchant: 'Enterprise Acquisition',
        categoryId: 'cat-test',
        transactedAt: DateTime.now(),
        description: 'Large ledger amount',
      );

      final all = await repository.search(
        profileId: testProfileId,
        filter: const TransactionHistoryFilter(),
      );
      expect(all.first.amountMinor, hugeAmountMinor);
    });

    test('Malformed JSON parser resilience', () {
      const malformedJson = '{"merchant": "Test", "amountMinor": 100, unquoted_key: 1';
      expect(() => jsonDecode(malformedJson), throwsA(isA<FormatException>()));
    });

    test('Unsupported or malformed currency codes fallback safely', () {
      expect(AppCurrency.tryFromCode('INVALID_CODE'), isNull);
      expect(AppCurrency.tryFromCode(''), isNull);
      expect(AppCurrency.tryFromCode('XYZ'), isNull);

      final resolved = AppCurrency.fromCode('UNSUPPORTED_123');
      expect(resolved.code, 'SAR'); // Default fallback
    });

    test('Legitimate merchants with apostrophes and ampersands preserved intact', () async {
      const legit1 = "McDonald's";
      const legit2 = 'Barnes & Noble';
      const legit3 = 'H&M';

      await repository.create(
        profileId: testProfileId,
        amountMinor: 3500,
        currency: 'SAR',
        merchant: legit1,
        categoryId: 'cat-test',
        transactedAt: DateTime.now(),
        description: '',
      );
      await repository.create(
        profileId: testProfileId,
        amountMinor: 12000,
        currency: 'SAR',
        merchant: legit2,
        categoryId: 'cat-test',
        transactedAt: DateTime.now(),
        description: '',
      );
      await repository.create(
        profileId: testProfileId,
        amountMinor: 4500,
        currency: 'SAR',
        merchant: legit3,
        categoryId: 'cat-test',
        transactedAt: DateTime.now(),
        description: '',
      );

      final all = await repository.search(
        profileId: testProfileId,
        filter: const TransactionHistoryFilter(),
      );
      final merchants = all.map((e) => e.merchant).toList();
      expect(merchants, contains("McDonald's"));
      expect(merchants, contains('Barnes & Noble'));
      expect(merchants, contains('H&M'));
    });

    test('Voice Expense Parser with adversarial input does not crash or execute', () {
      const testCategories = [
        CategoryRecord(
          id: 'cat-test',
          name: 'General',
          systemCode: 'general',
          isSystem: true,
        ),
      ];

      final draft = VoiceExpenseParser.parse(
        transcript: "I spent 100 SAR at <script>alert(1)</script> ' OR 1=1 --",
        categories: testCategories,
        defaultCurrencyCode: 'SAR',
      );

      expect(draft.amountMinor, 10000);
      expect(draft.currency, 'SAR');
      // Script and SQL injection characters are safely rejected by deterministic regex, leaving merchant null
      expect(draft.merchant, isNull);
    });
  });
}
