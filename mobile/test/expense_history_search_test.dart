import 'package:dinarwise/core/database/app_database.dart';
import 'package:dinarwise/core/database/database_provider.dart';
import 'package:dinarwise/core/preferences/app_preferences.dart';
import 'package:dinarwise/features/categories/category_localization.dart';
import 'package:dinarwise/features/categories/data/category_repository.dart';
import 'package:dinarwise/features/expenses/data/expense_repository.dart';
import 'package:dinarwise/features/expenses/history_screen.dart';
import 'package:dinarwise/features/smart_search/data/smart_search_service.dart';
import 'package:dinarwise/features/smart_search/models/smart_search_intent.dart';
import 'package:dinarwise/l10n/generated/app_localizations.dart';
import 'package:dinarwise/l10n/generated/app_localizations_en.dart';
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  drift.driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  group('Category Keyword Resolution', () {
    final l10n = AppLocalizationsEn();
    final List<CategoryRecord> categories = [
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
        id: 'cat-transport',
        name: 'Transportation',
        systemCode: 'transportation',
        isSystem: true,
      ),
      const CategoryRecord(
        id: 'cat-fuel',
        name: 'Fuel',
        systemCode: 'fuel',
        isSystem: true,
      ),
      const CategoryRecord(
        id: 'cat-subscriptions',
        name: 'Subscriptions',
        systemCode: 'subscriptions',
        isSystem: true,
      ),
    ];

    test('Subscriptions query resolves subscriptions category', () {
      final ids = resolveCategorySearchIds(
        query: 'Subscriptions',
        categories: categories,
        l10n: l10n,
      );
      expect(ids, contains('cat-subscriptions'));
    });

    test('Restaurants query resolves restaurants category', () {
      final ids = resolveCategorySearchIds(
        query: 'Restaurants',
        categories: categories,
        l10n: l10n,
      );
      expect(ids, contains('cat-restaurants'));
    });

    test('Groceries query resolves groceries category', () {
      final ids = resolveCategorySearchIds(
        query: 'Groceries',
        categories: categories,
        l10n: l10n,
      );
      expect(ids, contains('cat-groceries'));
    });

    test('Transport alias query resolves transportation category', () {
      final ids = resolveCategorySearchIds(
        query: 'Transport',
        categories: categories,
        l10n: l10n,
      );
      expect(ids, contains('cat-transport'));
    });

    test('Fuel query resolves fuel category', () {
      final ids = resolveCategorySearchIds(
        query: 'Fuel',
        categories: categories,
        l10n: l10n,
      );
      expect(ids, contains('cat-fuel'));
    });

    test('Merchant keyword Cravy does not resolve any category', () {
      final ids = resolveCategorySearchIds(
        query: 'Cravy',
        categories: categories,
        l10n: l10n,
      );
      expect(ids, isEmpty);
    });
  });

  group('Expense History Screen Routing and Search', () {
    Future<({AppDatabase db, SharedPreferences prefs})> setupTestEnv(
        WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 1500);
      tester.view.devicePixelRatio = 1;

      SharedPreferences.setMockInitialValues({
        'selected_language': 'en',
        'selected_currency': 'SAR',
        'local_profile_id': 'test-profile',
        'onboarding_completed': true,
        'privacy_policy_accepted': true,
      });
      final prefs = await SharedPreferences.getInstance();
      final db = AppDatabase(NativeDatabase.memory());

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      // Seed categories
      await db.into(db.expenseCategories).insert(
            ExpenseCategoriesCompanion.insert(
              id: 'cat-restaurants',
              profileId: 'test-profile',
              name: 'Restaurants & Cafes',
              systemCode: const drift.Value('restaurants'),
              isSystem: const drift.Value(true),
            ),
          );
      await db.into(db.expenseCategories).insert(
            ExpenseCategoriesCompanion.insert(
              id: 'cat-groceries',
              profileId: 'test-profile',
              name: 'Groceries',
              systemCode: const drift.Value('groceries'),
              isSystem: const drift.Value(true),
            ),
          );

      // Seed expenses: Cravy (Restaurants), Al Baik (Restaurants), Panda (Groceries)
      await db.into(db.financialTransactions).insert(
            FinancialTransactionsCompanion.insert(
              id: 'tx-1',
              profileId: 'test-profile',
              type: const drift.Value('expense'),
              amountMinor: 5500,
              currency: const drift.Value('SAR'),
              merchant: const drift.Value('Cravy'),
              description: const drift.Value('Dinner'),
              categoryId: 'cat-restaurants',
              transactedAt: DateTime.now(),
            ),
          );
      await db.into(db.financialTransactions).insert(
            FinancialTransactionsCompanion.insert(
              id: 'tx-2',
              profileId: 'test-profile',
              type: const drift.Value('expense'),
              amountMinor: 3200,
              currency: const drift.Value('SAR'),
              merchant: const drift.Value('Al Baik'),
              description: const drift.Value('Lunch'),
              categoryId: 'cat-restaurants',
              transactedAt: DateTime.now(),
            ),
          );
      await db.into(db.financialTransactions).insert(
            FinancialTransactionsCompanion.insert(
              id: 'tx-3',
              profileId: 'test-profile',
              type: const drift.Value('expense'),
              amountMinor: 12000,
              currency: const drift.Value('SAR'),
              merchant: const drift.Value('Panda Supermarket'),
              description: const drift.Value('Groceries'),
              categoryId: 'cat-groceries',
              transactedAt: DateTime.now(),
            ),
          );

      return (db: db, prefs: prefs);
    }

    testWidgets('HistoryScreen loads with initialSearch Cravy and filters immediately',
        (tester) async {
      final env = await setupTestEnv(tester);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(env.prefs),
            databaseProvider.overrideWithValue(env.db),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: HistoryScreen(initialSearch: 'Cravy'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Cravy should be displayed in search bar and in expense list
      expect(find.widgetWithText(TextField, 'Cravy'), findsOneWidget);
      expect(find.text('Cravy'), findsNWidgets(2));
      // Al Baik and Panda should NOT be displayed
      expect(find.text('Al Baik'), findsNothing);
      expect(find.text('Panda Supermarket'), findsNothing);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      await tester.runAsync(env.db.close);
    });

    testWidgets('HistoryScreen loads with category Restaurants and lists restaurant expenses',
        (tester) async {
      final env = await setupTestEnv(tester);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(env.prefs),
            databaseProvider.overrideWithValue(env.db),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: HistoryScreen(initialSearch: 'Restaurants'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Both Cravy and Al Baik should be displayed
      expect(find.text('Cravy'), findsOneWidget);
      expect(find.text('Al Baik'), findsOneWidget);
      // Panda (Groceries) should NOT be displayed
      expect(find.text('Panda Supermarket'), findsNothing);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      await tester.runAsync(env.db.close);
    });

    testWidgets('HistoryScreen loads without query and shows all expenses',
        (tester) async {
      final env = await setupTestEnv(tester);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(env.prefs),
            databaseProvider.overrideWithValue(env.db),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: HistoryScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // All 3 expenses should be in complete history
      expect(find.text('Cravy'), findsOneWidget);
      expect(find.text('Al Baik'), findsOneWidget);
      expect(find.text('Panda Supermarket'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      await tester.runAsync(env.db.close);
    });

    testWidgets('HistoryScreen displays SmartSearchSummaryCard when result passed',
        (tester) async {
      final env = await setupTestEnv(tester);

      final dummyRecord = ExpenseRecord(
        id: 'tx-1',
        profileId: 'test-profile',
        type: 'expense',
        amountMinor: 5500,
        currency: 'SAR',
        categoryId: 'cat-restaurants',
        merchant: 'Cravy',
        description: 'Dinner',
        transactedAt: DateTime.now(),
      );

      const intent = SmartSearchIntent(
        intent: SmartSearchIntentType.categoryExpenses,
        categoryGroups: ['restaurants_cafes'],
        dateRange: 'this_month',
      );

      final smartResult = SmartSearchResult(
        title: 'Restaurants & Cafés — This Month',
        totalAmountMinor: 5500,
        count: 1,
        items: [dummyRecord],
        intent: intent,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(env.prefs),
            databaseProvider.overrideWithValue(env.db),
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: HistoryScreen(
              initialSearch: 'restaurants this month',
              initialSmartSearchResult: smartResult,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Smart search summary card should be visible
      expect(find.text('Restaurants & Cafés — This Month'), findsOneWidget);
      expect(find.text('1 expense'), findsOneWidget);
      expect(find.text('Cravy'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      await tester.runAsync(env.db.close);
    });
  });
}
