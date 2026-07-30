import 'package:dinarwise/features/expenses/data/expense_repository.dart';

class AnalyticsSummary {
  const AnalyticsSummary({
    required this.totalIncomeMinor,
    required this.totalExpenseMinor,
    required this.averageDailyExpenseMinor,
    required this.savingsRate,
    required this.currentWeekExpenseMinor,
    required this.previousWeekExpenseMinor,
    required this.currentMonthExpenseMinor,
    required this.previousMonthExpenseMinor,
    required this.highestMerchant,
    required this.highestCategoryId,
    required this.categoryExpenses,
    required this.dailyExpenses,
    required this.weeklyExpenses,
    required this.monthlyExpenses,
    required this.yearlyExpenses,
  });

  final int totalIncomeMinor;
  final int totalExpenseMinor;
  final int averageDailyExpenseMinor;
  final double savingsRate;
  final int currentWeekExpenseMinor;
  final int previousWeekExpenseMinor;
  final int currentMonthExpenseMinor;
  final int previousMonthExpenseMinor;
  final String? highestMerchant;
  final String? highestCategoryId;
  final Map<String, int> categoryExpenses;
  final Map<DateTime, int> dailyExpenses;
  final Map<DateTime, int> weeklyExpenses;
  final Map<DateTime, int> monthlyExpenses;
  final Map<DateTime, int> yearlyExpenses;
}

class AnalyticsCalculator {
  const AnalyticsCalculator();

  AnalyticsSummary calculate(
    Iterable<ExpenseRecord> records, {
    DateTime? from,
    DateTime? to,
    DateTime? now,
  }) {
    final today = _dateOnly(now ?? DateTime.now());
    final filtered = records.where((record) {
      final date = _dateOnly(record.transactedAt);
      return (from == null || !date.isBefore(_dateOnly(from))) &&
          (to == null || !date.isAfter(_dateOnly(to)));
    }).toList();
    final expenses =
        filtered.where((record) => record.type == 'expense').toList();
    final incomes = filtered.where((record) => record.type == 'income');
    final totalIncome =
        incomes.fold<int>(0, (sum, record) => sum + record.amountMinor);
    final totalExpense =
        expenses.fold<int>(0, (sum, record) => sum + record.amountMinor);

    final daily = <DateTime, int>{};
    final weekly = <DateTime, int>{};
    final monthly = <DateTime, int>{};
    final yearly = <DateTime, int>{};
    final categories = <String, int>{};
    final merchants = <String, int>{};
    for (final expense in expenses) {
      final day = _dateOnly(expense.transactedAt);
      final month = DateTime(day.year, day.month);
      final week = day.subtract(Duration(days: day.weekday - 1));
      final year = DateTime(day.year);
      daily[day] = (daily[day] ?? 0) + expense.amountMinor;
      weekly[week] = (weekly[week] ?? 0) + expense.amountMinor;
      monthly[month] = (monthly[month] ?? 0) + expense.amountMinor;
      yearly[year] = (yearly[year] ?? 0) + expense.amountMinor;
      categories[expense.categoryId] =
          (categories[expense.categoryId] ?? 0) + expense.amountMinor;
      final merchant = expense.merchant?.trim();
      if (merchant != null && merchant.isNotEmpty) {
        merchants[merchant] = (merchants[merchant] ?? 0) + expense.amountMinor;
      }
    }

    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    final previousWeekStart = weekStart.subtract(const Duration(days: 7));
    final monthStart = DateTime(today.year, today.month);
    final previousMonthStart = DateTime(today.year, today.month - 1);

    return AnalyticsSummary(
      totalIncomeMinor: totalIncome,
      totalExpenseMinor: totalExpense,
      averageDailyExpenseMinor:
          daily.isEmpty ? 0 : (totalExpense / daily.length).round(),
      savingsRate:
          totalIncome == 0 ? 0 : ((totalIncome - totalExpense) / totalIncome),
      currentWeekExpenseMinor: _sumBetween(
        expenses,
        weekStart,
        weekStart.add(const Duration(days: 6)),
      ),
      previousWeekExpenseMinor: _sumBetween(
        expenses,
        previousWeekStart,
        weekStart.subtract(const Duration(days: 1)),
      ),
      currentMonthExpenseMinor: _sumBetween(
        expenses,
        monthStart,
        DateTime(today.year, today.month + 1).subtract(const Duration(days: 1)),
      ),
      previousMonthExpenseMinor: _sumBetween(
        expenses,
        previousMonthStart,
        monthStart.subtract(const Duration(days: 1)),
      ),
      highestMerchant: _highestKey(merchants),
      highestCategoryId: _highestKey(categories),
      categoryExpenses: categories,
      dailyExpenses: daily,
      weeklyExpenses: weekly,
      monthlyExpenses: monthly,
      yearlyExpenses: yearly,
    );
  }

  int _sumBetween(
    Iterable<ExpenseRecord> expenses,
    DateTime from,
    DateTime to,
  ) {
    return expenses.where((record) {
      final date = _dateOnly(record.transactedAt);
      return !date.isBefore(from) && !date.isAfter(to);
    }).fold(0, (sum, record) => sum + record.amountMinor);
  }

  String? _highestKey(Map<String, int> values) {
    if (values.isEmpty) return null;
    return values.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);
}
