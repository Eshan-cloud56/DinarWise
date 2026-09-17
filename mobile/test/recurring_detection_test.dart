import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dinarwise/core/preferences/app_preferences.dart';
import 'package:dinarwise/features/expenses/data/expense_repository.dart';
import 'package:dinarwise/features/planning/data/commitments_repository.dart';
import 'package:dinarwise/features/planning/data/recurring_detection_service.dart';

class FakeExpenseRepository implements ExpenseRepository {
  FakeExpenseRepository(this.expenses);
  final List<ExpenseRecord> expenses;

  @override
  Stream<List<ExpenseRecord>> watchAll(String profileId) =>
      Stream.value(expenses);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeCommitmentsRepository implements CommitmentsRepository {
  FakeCommitmentsRepository([this.activeRules = const []]);
  final List<RecurringDetails> activeRules;

  @override
  Future<List<RecurringDetails>> loadRecurring(String profileId) async =>
      activeRules;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppPreferences preferences;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final sharedPrefs = await SharedPreferences.getInstance();
    preferences = AppPreferences(sharedPrefs);
  });

  group('RecurringDetectionService', () {
    test('detects monthly Netflix subscription from 3 repeated transactions',
        () async {
      final now = DateTime(2026, 9, 15);
      final expenses = [
        ExpenseRecord(
          id: '1',
          profileId: 'p1',
          type: 'expense',
          amountMinor: 6500, // 65.00 SAR
          currency: 'SAR',
          merchant: 'Netflix',
          description: '',
          categoryId: 'entertainment',
          transactedAt: now.subtract(const Duration(days: 60)),
        ),
        ExpenseRecord(
          id: '2',
          profileId: 'p1',
          type: 'expense',
          amountMinor: 6500,
          currency: 'SAR',
          merchant: 'Netflix',
          description: '',
          categoryId: 'entertainment',
          transactedAt: now.subtract(const Duration(days: 30)),
        ),
        ExpenseRecord(
          id: '3',
          profileId: 'p1',
          type: 'expense',
          amountMinor: 6500,
          currency: 'SAR',
          merchant: 'Netflix',
          description: '',
          categoryId: 'entertainment',
          transactedAt: now,
        ),
      ];

      final service = RecurringDetectionService(
        expenseRepository: FakeExpenseRepository(expenses),
        commitmentsRepository: FakeCommitmentsRepository(),
        preferences: preferences,
      );

      final suggestions = await service.detectRecurring('p1');
      expect(suggestions.length, equals(1));
      final s = suggestions.first;
      expect(s.merchant, equals('Netflix'));
      expect(s.averageAmountMinor, equals(6500));
      expect(s.recurrence, equals('monthly'));
      expect(s.occurrenceCount, equals(3));
      expect(s.confidence, greaterThanOrEqualTo(0.8));
    });

    test('ignores transactions with irregular intervals', () async {
      final now = DateTime(2026, 9, 15);
      final expenses = [
        ExpenseRecord(
          id: '1',
          profileId: 'p1',
          type: 'expense',
          amountMinor: 10000,
          currency: 'SAR',
          merchant: 'Random Store',
          description: '',
          categoryId: 'shopping',
          transactedAt: now.subtract(const Duration(days: 5)),
        ),
        ExpenseRecord(
          id: '2',
          profileId: 'p1',
          type: 'expense',
          amountMinor: 10000,
          currency: 'SAR',
          merchant: 'Random Store',
          description: '',
          categoryId: 'shopping',
          transactedAt: now,
        ),
      ];

      final service = RecurringDetectionService(
        expenseRepository: FakeExpenseRepository(expenses),
        commitmentsRepository: FakeCommitmentsRepository(),
        preferences: preferences,
      );

      final suggestions = await service.detectRecurring('p1');
      expect(suggestions, isEmpty);
    });

    test('ignores merchant if already tracked in recurring payments', () async {
      final now = DateTime(2026, 9, 15);
      final expenses = [
        ExpenseRecord(
          id: '1',
          profileId: 'p1',
          type: 'expense',
          amountMinor: 4500,
          currency: 'SAR',
          merchant: 'Spotify',
          description: '',
          categoryId: 'entertainment',
          transactedAt: now.subtract(const Duration(days: 30)),
        ),
        ExpenseRecord(
          id: '2',
          profileId: 'p1',
          type: 'expense',
          amountMinor: 4500,
          currency: 'SAR',
          merchant: 'Spotify',
          description: '',
          categoryId: 'entertainment',
          transactedAt: now,
        ),
      ];

      final existingRule = RecurringDetails(
        id: 'rec_1',
        name: 'Spotify',
        amountMinor: 4500,
        recurrence: 'monthly',
        intervalCount: 1,
        categoryId: 'entertainment',
        startDate: now.subtract(const Duration(days: 30)),
        endDate: null,
        maxOccurrences: null,
        nextPaymentDate: now.add(const Duration(days: 30)),
        isSubscription: true,
        status: 'active',
        occurrences: const [],
      );

      final service = RecurringDetectionService(
        expenseRepository: FakeExpenseRepository(expenses),
        commitmentsRepository: FakeCommitmentsRepository([existingRule]),
        preferences: preferences,
      );

      final suggestions = await service.detectRecurring('p1');
      expect(suggestions, isEmpty);
    });

    test('ignores merchant if user dismissed the suggestion', () async {
      await preferences.dismissRecurringMerchant('gym');

      final now = DateTime(2026, 9, 15);
      final expenses = [
        ExpenseRecord(
          id: '1',
          profileId: 'p1',
          type: 'expense',
          amountMinor: 30000,
          currency: 'SAR',
          merchant: 'Gym',
          description: '',
          categoryId: 'health',
          transactedAt: now.subtract(const Duration(days: 30)),
        ),
        ExpenseRecord(
          id: '2',
          profileId: 'p1',
          type: 'expense',
          amountMinor: 30000,
          currency: 'SAR',
          merchant: 'Gym',
          description: '',
          categoryId: 'health',
          transactedAt: now,
        ),
      ];

      final service = RecurringDetectionService(
        expenseRepository: FakeExpenseRepository(expenses),
        commitmentsRepository: FakeCommitmentsRepository(),
        preferences: preferences,
      );

      final suggestions = await service.detectRecurring('p1');
      expect(suggestions, isEmpty);
    });
  });
}
