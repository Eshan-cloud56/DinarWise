import 'package:dinarwise/features/calculators/financial_calculators.dart';
import 'package:dinarwise/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';

class CalculatorsScreen extends StatefulWidget {
  const CalculatorsScreen({super.key});

  @override
  State<CalculatorsScreen> createState() => _CalculatorsScreenState();
}

class _CalculatorsScreenState extends State<CalculatorsScreen> {
  String _type = 'split';
  final _values = List.generate(5, (_) => TextEditingController());
  String? _result;

  double value(int index) =>
      double.tryParse(_values[index].text.replaceAll(',', '.')) ?? 0;

  void _calculate() {
    setState(() {
      switch (_type) {
        case 'split':
          final split = fiftyThirtyTwenty(value(0));
          _result = '${context.l10n.needs}: ${split.needs.toStringAsFixed(2)}\n'
              '${context.l10n.wants}: ${split.wants.toStringAsFixed(2)}\n'
              '${context.l10n.savings}: ${split.savings.toStringAsFixed(2)}';
          return;
        case 'emergency':
          _result = emergencyFund(value(0), value(1)).toStringAsFixed(2);
          return;
        case 'travel':
          _result = travelBudget(
            transport: value(0),
            lodging: value(1),
            daily: value(2),
            days: value(3),
            bufferPercent: value(4),
          ).toStringAsFixed(2);
          return;
        case 'debt':
          final months = debtPayoffMonths(
            balance: value(0),
            annualRate: value(1),
            monthlyPayment: value(2),
          );
          _result = months < 0
              ? context.l10n.paymentTooLow
              : context.l10n.monthCount(months);
          return;
        case 'goal':
          _result = requiredMonthlySavings(
            target: value(0),
            current: value(1),
            months: value(2).round(),
          ).toStringAsFixed(2);
          return;
        case 'compound':
          _result = compoundInterest(
            principal: value(0),
            annualRate: value(1),
            years: value(2).round(),
            monthlyContribution: value(3),
          ).toStringAsFixed(2);
          return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final types = {
      'split': context.l10n.budgetCalculator,
      'emergency': context.l10n.emergencyCalculator,
      'travel': context.l10n.travelCalculator,
      'debt': context.l10n.debtCalculator,
      'goal': context.l10n.goalCalculator,
      'compound': context.l10n.compoundCalculator,
    };
    final labels = switch (_type) {
      'split' => [context.l10n.monthlyIncome],
      'emergency' => [
          context.l10n.monthlyEssentials,
          context.l10n.months,
        ],
      'travel' => [
          context.l10n.transport,
          context.l10n.lodging,
          context.l10n.dailyCost,
          context.l10n.days,
          context.l10n.bufferPercent,
        ],
      'debt' => [
          context.l10n.debtBalance,
          context.l10n.annualRate,
          context.l10n.monthlyPayment,
        ],
      'goal' => [
          context.l10n.targetAmount,
          context.l10n.currentSaved,
          context.l10n.months,
        ],
      _ => [
          context.l10n.startingAmount,
          context.l10n.annualRate,
          context.l10n.years,
          context.l10n.monthlyContribution,
        ],
    };
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.offlineCalculators)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          DropdownButtonFormField<String>(
            initialValue: _type,
            decoration: InputDecoration(labelText: context.l10n.calculator),
            items: types.entries
                .map((item) =>
                    DropdownMenuItem(value: item.key, child: Text(item.value)))
                .toList(),
            onChanged: (value) => setState(() {
              _type = value!;
              _result = null;
              for (final controller in _values) {
                controller.clear();
              }
            }),
          ),
          const SizedBox(height: 16),
          for (var index = 0; index < labels.length; index++) ...[
            TextField(
              controller: _values[index],
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: labels[index]),
            ),
            const SizedBox(height: 12),
          ],
          FilledButton.icon(
            onPressed: _calculate,
            icon: const Icon(Icons.calculate_outlined),
            label: Text(context.l10n.calculate),
          ),
          if (_result != null) ...[
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  '${context.l10n.result}\n$_result',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            Text(context.l10n.calculatorDoesNotSave),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    for (final controller in _values) {
      controller.dispose();
    }
    super.dispose();
  }
}
