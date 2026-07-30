import 'package:dinarwise/features/analytics/analytics_calculator.dart';
import 'package:dinarwise/features/expenses/data/calendar_calculator.dart';
import 'package:dinarwise/features/expenses/data/expense_repository.dart';
import 'package:flutter_test/flutter_test.dart';

ExpenseRecord record({
  required String id,
  required String type,
  required int amount,
  required DateTime date,
  String category = 'groceries',
  String merchant = 'Merchant',
}) =>
    ExpenseRecord(
      id: id,
      profileId: 'profile',
      type: type,
      amountMinor: amount,
      currency: 'SAR',
      merchant: merchant,
      description: null,
      categoryId: category,
      transactedAt: date,
    );

void main() {
  test('calendar groups daily income, expense, net, and most-used category',
      () {
    final day = DateTime(2026, 7, 8);
    final result = calculateCalendarDays([
      record(id: '1', type: 'income', amount: 10000, date: day),
      record(id: '2', type: 'expense', amount: 2000, date: day),
      record(id: '3', type: 'expense', amount: 500, date: day),
      record(
        id: '4',
        type: 'expense',
        amount: 1000,
        date: day,
        category: 'fuel',
      ),
    ])[day]!;

    expect(result.incomeMinor, 10000);
    expect(result.expenseMinor, 3500);
    expect(result.netMinor, 6500);
    expect(result.mostUsedCategoryId, 'groceries');
  });

  test('analytics calculations are deterministic from local records', () {
    final summary = const AnalyticsCalculator().calculate(
      [
        record(
          id: 'income',
          type: 'income',
          amount: 100000,
          date: DateTime(2026, 7, 1),
        ),
        record(
          id: 'food-1',
          type: 'expense',
          amount: 20000,
          date: DateTime(2026, 7, 6),
          merchant: 'Market',
        ),
        record(
          id: 'food-2',
          type: 'expense',
          amount: 10000,
          date: DateTime(2026, 7, 7),
          merchant: 'Market',
        ),
        record(
          id: 'fuel',
          type: 'expense',
          amount: 5000,
          date: DateTime(2026, 6, 25),
          category: 'fuel',
        ),
      ],
      now: DateTime(2026, 7, 8),
    );

    expect(summary.totalIncomeMinor, 100000);
    expect(summary.totalExpenseMinor, 35000);
    expect(summary.averageDailyExpenseMinor, 11667);
    expect(summary.savingsRate, closeTo(.65, .0001));
    expect(summary.currentWeekExpenseMinor, 30000);
    expect(summary.previousMonthExpenseMinor, 5000);
    expect(summary.highestMerchant, 'Market');
    expect(summary.highestCategoryId, 'groceries');
  });
}
