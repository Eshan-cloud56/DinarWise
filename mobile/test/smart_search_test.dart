import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dinarwise/core/database/app_database.dart';
import 'package:dinarwise/features/categories/data/drift_category_repository.dart';
import 'package:dinarwise/features/expenses/data/drift_expense_repository.dart';
import 'package:dinarwise/features/smart_search/data/smart_search_client.dart';
import 'package:dinarwise/features/smart_search/data/smart_search_service.dart';
import 'package:dinarwise/features/smart_search/domain/smart_search_category_mapper.dart';
import 'package:dinarwise/features/smart_search/domain/smart_search_date_resolver.dart';
import 'package:dinarwise/features/smart_search/domain/smart_search_heuristic.dart';
import 'package:dinarwise/features/smart_search/models/smart_search_intent.dart';
import 'package:dio/dio.dart';

class _FakeSmartSearchClient extends SmartSearchClient {
  _FakeSmartSearchClient({
    this.shouldThrowNetworkError = false,
    this.shouldThrowTimeout = false,
  });

  bool shouldThrowNetworkError;
  bool shouldThrowTimeout;

  @override
  Future<SmartSearchIntent> parseQuery({
    required String query,
    required String locale,
    CancelToken? cancelToken,
  }) async {
    if (shouldThrowTimeout) {
      throw const SmartSearchTimeoutException();
    }
    if (shouldThrowNetworkError) {
      throw const SmartSearchNetworkException();
    }
    throw const SmartSearchParseException('No response mock');
  }
}

class _MockWorkerClient extends SmartSearchClient {
  _MockWorkerClient(this.mockData);

  final Map<String, dynamic> mockData;

