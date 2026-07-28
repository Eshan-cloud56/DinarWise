import 'package:dinarwise/features/auth/auth_controller.dart';
import 'package:dinarwise/features/capture/capture_controller.dart';
import 'package:dinarwise/l10n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppStrings.of(context);
    final session = ref.watch(authControllerProvider).valueOrNull;
    final expenses = ref.watch(expensesProvider);
    final currency = NumberFormat.currency(
      name: 'SAR',
      symbol: 'SAR ',
      decimalDigits: 2,
      locale: Localizations.localeOf(context).toLanguageTag(),
    );
    final totalMinor = expenses.valueOrNull?.fold<int>(
          0,
          (total, expense) => total + expense.amountMinor,
        ) ??
        0;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(strings.appName),
            if (session != null)
              Text(
                session.fullName,
                style: Theme.of(context).textTheme.labelMedium,
              ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            onPressed: () async {
              await ref.read(authControllerProvider.notifier).logout();
              if (context.mounted) context.go('/login');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.push<bool>('/capture');
          ref.invalidate(expensesProvider);
        },
        icon: const Icon(Icons.add),
        label: Text(strings.addExpense),
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(expensesProvider),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Card(
              color: Theme.of(context).colorScheme.primary,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recorded expenses',
                      style: TextStyle(
                        color:
                            Theme.of(context).colorScheme.onPrimary.withAlpha(200),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currency.format(totalMinor / 100),
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${expenses.valueOrNull?.length ?? 0} transactions',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              strings.recentTransactions,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 12),
            expenses.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, _) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Icon(Icons.cloud_off_outlined, size: 38),
                      const SizedBox(height: 10),
                      Text(
                        'Could not load expenses. Make sure the API is running.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      TextButton(
                        onPressed: () => ref.invalidate(expensesProvider),
                        child: const Text('Try again'),
                      ),
                    ],
                  ),
                ),
              ),
              data: (items) => items.isEmpty
                  ? const Card(
                      child: Padding(
                        padding: EdgeInsets.all(28),
                        child: Column(
                          children: [
                            Icon(Icons.receipt_long_outlined, size: 44),
                            SizedBox(height: 10),
                            Text('No expenses yet'),
                            Text('Tap “Add expense” to record your first one.'),
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
                                  leading: const CircleAvatar(
                                    child: Icon(Icons.shopping_bag_outlined),
                                  ),
                                  title: Text(expense.merchant ?? 'Expense'),
                                  subtitle: Text(expense.category),
                                  trailing: Text(
                                    '- ${currency.format(expense.amountMinor / 100)}',
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
          ],
        ),
      ),
    );
  }
}
