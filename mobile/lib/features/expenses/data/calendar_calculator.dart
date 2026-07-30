import 'package:dinarwise/features/expenses/data/expense_repository.dart';

class CalendarDaySummary {
  const CalendarDaySummary({
    required this.incomeMinor,
    required this.expenseMinor,
    required this.mostUsedCategoryId,
    required this.records,
  });

  final int incomeMinor;
  final int expenseMinor;
  final String? mostUsedCategoryId;
  final List<ExpenseRecord> records;

  int get netMinor => incomeMinor - expenseMinor;
}

Map<DateTime, CalendarDaySummary> calculateCalendarDays(
  Iterable<ExpenseRecord> records,
) {
  final grouped = <DateTime, List<ExpenseRecord>>{};
  for (final record in records) {
    final day = DateTime(
      record.transactedAt.year,
      record.transactedAt.month,
      record.transactedAt.day,
    );
    grouped.putIfAbsent(day, () => []).add(record);
  }
  return grouped.map((day, items) {
    final usage = <String, int>{};
    var income = 0;
    var expense = 0;
    for (final item in items) {
      if (item.type == 'income') {
        income += item.amountMinor;
      } else {
        expense += item.amountMinor;
        usage[item.categoryId] = (usage[item.categoryId] ?? 0) + 1;
      }
    }
    final mostUsed = usage.isEmpty
        ? null
        : usage.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
    return MapEntry(
      day,
      CalendarDaySummary(
        incomeMinor: income,
        expenseMinor: expense,
        mostUsedCategoryId: mostUsed,
        records: List.unmodifiable(items),
      ),
    );
  });
}
