import 'package:dinarwise/features/categories/category_localization.dart';
import 'package:dinarwise/features/capture/offline_ai_notice.dart';
import 'package:dinarwise/features/expenses/data/expense_providers.dart';
import 'package:dinarwise/features/expenses/data/expense_repository.dart';
import 'package:dinarwise/features/expenses/income_actions.dart';
import 'package:dinarwise/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final expenses = ref.watch(recentTransactionsProvider);
    final summary = ref.watch(financialSummaryProvider).valueOrNull ??
        const FinancialSummary(
          totalIncomeMinor: 0,
          totalExpensesMinor: 0,
        );
    final categories = ref.watch(categoriesProvider).valueOrNull ?? [];
    final categoryById = {for (final item in categories) item.id: item};
    final currency = NumberFormat.currency(
      name: 'SAR',
      symbol: '${l10n.currencySar} ',
      decimalDigits: 2,
      locale: Localizations.localeOf(context).toLanguageTag(),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appName),
        actions: [
          IconButton(
            tooltip: l10n.analytics,
            onPressed: () => context.push('/analytics'),
            icon: const Icon(Icons.analytics_outlined),
          ),
          IconButton(
            tooltip: l10n.aiFeature,
            onPressed: () => showOfflineAiNotice(context),
            icon: const Icon(Icons.auto_awesome_outlined),
          ),
          IconButton(
            tooltip: l10n.settings,
            onPressed: () => context.push('/settings'),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/capture'),
        icon: const Icon(Icons.add),
        label: Text(l10n.addExpense),
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(recentTransactionsProvider),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Card(
              color: Theme.of(context).colorScheme.primary,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _BannerMetric(
                            icon: Icons.north_east_rounded,
                            label: l10n.totalExpenses,
                            value: currency
                                .format(summary.totalExpensesMinor / 100),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 72,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimary
                              .withAlpha(70),
                        ),
                        Expanded(
                          child: _BannerMetric(
                            icon: Icons.south_west_rounded,
                            label: l10n.totalIncome,
                            value:
                                currency.format(summary.totalIncomeMinor / 100),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      height: 34,
                      color:
                          Theme.of(context).colorScheme.onPrimary.withAlpha(70),
                    ),
                    Text(
                      l10n.yourRemainingBalanceIs,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimary
                            .withAlpha(210),
                      ),
                    ),
                    const SizedBox(height: 6),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        currency.format(summary.remainingBalanceMinor / 100),
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.transactionCount(summary.transactionCount),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.tonalIcon(
              key: const ValueKey('dashboardAddIncome'),
              onPressed: () => manageIncome(context, ref),
              icon: const Icon(Icons.add_card_rounded),
              label: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Text(l10n.addIncome),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.recentTransactions,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                TextButton(
                  onPressed: () => context.push('/history'),
                  child: Text(l10n.viewAll),
                ),
              ],
            ),
            const SizedBox(height: 12),
            expenses.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (_, __) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Icon(Icons.error_outline, size: 38),
                      const SizedBox(height: 10),
                      Text(
                        l10n.unknownError,
                        textAlign: TextAlign.center,
                      ),
                      TextButton(
                        onPressed: () =>
                            ref.invalidate(recentTransactionsProvider),
                        child: Text(l10n.tryAgain),
                      ),
                    ],
                  ),
                ),
              ),
              data: (items) => items.isEmpty
                  ? Card(
                      child: Padding(
                        padding: const EdgeInsets.all(28),
                        child: Column(
                          children: [
                            const Icon(Icons.receipt_long_outlined, size: 44),
                            const SizedBox(height: 10),
                            Text(l10n.noTransactions),
                            Text(
                              l10n.noTransactionsDescription,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  : Column(
                      children: items
                          .map(
                            (expense) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Card(
                                child: ListTile(
                                  onTap: () => expense.type == 'income'
                                      ? manageIncome(
                                          context,
                                          ref,
                                          income: expense,
                                        )
                                      : context.push(
                                          '/capture',
                                          extra: expense,
                                        ),
                                  leading: const CircleAvatar(
                                    child: Icon(Icons.shopping_bag_outlined),
                                  ),
                                  title: Text(
                                    expense.merchant?.trim().isNotEmpty == true
                                        ? expense.merchant!
                                        : expense.type == 'income'
                                            ? l10n.income
                                            : l10n.expense,
                                  ),
                                  subtitle: Text(
                                    categoryById[expense.categoryId] == null
                                        ? l10n.other
                                        : localizedCategoryName(
                                            l10n,
                                            categoryById[expense.categoryId]!,
                                          ),
                                  ),
                                  trailing: Text(
                                    '${expense.type == 'income' ? '+' : '-'} ${currency.format(expense.amountMinor / 100)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.financialPlanning,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 10),
            Card(
              child: Column(
                children: [
                  _DashboardLink(
                    icon: Icons.pie_chart_outline,
                    label: l10n.budgets,
                    onTap: () => context.push('/planning/budgets'),
                  ),
                  const Divider(height: 1),
                  _DashboardLink(
                    icon: Icons.savings_outlined,
                    label: l10n.savingsGoals,
                    onTap: () => context.push('/planning/goals'),
                  ),
                  const Divider(height: 1),
                  _DashboardLink(
                    icon: Icons.calendar_month_outlined,
                    label: l10n.bnplPlans,
                    onTap: () => context.push('/planning/bnpl'),
                  ),
                  const Divider(height: 1),
                  _DashboardLink(
                    icon: Icons.receipt_long_outlined,
                    label: l10n.billsAndSubscriptions,
                    onTap: () => context.push('/planning/recurring'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 88),
          ],
        ),
      ),
    );
  }
}

class _DashboardLink extends StatelessWidget {
  const _DashboardLink({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class _BannerMetric extends StatelessWidget {
  const _BannerMetric({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final foreground = Theme.of(context).colorScheme.onPrimary;
    return Column(
      children: [
        Icon(icon, color: foreground.withAlpha(220), size: 21),
        const SizedBox(height: 5),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: foreground.withAlpha(210)),
        ),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: foreground,
                ),
          ),
        ),
      ],
    );
  }
}
