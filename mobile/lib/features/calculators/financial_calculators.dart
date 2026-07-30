import 'dart:math';

class BudgetSplit {
  const BudgetSplit(this.needs, this.wants, this.savings);
  final double needs;
  final double wants;
  final double savings;
}

BudgetSplit fiftyThirtyTwenty(double income) =>
    BudgetSplit(income * .5, income * .3, income * .2);

double emergencyFund(double monthlyEssentials, double months) =>
    monthlyEssentials * months;

double travelBudget({
  required double transport,
  required double lodging,
  required double daily,
  required double days,
  required double bufferPercent,
}) {
  final subtotal = transport + lodging + daily * days;
  return subtotal * (1 + bufferPercent / 100);
}

int debtPayoffMonths({
  required double balance,
  required double annualRate,
  required double monthlyPayment,
}) {
  if (balance <= 0) return 0;
  if (monthlyPayment <= 0) return -1;
  final monthlyRate = annualRate / 1200;
  if (monthlyRate == 0) return (balance / monthlyPayment).ceil();
  if (monthlyPayment <= balance * monthlyRate) return -1;
  return (-log(1 - balance * monthlyRate / monthlyPayment) /
          log(1 + monthlyRate))
      .ceil();
}

double requiredMonthlySavings({
  required double target,
  required double current,
  required int months,
}) =>
    months <= 0 ? max(0, target - current) : max(0, target - current) / months;

double compoundInterest({
  required double principal,
  required double annualRate,
  required int years,
  required double monthlyContribution,
}) {
  final monthlyRate = annualRate / 1200;
  final periods = years * 12;
  if (monthlyRate == 0) return principal + monthlyContribution * periods;
  return principal * pow(1 + monthlyRate, periods) +
      monthlyContribution * ((pow(1 + monthlyRate, periods) - 1) / monthlyRate);
}
