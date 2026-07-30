import 'package:dinarwise/core/preferences/onboarding_controller.dart';
import 'package:dinarwise/core/currency/gulf_currency.dart';
import 'package:dinarwise/features/categories/category_localization.dart';
import 'package:dinarwise/features/categories/custom_category_dialog.dart';
import 'package:dinarwise/features/expenses/data/expense_providers.dart';
import 'package:dinarwise/features/planning/data/planning_providers.dart';
import 'package:dinarwise/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class PlanningScreen extends ConsumerWidget {
  const PlanningScreen({required this.section, super.key});

  final String section;

  String _title(BuildContext context) {
    final l10n = context.l10n;
    return switch (section) {
      'budgets' => l10n.budgets,
      'goals' => l10n.savingsGoals,
      'bnpl' => l10n.bnplPlans,
      _ => l10n.billsAndSubscriptions,
    };
  }

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final nameController = TextEditingController();
    final amountController = TextEditingController();
    String? categoryId;
    final showCategories = section == 'budgets' || section == 'recurring';
    final categories = ref.read(categoriesProvider).valueOrNull ?? [];
    final created = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) {
          final l10n = context.l10n;
          return AlertDialog(
            title: Text('${l10n.add} ${_title(context)}'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    maxLength: 120,
                    decoration: InputDecoration(labelText: l10n.name),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: amountController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: section == 'goals'
                          ? l10n.targetAmount
                          : section == 'bnpl'
                              ? l10n.purchaseAmount
                              : l10n.amount,
                    ),
                  ),
                  if (showCategories) ...[
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: categoryId,
                      decoration: InputDecoration(labelText: l10n.category),
                      items: [
                        ...categories.map(
                          (category) => DropdownMenuItem(
                            value: category.id,
                            child: Text(
                              localizedCategoryName(l10n, category),
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: '__custom__',
                          child: Text(l10n.customCategory),
                        ),
                      ],
                      onChanged: (value) async {
                        if (value == '__custom__') {
                          final custom =
                              await showCustomCategoryDialog(context, ref);
                          if (custom != null) {
                            setState(() => categoryId = custom.id);
                          }
                        } else {
                          setState(() => categoryId = value);
                        }
                      },
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.cancel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(l10n.save),
              ),
            ],
          );
        },
      ),
    );
    if (created != true) {
      nameController.dispose();
      amountController.dispose();
      return;
    }
    final amount = double.tryParse(amountController.text.trim());
    final name = nameController.text.trim();
    nameController.dispose();
    amountController.dispose();
    if (name.isEmpty || amount == null || amount <= 0) return;
    final onboarding = await ref.read(onboardingControllerProvider.future);
    await ref.read(planningRepositoryProvider).create(
          profileId: onboarding.localProfileId,
          section: section,
          name: name,
          amountMinor: (amount * 100).round(),
          date: DateTime.now(),
          categoryId: categoryId,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final items = ref.watch(planningItemsProvider(section));
    final currency = ref
        .watch(selectedCurrencyProvider)
        .formatter(Localizations.localeOf(context).toLanguageTag());
    return Scaffold(
      appBar: AppBar(title: Text(_title(context))),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _add(context, ref),
        icon: const Icon(Icons.add),
        label: Text(l10n.add),
      ),
      body: items.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(child: Text(l10n.unknownError)),
        data: (records) => records.isEmpty
            ? Center(child: Text(l10n.comingSoon))
            : ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: records.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final record = records[index];
                  return Card(
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.account_balance_wallet_outlined),
                      ),
                      title: Text(record.name),
                      subtitle: record.date == null
                          ? null
                          : Text(
                              DateFormat.yMd(
                                Localizations.localeOf(context).toLanguageTag(),
                              ).format(record.date!),
                            ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(currency.format(record.amountMinor / 100)),
                          IconButton(
                            tooltip: l10n.delete,
                            onPressed: () => ref
                                .read(planningRepositoryProvider)
                                .delete(section, record.id),
                            icon: const Icon(Icons.delete_outline),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
