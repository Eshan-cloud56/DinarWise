import 'package:dinarwise/features/calculators/financial_calculators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('50/30/20 split is deterministic', () {
    final result = fiftyThirtyTwenty(10000);
    expect(result.needs, 5000);
    expect(result.wants, 3000);
    expect(result.savings, 2000);
  });

  test('emergency and travel calculators include configured buffers', () {
    expect(emergencyFund(4000, 6), 24000);
    expect(
      travelBudget(
        transport: 1000,
        lodging: 2000,
        daily: 100,
        days: 5,
        bufferPercent: 10,
      ),
      closeTo(3850, 0.001),
    );
  });

  test('debt calculator detects payments below monthly interest', () {
    expect(
      debtPayoffMonths(
        balance: 10000,
        annualRate: 24,
        monthlyPayment: 100,
      ),
      -1,
    );
    expect(
      debtPayoffMonths(
        balance: 1200,
        annualRate: 0,
        monthlyPayment: 100,
      ),
      12,
    );
  });

  test('goal and compound calculations work without network data', () {
    expect(
      requiredMonthlySavings(target: 12000, current: 3000, months: 9),
      1000,
    );
    expect(
      compoundInterest(
        principal: 1000,
        annualRate: 0,
        years: 2,
        monthlyContribution: 100,
      ),
      3400,
    );
  });
}
