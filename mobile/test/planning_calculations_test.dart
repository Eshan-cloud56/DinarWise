import 'package:dinarwise/features/planning/data/planning_calculations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('budget warnings, rollover, and overspending are deterministic', () {
    expect(
      const BudgetProgress(
        limitMinor: 10000,
        spentMinor: 8500,
        carriedMinor: 1000,
      ).warningLevel,
      75,
    );
    final overspent = const BudgetProgress(
      limitMinor: 10000,
      spentMinor: 12000,
      carriedMinor: 0,
    );
    expect(overspent.isOverspent, isTrue);
    expect(overspent.remainingMinor, -2000);
    expect(overspent.warningLevel, 100);
  });

  test('safe-to-spend reserves commitments and never becomes negative', () {
    expect(
      calculateSafeToSpend(
        remainingBalanceMinor: 100000,
        upcomingBillsMinor: 20000,
        upcomingBnplMinor: 10000,
        plannedSavingsMinor: 15000,
        emergencyBufferMinor: 5000,
      ),
      50000,
    );
    expect(
      calculateSafeToSpend(
        remainingBalanceMinor: 1000,
        upcomingBillsMinor: 2000,
        upcomingBnplMinor: 0,
        plannedSavingsMinor: 0,
        emergencyBufferMinor: 0,
      ),
      0,
    );
  });

  test('goal progress calculates remaining and required contributions', () {
    final goal = GoalProgress(
      targetMinor: 100000,
      savedMinor: 40000,
      today: DateTime(2026, 7, 1),
      targetDate: DateTime(2026, 7, 29),
    );
    expect(goal.remainingMinor, 60000);
    expect(goal.percentage, .4);
    expect(goal.requiredWeeklyMinor, 15000);
    expect(goal.requiredMonthlyMinor, 60000);
  });
}