  @override
  Future<SmartSearchIntent> parseQuery({
    required String query,
    required String locale,
    CancelToken? cancelToken,
  }) async {
    final intent = SmartSearchIntent.fromJson(mockData);
    if (!intent.isValid) {
      throw const SmartSearchParseException('Invalid or unsupported intent');
    }
    return intent;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Smart Search Heuristic (Performance & Privacy)', () {
    test('keeps simple local searches off the network', () {
      expect(isNaturalLanguageQuery('Al Baik'), isFalse);
      expect(isNaturalLanguageQuery('Starbucks'), isFalse);
      expect(isNaturalLanguageQuery('Fuel'), isFalse);
      expect(isNaturalLanguageQuery('Panda Supermarket'), isFalse);
      expect(isNaturalLanguageQuery('150'), isFalse);
      expect(isNaturalLanguageQuery(''), isFalse);
    });

    test('correctly identifies natural-language queries for AI parsing', () {
      expect(
        isNaturalLanguageQuery('How much did I spend on restaurants this month?'),
        isTrue,
      );
      expect(
        isNaturalLanguageQuery('Show my grocery expenses last month'),
        isTrue,
      );
      expect(
        isNaturalLanguageQuery('How much did I spend on transport this week?'),
        isTrue,
      );
      expect(
        isNaturalLanguageQuery('Show what I spent at Al Baik this month'),
        isTrue,
      );
      expect(
        isNaturalLanguageQuery('Show all my spending this month'),
        isTrue,
      );
      expect(
        isNaturalLanguageQuery('Subscriptions this year'),
        isTrue,
      );
      expect(
        isNaturalLanguageQuery('كم صرفت على المطاعم هذا الشهر؟'),
        isTrue,
      );
    });

    test('isCompleteNaturalLanguageQuery filters incomplete intermediate typing states', () {
      // Incomplete queries with hanging prepositions or prefixes
      expect(isCompleteNaturalLanguageQuery('how much did i spend on'), isFalse);
      expect(isCompleteNaturalLanguageQuery('how much did i spend'), isFalse);
      expect(isCompleteNaturalLanguageQuery('show my'), isFalse);
      expect(isCompleteNaturalLanguageQuery('show me'), isFalse);
      expect(isCompleteNaturalLanguageQuery('show what i spent at'), isFalse);
      expect(isCompleteNaturalLanguageQuery('spending on'), isFalse);
      expect(isCompleteNaturalLanguageQuery('spent at'), isFalse);
      expect(isCompleteNaturalLanguageQuery('كم صرفت على'), isFalse);
      expect(isCompleteNaturalLanguageQuery('كم صرفت'), isFalse);

      // Complete queries
      expect(
        isCompleteNaturalLanguageQuery('how much did i spend on restaurants this month'),
        isTrue,
      );
      expect(
        isCompleteNaturalLanguageQuery('show my grocery expenses last month'),
        isTrue,
      );
      expect(
        isCompleteNaturalLanguageQuery('restaurants this month'),
        isTrue,
      );
      expect(
        isCompleteNaturalLanguageQuery('كم صرفت على المطاعم هذا الشهر'),
        isTrue,
      );
    });
  });

  group('Smart Search End-to-End Local Execution & Aggregation', () {
    late AppDatabase database;
    late DriftCategoryRepository categoryRepo;
    late DriftExpenseRepository expenseRepo;
    late SmartSearchCategoryMapper categoryMapper;
    late SmartSearchDateResolver dateResolver;
    const profileId = 'test-profile-123';
    final fixedNow = DateTime(2026, 9, 17, 12, 0, 0);

    setUp(() async {
      database = AppDatabase(NativeDatabase.memory());
      categoryRepo = DriftCategoryRepository(database);
      expenseRepo = DriftExpenseRepository(database);
      categoryMapper = const SmartSearchCategoryMapper();
      dateResolver = const SmartSearchDateResolver();

      await categoryRepo.ensureSystemCategories(profileId);
      await expenseRepo.create(
        profileId: profileId,
        amountMinor: 10000000,
        merchant: 'Salary',
        description: 'Opening balance',
        categoryId: '$profileId:other',
        transactedAt: DateTime(2024, 1, 1),
        type: 'income',
      );
    });

    tearDown(() async {
      await database.close();
    });

    test('1. restaurants this month: queries local DB and calculates total', () async {
      final restaurantCatId = '$profileId:restaurants';
      final groceriesCatId = '$profileId:groceries';

      await expenseRepo.create(
        profileId: profileId,
        amountMinor: 2500,
        merchant: 'Al Tazaj',
        description: 'Dinner with friends',
        categoryId: restaurantCatId,
        transactedAt: DateTime(2026, 9, 5),
      );
      await expenseRepo.create(
        profileId: profileId,
        amountMinor: 1700,
        merchant: 'Barns Cafe',
        description: 'Coffee',
        categoryId: restaurantCatId,
        transactedAt: DateTime(2026, 9, 12),
      );
      await expenseRepo.create(
        profileId: profileId,
        amountMinor: 5000,
        merchant: 'Past Restaurant',
        description: 'Last month',
        categoryId: restaurantCatId,
        transactedAt: DateTime(2026, 8, 20),
      );
      await expenseRepo.create(
        profileId: profileId,
        amountMinor: 8000,
        merchant: 'Panda',
        description: 'Grocery',
        categoryId: groceriesCatId,
        transactedAt: DateTime(2026, 9, 8),
      );

      final testService = SmartSearchService(
        client: _MockWorkerClient({
          'intent': 'category_expenses',
          'category_groups': ['restaurants_cafes'],
          'merchant': null,
          'date_range': 'this_month',
          'month': null,
          'year': null,
          'start_date': null,
          'end_date': null,
          'sort': 'newest',
        }),
        categoryMapper: categoryMapper,
        dateResolver: dateResolver,
        expenseRepository: expenseRepo,
      );

      final result = await testService.executeSmartSearch(
        query: 'How much did I spend on restaurants this month?',
        locale: 'en',
        profileId: profileId,
        referenceTime: fixedNow,
      );

      expect(result.count, equals(2));
      expect(result.totalAmountMinor, equals(4200));
      expect(result.title, contains('Restaurants & Cafés — This Month'));
      expect(result.items.first.merchant, equals('Barns Cafe'));
    });

    test('2. groceries last month: resolves last month dates and queries local DB', () async {
      final groceriesCatId = '$profileId:groceries';

      await expenseRepo.create(
        profileId: profileId,
        amountMinor: 15000,
        merchant: 'Danube',
        description: 'Monthly supplies',
        categoryId: groceriesCatId,
        transactedAt: DateTime(2026, 8, 15),
      );
      await expenseRepo.create(
        profileId: profileId,
        amountMinor: 6000,
        merchant: 'Lulu',
        description: 'Snacks',
        categoryId: groceriesCatId,
        transactedAt: DateTime(2026, 9, 2),
      );

      final testService = SmartSearchService(
        client: _MockWorkerClient({
          'intent': 'category_expenses',
          'category_groups': ['groceries'],
          'merchant': null,
          'date_range': 'last_month',
          'month': null,
          'year': null,
          'start_date': null,
          'end_date': null,
          'sort': 'newest',
        }),
        categoryMapper: categoryMapper,
        dateResolver: dateResolver,
        expenseRepository: expenseRepo,
      );

      final result = await testService.executeSmartSearch(
        query: 'Show my grocery expenses last month',
        locale: 'en',
        profileId: profileId,
        referenceTime: fixedNow,
      );

      expect(result.count, equals(1));
      expect(result.totalAmountMinor, equals(15000));
      expect(result.items.first.merchant, equals('Danube'));
      expect(result.title, contains('Groceries — Last Month'));
    });

    test('3. transport this week: maps transportation and fuel canonical categories', () async {
      final transportCatId = '$profileId:transportation';
      final fuelCatId = '$profileId:fuel';

      await expenseRepo.create(
        profileId: profileId,
        amountMinor: 4000,
        merchant: 'Aramco Fuel',
        description: 'Gas tank refill',
        categoryId: fuelCatId,
        transactedAt: DateTime(2026, 9, 15),
      );
      await expenseRepo.create(
        profileId: profileId,
        amountMinor: 2500,
        merchant: 'Uber Ride',
        description: 'Airport trip',
        categoryId: transportCatId,
        transactedAt: DateTime(2026, 9, 16),
      );
      await expenseRepo.create(
        profileId: profileId,
        amountMinor: 5000,
        merchant: 'Old Fuel',
        description: 'Previous week',
        categoryId: fuelCatId,
        transactedAt: DateTime(2026, 9, 7),
      );

      final testService = SmartSearchService(
        client: _MockWorkerClient({
          'intent': 'category_expenses',
          'category_groups': ['transport'],
          'merchant': null,
          'date_range': 'this_week',
          'month': null,
          'year': null,
          'start_date': null,
          'end_date': null,
          'sort': 'newest',
        }),
        categoryMapper: categoryMapper,
        dateResolver: dateResolver,
        expenseRepository: expenseRepo,
      );

      final result = await testService.executeSmartSearch(
        query: 'How much did I spend on transport this week?',
        locale: 'en',
        profileId: profileId,
        referenceTime: fixedNow,
      );

      expect(result.count, equals(2));
      expect(result.totalAmountMinor, equals(6500));
      expect(result.title, contains('Transport — This Week'));
    });

    test('4. subscriptions this year: aggregates subscriptions across the full year', () async {
      final subCatId = '$profileId:subscriptions';

      await expenseRepo.create(
        profileId: profileId,
        amountMinor: 1200,
        merchant: 'Netflix',
        description: 'Monthly sub',
        categoryId: subCatId,
        transactedAt: DateTime(2026, 2, 1),
      );
      await expenseRepo.create(
        profileId: profileId,
        amountMinor: 2400,
        merchant: 'Gym Membership',
        description: 'Fitness',
        categoryId: subCatId,
        transactedAt: DateTime(2026, 6, 15),
      );
      await expenseRepo.create(
        profileId: profileId,
        amountMinor: 9900,
        merchant: 'Old Sub',
        description: '2025 sub',
        categoryId: subCatId,
        transactedAt: DateTime(2025, 11, 10),
      );

      final testService = SmartSearchService(
        client: _MockWorkerClient({
          'intent': 'category_expenses',
          'category_groups': ['subscriptions'],
          'merchant': null,
          'date_range': 'this_year',
          'month': null,
          'year': null,
          'start_date': null,
          'end_date': null,
          'sort': 'newest',
        }),
        categoryMapper: categoryMapper,
        dateResolver: dateResolver,
        expenseRepository: expenseRepo,
      );

      final result = await testService.executeSmartSearch(
        query: 'Subscriptions this year',
        locale: 'en',
        profileId: profileId,
        referenceTime: fixedNow,
      );

      expect(result.count, equals(2));
      expect(result.totalAmountMinor, equals(3600));
      expect(result.title, contains('Subscriptions — This Year'));
    });

    test('5. merchant search: filters by merchant name locally within date range', () async {
      final restCatId = '$profileId:restaurants';

      await expenseRepo.create(
        profileId: profileId,
        amountMinor: 3500,
        merchant: 'Al Baik',
        description: 'Lunch combo',
        categoryId: restCatId,
        transactedAt: DateTime(2026, 9, 3),
      );
      await expenseRepo.create(
        profileId: profileId,
        amountMinor: 4500,
        merchant: 'Al Baik Restaurant',
        description: 'Family meal',
        categoryId: restCatId,
        transactedAt: DateTime(2026, 9, 10),
      );
      await expenseRepo.create(
        profileId: profileId,
        amountMinor: 5000,
        merchant: 'McDonalds',
        description: 'Burgers',
        categoryId: restCatId,
        transactedAt: DateTime(2026, 9, 8),
      );
      await expenseRepo.create(
        profileId: profileId,
        amountMinor: 2000,
        merchant: 'Al Baik',
        description: 'Past month',
        categoryId: restCatId,
        transactedAt: DateTime(2026, 8, 1),
      );

      final testService = SmartSearchService(
        client: _MockWorkerClient({
          'intent': 'merchant_expenses',
          'category_groups': [],
          'merchant': 'Al Baik',
          'date_range': 'this_month',
          'month': null,
          'year': null,
          'start_date': null,
          'end_date': null,
          'sort': 'newest',
        }),
        categoryMapper: categoryMapper,
        dateResolver: dateResolver,
        expenseRepository: expenseRepo,
      );

      final result = await testService.executeSmartSearch(
        query: 'Show what I spent at Al Baik this month',
        locale: 'en',
        profileId: profileId,
        referenceTime: fixedNow,
      );

      expect(result.count, equals(2));
      expect(result.totalAmountMinor, equals(8000));
      expect(result.items.every((i) => i.merchant!.contains('Al Baik')), isTrue);
      expect(result.title, contains('Al Baik — This Month'));
    });

    test('6. all expenses this month: returns all expenses in date range', () async {
      final restCatId = '$profileId:restaurants';
      final grocCatId = '$profileId:groceries';

      await expenseRepo.create(
        profileId: profileId,
        amountMinor: 1000,
        merchant: 'M1',
        description: '',
        categoryId: restCatId,
        transactedAt: DateTime(2026, 9, 2),
      );
      await expenseRepo.create(
        profileId: profileId,
        amountMinor: 2000,
        merchant: 'M2',
        description: '',
        categoryId: grocCatId,
        transactedAt: DateTime(2026, 9, 5),
      );
      await expenseRepo.create(
        profileId: profileId,
        amountMinor: 3000,
        merchant: 'M3',
        description: '',
        categoryId: restCatId,
        transactedAt: DateTime(2026, 9, 14),
      );
      await expenseRepo.create(
        profileId: profileId,
        amountMinor: 50000,
        merchant: 'Salary',
        description: '',
        categoryId: restCatId,
        transactedAt: DateTime(2026, 9, 1),
        type: 'income',
      );

      final testService = SmartSearchService(
        client: _MockWorkerClient({
          'intent': 'all_expenses',
          'category_groups': [],
          'merchant': null,
          'date_range': 'this_month',
          'month': null,
          'year': null,
          'start_date': null,
          'end_date': null,
          'sort': 'newest',
        }),
        categoryMapper: categoryMapper,
        dateResolver: dateResolver,
        expenseRepository: expenseRepo,
      );

      final result = await testService.executeSmartSearch(
        query: 'Show all my spending this month',
        locale: 'en',
        profileId: profileId,
        referenceTime: fixedNow,
      );

      expect(result.count, equals(3));
      expect(result.totalAmountMinor, equals(6000));
      expect(result.title, contains('All Expenses — This Month'));
    });

    test('7. no internet fallback: throws SmartSearchNetworkException without crashing', () async {
      final errorClient = _FakeSmartSearchClient(shouldThrowNetworkError: true);
      final testService = SmartSearchService(
        client: errorClient,
        categoryMapper: categoryMapper,
        dateResolver: dateResolver,
        expenseRepository: expenseRepo,
      );

      expect(
        () => testService.executeSmartSearch(
          query: 'How much did I spend on restaurants this month?',
          locale: 'en',
          profileId: profileId,
        ),
        throwsA(isA<SmartSearchNetworkException>()),
      );
    });

    test('7b. endpoint timeout: throws SmartSearchTimeoutException without crashing', () async {
      final timeoutClient = _FakeSmartSearchClient(shouldThrowTimeout: true);
      final testService = SmartSearchService(
        client: timeoutClient,
        categoryMapper: categoryMapper,
        dateResolver: dateResolver,
        expenseRepository: expenseRepo,
      );

      expect(
        () => testService.executeSmartSearch(
          query: 'How much did I spend on restaurants this month?',
          locale: 'en',
          profileId: profileId,
        ),
        throwsA(isA<SmartSearchTimeoutException>()),
      );
    });

    test('8. malformed API response: throws SmartSearchParseException without crashing', () async {
      final malformedClient = _MockWorkerClient({
        'status': 'success',
        'random_key': 12345,
      });
      final testService = SmartSearchService(
        client: malformedClient,
        categoryMapper: categoryMapper,
        dateResolver: dateResolver,
        expenseRepository: expenseRepo,
      );

      expect(
        () => testService.executeSmartSearch(
          query: 'How much did I spend on restaurants this month?',
          locale: 'en',
          profileId: profileId,
        ),
        throwsA(isA<SmartSearchParseException>()),
      );
    });
  });
}
