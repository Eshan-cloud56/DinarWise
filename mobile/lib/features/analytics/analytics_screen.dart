import 'package:dinarwise/features/analytics/analytics_calculator.dart';
import 'package:dinarwise/core/currency/gulf_currency.dart';
import 'package:dinarwise/features/categories/category_localization.dart';
import 'package:dinarwise/features/categories/data/category_repository.dart';
import 'package:dinarwise/features/expenses/data/expense_providers.dart';
import 'package:dinarwise/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  DateTime? _from;
  DateTime? _to;
  String _chartPeriod = 'monthly';

  Future<void> _chooseRange() async {
    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 20),
      lastDate: DateTime(now.year + 5),
      initialDateRange:
          _from == null ? null : DateTimeRange(start: _from!, end: _to!),
    );
    if (range != null) {
      setState(() {
        _from = range.start;
        _to = range.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final records = ref.watch(expensesProvider);
    final categories = ref.watch(categoriesProvider).valueOrNull ?? const [];
    final currency = ref
        .watch(selectedCurrencyProvider)
        .formatter(Localizations.localeOf(context).toLanguageTag());
    return Scaffold(
      appBar: AppBar(title: Text(l10n.analytics)),
      body: records.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(child: Text(l10n.unknownError)),
        data: (items) {
          final summary = const AnalyticsCalculator().calculate(
            items,
            from: _from,
            to: _to,
          );
          final categoryById = {
            for (final category in categories) category.id: category,
          };
          final sortedCategoryExpenses = summary.categoryExpenses.entries
              .toList()
            ..sort((a, b) => b.value.compareTo(a.value));
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _chooseRange,
                      icon: const Icon(Icons.date_range_outlined),
                      label: Text(
                        _from == null
                            ? l10n.customDateRange
                            : '${DateFormat.yMd().format(_from!)} – '
                                '${DateFormat.yMd().format(_to!)}',
                      ),
                    ),
                  ),
                  if (_from != null)
                    IconButton(
                      tooltip: l10n.clearFilters,
                      onPressed: () => setState(() {
                        _from = null;
                        _to = null;
                      }),
                      icon: const Icon(Icons.clear),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.55,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  _MetricCard(
                    label: l10n.totalIncome,
                    value: currency.format(summary.totalIncomeMinor / 100),
                  ),
                  _MetricCard(
                    label: l10n.totalExpenses,
                    value: currency.format(summary.totalExpenseMinor / 100),
                  ),
                  _MetricCard(
                    label: l10n.averageDailySpending,
                    value:
                        currency.format(summary.averageDailyExpenseMinor / 100),
                  ),
                  _MetricCard(
                    label: l10n.savingsRate,
                    value: NumberFormat.percentPattern(
                      Localizations.localeOf(context).toLanguageTag(),
                    ).format(summary.savingsRate),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _ComparisonCard(
                title: l10n.weekComparison,
                current: summary.currentWeekExpenseMinor,
                previous: summary.previousWeekExpenseMinor,
                currency: currency,
              ),
              _ComparisonCard(
                title: l10n.monthComparison,
                current: summary.currentMonthExpenseMinor,
                previous: summary.previousMonthExpenseMinor,
                currency: currency,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.incomeVsExpense,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              _IncomeExpenseChart(
                income: summary.totalIncomeMinor,
                expense: summary.totalExpenseMinor,
                currency: currency,
              ),
              const SizedBox(height: 18),
              Text(
                l10n.spendingCharts,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SegmentedButton<String>(
                  segments: [
                    ButtonSegment(value: 'daily', label: Text(l10n.daily)),
                    ButtonSegment(value: 'weekly', label: Text(l10n.weekly)),
                    ButtonSegment(value: 'monthly', label: Text(l10n.monthly)),
                    ButtonSegment(value: 'yearly', label: Text(l10n.yearly)),
                  ],
                  selected: {_chartPeriod},
                  onSelectionChanged: (value) =>
                      setState(() => _chartPeriod = value.first),
                ),
              ),
              const SizedBox(height: 8),
              _BarChart(
                values: switch (_chartPeriod) {
                  'daily' => summary.dailyExpenses,
                  'weekly' => summary.weeklyExpenses,
                  'yearly' => summary.yearlyExpenses,
                  _ => summary.monthlyExpenses,
                },
                currency: currency,
                period: _chartPeriod,
              ),
              const SizedBox(height: 18),
              Text(
                l10n.categoryBreakdown,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              if (summary.categoryExpenses.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(l10n.noResults),
                  ),
                )
              else
                ...sortedCategoryExpenses.map(
                  (entry) {
                    final category = categoryById[entry.key];
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.pie_chart_outline),
                        title: Text(
                          category == null
                              ? l10n.other
                              : localizedCategoryName(l10n, category),
                        ),
                        trailing: Text(currency.format(entry.value / 100)),
                        onTap: () =>
                            context.push('/history?category=${entry.key}'),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 18),
              Text(
                l10n.localInsights,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(_insight(context, summary, categoryById)),
                ),
              ),
              if (summary.highestMerchant != null)
                ListTile(
                  leading: const Icon(Icons.storefront_outlined),
                  title: Text(l10n.highestSpendingMerchant),
                  subtitle: Text(summary.highestMerchant!),
                ),
              if (summary.highestCategoryId != null)
                ListTile(
                  leading: const Icon(Icons.category_outlined),
                  title: Text(l10n.highestSpendingCategory),
                  subtitle: Text(
                    categoryById[summary.highestCategoryId] == null
                        ? l10n.other
                        : localizedCategoryName(
                            l10n,
                            categoryById[summary.highestCategoryId]!,
                          ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  String _insight(
    BuildContext context,
    AnalyticsSummary summary,
    Map<String, CategoryRecord> categoryById,
  ) {
    final previous = summary.previousMonthExpenseMinor;
    if (previous == 0) return context.l10n.notEnoughComparisonData;
    final change =
        ((summary.currentMonthExpenseMinor - previous) / previous * 100)
            .round();
    return change >= 0
        ? context.l10n.spendingIncreased(change)
        : context.l10n.spendingDecreased(change.abs());
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label, textAlign: TextAlign.center, maxLines: 2),
              const SizedBox(height: 8),
              FittedBox(
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
            ],
          ),
        ),
      );
}

class _ComparisonCard extends StatelessWidget {
  const _ComparisonCard({
    required this.title,
    required this.current,
    required this.previous,
    required this.currency,
  });

  final String title;
  final int current;
  final int previous;
  final NumberFormat currency;

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          title: Text(title),
          subtitle: Text(
            '${context.l10n.currentPeriod}: ${currency.format(current / 100)}\n'
            '${context.l10n.previousPeriod}: '
            '${currency.format(previous / 100)}',
          ),
          trailing: Icon(
            current <= previous ? Icons.trending_down : Icons.trending_up,
            color: current <= previous ? Colors.green : Colors.red,
          ),
        ),
      );
}

class _BarChart extends StatelessWidget {
  const _BarChart({
    required this.values,
    required this.currency,
    required this.period,
  });

  final Map<DateTime, int> values;
  final NumberFormat currency;
  final String period;

  @override
  Widget build(BuildContext context) {
    final entries = values.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    final visible =
        entries.length <= 12 ? entries : entries.sublist(entries.length - 12);
    final maximum = visible.fold<int>(
      0,
      (value, item) => item.value > value ? item.value : value,
    );
    if (visible.isEmpty) {
      return SizedBox(
          height: 100, child: Center(child: Text(context.l10n.noResults)));
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: visible.map((entry) {
            final fraction = maximum == 0 ? 0.0 : entry.value / maximum;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  SizedBox(
                    width: 58,
                    child: Text(
                      switch (period) {
                        'daily' => DateFormat.Md().format(entry.key),
                        'weekly' => DateFormat.MMMd().format(entry.key),
                        'yearly' => DateFormat.y().format(entry.key),
                        _ => DateFormat.yMMM().format(entry.key),
                      },
                    ),
                  ),
                  Expanded(
                    child: LinearProgressIndicator(value: fraction),
                  ),
                  const SizedBox(width: 8),
                  Text(currency.format(entry.value / 100)),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _IncomeExpenseChart extends StatelessWidget {
  const _IncomeExpenseChart({
    required this.income,
    required this.expense,
    required this.currency,
  });

  final int income;
  final int expense;
  final NumberFormat currency;

  @override
  Widget build(BuildContext context) {
    final maximum = income > expense ? income : expense;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _ComparisonBar(
              label: context.l10n.totalIncome,
              amount: income,
              maximum: maximum,
              color: Colors.green,
              currency: currency,
            ),
            const SizedBox(height: 14),
            _ComparisonBar(
              label: context.l10n.totalExpenses,
              amount: expense,
              maximum: maximum,
              color: Colors.red,
              currency: currency,
            ),
          ],
        ),
      ),
    );
  }
}

class _ComparisonBar extends StatelessWidget {
  const _ComparisonBar({
    required this.label,
    required this.amount,
    required this.maximum,
    required this.color,
    required this.currency,
  });

  final String label;
  final int amount;
  final int maximum;
  final Color color;
  final NumberFormat currency;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(label)),
              Text(currency.format(amount / 100)),
            ],
          ),
          const SizedBox(height: 5),
          LinearProgressIndicator(
            value: maximum == 0 ? 0 : amount / maximum,
            color: color,
            minHeight: 14,
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      );
}
