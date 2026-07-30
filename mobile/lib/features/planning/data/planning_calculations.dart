class BudgetProgress {
  const BudgetProgress({
    required this.limitMinor,
    required this.spentMinor,
    required this.carriedMinor,
  });

  final int limitMinor;
  final int spentMinor;
  final int carriedMinor;

  int get effectiveLimitMinor => limitMinor + carriedMinor;
  int get remainingMinor => effectiveLimitMinor - spentMinor;
  double get percentageUsed =>
      effectiveLimitMinor <= 0 ? 0 : spentMinor / effectiveLimitMinor;
  bool get isOverspent => remainingMinor < 0;
  int get warningLevel => percentageUsed >= 1
      ? 100
      : percentageUsed >= .9
          ? 90
          : percentageUsed >= .75
              ? 75
              : 0;
}

int calculateSafeToSpend({
  required int remainingBalanceMinor,
  required int upcomingBillsMinor,
  required int upcomingBnplMinor,
  required int plannedSavingsMinor,
  required int emergencyBufferMinor,
}) {
  final result = remainingBalanceMinor -
      upcomingBillsMinor -
      upcomingBnplMinor -
      plannedSavingsMinor -
      emergencyBufferMinor;
  return result < 0 ? 0 : result;
}

class GoalProgress {
  GoalProgress({
    required this.targetMinor,
    required this.savedMinor,
    this.targetDate,
    DateTime? today,
  }) : today = today ?? DateTime.now();

  final int targetMinor;
  final int savedMinor;
  final DateTime? targetDate;
  final DateTime today;

  int get remainingMinor =>
      targetMinor > savedMinor ? targetMinor - savedMinor : 0;
  double get percentage =>
      targetMinor <= 0 ? 0 : (savedMinor / targetMinor).clamp(0, 1);
  bool get isComplete => remainingMinor == 0;
  int get requiredWeeklyMinor => _requiredForDays(7);
  int get requiredMonthlyMinor => _requiredForDays(30);

  int _requiredForDays(int periodDays) {
    if (targetDate == null || isComplete) return 0;
    final days = targetDate!.difference(today).inDays;
    if (days <= 0) return remainingMinor;
    final periods = (days / periodDays).ceil();
    return (remainingMinor / periods).ceil();
  }
}
