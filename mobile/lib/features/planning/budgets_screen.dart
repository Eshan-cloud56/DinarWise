import 'package:dinarwise/core/currency/gulf_currency.dart';
import 'package:dinarwise/core/preferences/onboarding_controller.dart';
import 'package:dinarwise/features/categories/category_localization.dart';
import 'package:dinarwise/features/categories/data/category_repository.dart';
import 'package:dinarwise/features/expenses/amount_parser.dart';
import 'package:dinarwise/features/expenses/data/expense_providers.dart';
import 'package:dinarwise/features/planning/data/advanced_planning_repository.dart';
import 'package:dinarwise/features/planning/data/planning_providers.dart';
import 'package:dinarwise/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final _budgetsProvider =
    StreamProvider.autoDispose<List<BudgetDetails>>((ref) async* {
  final onboarding = await ref.watch(onboardingControllerProvider.future);
  yield* ref
      .watch(advancedPlanningRepositoryProvider)
      .watchBudgets(onboarding.localProfileId);
});

class BudgetsScreen extends ConsumerWidget {
  const BudgetsScreen({super.key});

  Future<void> _edit(
    BuildContext context,
    WidgetRef ref, [
    BudgetDetails? budget,
  ]) async {
    final categories = ref.read(categoriesProvider).valueOrNull ?? const [];
    final draft = await showModalBottomSheet<BudgetDraft>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _BudgetEditor(budget: budget, categories: categories),
    );
    if (draft == null) return;
    final onboarding = await ref.read(onboardingControllerProvider.future);
    await ref
        .read(advancedPlanningRepositoryProvider)
        .saveBudget(onboarding.localProfileId, draft);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgets = ref.watch(_budgetsProvider);
    final safe = ref.watch(safeToSpendProvider).valueOrNull;
    final currency = _currency(context, ref);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.budgets)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _edit(context, ref),
        icon: const Icon(Icons.add),
        label: Text(context.l10n.add),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (safe != null)
            _SafeToSpendCard(snapshot: safe, currency: currency),
          const SizedBox(height: 12),
          budgets.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => Center(child: Text(context.l10n.unknownError)),
            data: (items) => items.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(child: Text(context.l10n.comingSoon)),
                  )
                : Column(
                    children: items
                        .map(
                          (budget) => _BudgetCard(
                            budget: budget,
                            currency: currency,
                            onEdit: () => _edit(context, ref, budget),
                            onHistory: () =>
                                _showHistory(context, ref, budget, currency),
                            onDelete: () => ref
                                .read(advancedPlanningRepositoryProvider)
                                .deleteBudget(budget.id),
                          ),
                        )
                        .toList(),
                  ),
          ),
          const SizedBox(height: 90),
        ],
      ),
    );
  }

  Future<void> _showHistory(
    BuildContext context,
    WidgetRef ref,
    BudgetDetails budget,
    NumberFormat currency,
  ) {
    final stream = ref
        .read(advancedPlanningRepositoryProvider)
        .watchBudgetHistory(budget.id);
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          final rows = snapshot.data ?? const [];
          return SafeArea(
            child: Column(
              children: [
                Text(
                  context.l10n.budgetHistory,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Expanded(
                  child: rows.isEmpty
                      ? Center(child: Text(context.l10n.noHistory))
                      : ListView.builder(
                          itemCount: rows.length,
                          itemBuilder: (_, index) {
                            final row = rows[index];
                            return ListTile(
                              title: Text(
                                '${DateFormat.yMd().format(row.periodStart)} – '
                                '${DateFormat.yMd().format(row.periodEnd)}',
                              ),
                              subtitle: Text(
                                '${context.l10n.amountSpent}: '
                                '${currency.format(row.spentMinor / 100)}',
                              ),
                              trailing:
                                  Text(currency.format(row.limitMinor / 100)),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SafeToSpendCard extends StatelessWidget {
  const _SafeToSpendCard({
    required this.snapshot,
    required this.currency,
  });

  final SafeToSpendSnapshot snapshot;
  final NumberFormat currency;

  @override
  Widget build(BuildContext context) => Card(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.safeToSpend,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                currency.format(snapshot.amountMinor / 100),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              Text(
                context.l10n.daysUntilPayday(snapshot.daysUntilPayday),
              ),
              const Divider(),
              Text(
                '${context.l10n.dailySafeToSpend}: '
                '${currency.format(snapshot.dailyMinor / 100)}',
              ),
              Text(
                '${context.l10n.upcomingBills}: '
                '${currency.format(snapshot.upcomingBillsMinor / 100)}',
              ),
              Text(
                '${context.l10n.upcomingBnpl}: '
                '${currency.format(snapshot.upcomingBnplMinor / 100)}',
              ),
              Text(
                '${context.l10n.plannedSavings}: '
                '${currency.format(snapshot.plannedSavingsMinor / 100)}',
              ),
              Text(
                '${context.l10n.emergencyBuffer}: '
                '${currency.format(snapshot.emergencyBufferMinor / 100)}',
              ),
            ],
          ),
        ),
      );
}

class _BudgetCard extends StatelessWidget {
  const _BudgetCard({
    required this.budget,
    required this.currency,
    required this.onEdit,
    required this.onHistory,
    required this.onDelete,
  });

  final BudgetDetails budget;
  final NumberFormat currency;
  final VoidCallback onEdit;
  final VoidCallback onHistory;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final progress = budget.progress;
    final color = progress.isOverspent
        ? Theme.of(context).colorScheme.error
        : progress.warningLevel >= 90
            ? Colors.orange
            : Theme.of(context).colorScheme.primary;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    budget.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') onEdit();
                    if (value == 'history') onHistory();
                    if (value == 'delete') onDelete();
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Text(context.l10n.edit),
                    ),
                    PopupMenuItem(
                      value: 'history',
                      child: Text(context.l10n.budgetHistory),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text(context.l10n.delete),
                    ),
                  ],
                ),
              ],
            ),
            LinearProgressIndicator(
              value: progress.percentageUsed.clamp(0, 1),
              color: color,
              minHeight: 10,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 10),
            Text(
              '${context.l10n.amountSpent}: '
              '${currency.format(budget.spentMinor / 100)}',
            ),
            Text(
              '${context.l10n.amountRemaining}: '
              '${currency.format(progress.remainingMinor / 100)}',
              style: TextStyle(color: color),
            ),
            Text(
              '${(progress.percentageUsed * 100).toStringAsFixed(0)}% '
              '${context.l10n.used}',
            ),
            if (progress.warningLevel > 0)
              Text(
                progress.isOverspent
                    ? context.l10n.budgetOverspent
                    : context.l10n.budgetWarning(progress.warningLevel),
                style: TextStyle(color: color, fontWeight: FontWeight.w700),
              ),
          ],
        ),
      ),
    );
  }
}

class _BudgetEditor extends StatefulWidget {
  const _BudgetEditor({required this.budget, required this.categories});

  final BudgetDetails? budget;
  final List<CategoryRecord> categories;

  @override
  State<_BudgetEditor> createState() => _BudgetEditorState();
}

class _BudgetEditorState extends State<_BudgetEditor> {
  late final TextEditingController _name =
      TextEditingController(text: widget.budget?.name);
  late final TextEditingController _limit = TextEditingController(
    text: widget.budget == null
        ? null
        : (widget.budget!.limitMinor / 100).toStringAsFixed(2),
  );
  late final TextEditingController _fixed = TextEditingController(
    text: widget.budget == null
        ? null
        : (widget.budget!.fixedCommitmentsMinor / 100).toStringAsFixed(2),
  );
  late final TextEditingController _buffer = TextEditingController(
    text: widget.budget == null
        ? null
        : (widget.budget!.emergencyBufferMinor / 100).toStringAsFixed(2),
  );
  late bool _overall = widget.budget?.isOverall ?? false;
  late String _rollover = widget.budget?.rolloverMode ?? 'none';
  late String _cycle = widget.budget?.cycleType ?? 'monthly';
  late int _payday = widget.budget?.payday ?? 1;
  late final Set<String> _categories = {...?widget.budget?.categoryIds};

  @override
  void dispose() {
    _name.dispose();
    _limit.dispose();
    _fixed.dispose();
    _buffer.dispose();
    super.dispose();
  }

  void _save() {
    final limit = parseLocalizedAmount(_limit.text);
    if (_name.text.trim().isEmpty || limit == null || limit <= 0) return;
    final now = DateTime.now();
    final starts = DateTime(now.year, now.month);
    final ends = _cycle == 'salary'
        ? DateTime(now.year, now.month + 1, _payday)
        : DateTime(now.year, now.month + 1, 0);
    Navigator.pop(
      context,
      BudgetDraft(
        id: widget.budget?.id,
        name: _name.text.trim(),
        limitMinor: (limit * 100).round(),
        startsOn: starts,
        endsOn: ends,
        isOverall: _overall,
        rolloverMode: _rollover,
        cycleType: _cycle,
        payday: _cycle == 'salary' ? _payday : null,
        fixedCommitmentsMinor:
            ((parseLocalizedAmount(_fixed.text) ?? 0) * 100).round(),
        emergencyBufferMinor:
            ((parseLocalizedAmount(_buffer.text) ?? 0) * 100).round(),
        categoryIds: _overall ? const [] : _categories.toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        MediaQuery.viewInsetsOf(context).bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              widget.budget == null ? l10n.addBudget : l10n.editBudget,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextField(
              controller: _name,
              decoration: InputDecoration(labelText: l10n.name),
            ),
            TextField(
              controller: _limit,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: l10n.budgetLimit),
            ),
            SwitchListTile(
              value: _overall,
              onChanged: (value) => setState(() => _overall = value),
              title: Text(l10n.overallBudget),
            ),
            if (!_overall)
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Wrap(
                  spacing: 6,
                  children: widget.categories
                      .map(
                        (category) => FilterChip(
                          selected: _categories.contains(category.id),
                          label: Text(localizedCategoryName(l10n, category)),
                          onSelected: (selected) => setState(() {
                            selected
                                ? _categories.add(category.id)
                                : _categories.remove(category.id);
                          }),
                        ),
                      )
                      .toList(),
                ),
              ),
            DropdownButtonFormField<String>(
              initialValue: _rollover,
              decoration: InputDecoration(labelText: l10n.rollover),
              items: [
                DropdownMenuItem(value: 'none', child: Text(l10n.noRollover)),
                DropdownMenuItem(
                  value: 'unused',
                  child: Text(l10n.carryUnused),
                ),
                DropdownMenuItem(
                  value: 'all',
                  child: Text(l10n.carryUnusedAndOverspending),
                ),
              ],
              onChanged: (value) => setState(() => _rollover = value!),
            ),
            DropdownButtonFormField<String>(
              initialValue: _cycle,
              decoration: InputDecoration(labelText: l10n.budgetCycle),
              items: [
                DropdownMenuItem(value: 'monthly', child: Text(l10n.monthly)),
                DropdownMenuItem(
                  value: 'salary',
                  child: Text(l10n.salaryCycle),
                ),
              ],
              onChanged: (value) => setState(() => _cycle = value!),
            ),
            if (_cycle == 'salary')
              DropdownButtonFormField<int>(
                initialValue: _payday,
                decoration: InputDecoration(labelText: l10n.payday),
                items: List.generate(
                  28,
                  (index) => DropdownMenuItem(
                    value: index + 1,
                    child: Text('${index + 1}'),
                  ),
                ),
                onChanged: (value) => setState(() => _payday = value!),
              ),
            TextField(
              controller: _fixed,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: l10n.fixedCommitments),
            ),
            TextField(
              controller: _buffer,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: l10n.emergencyBuffer),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _save,
                child: Text(l10n.save),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

NumberFormat _currency(BuildContext context, WidgetRef ref) => ref
    .watch(selectedCurrencyProvider)
    .formatter(Localizations.localeOf(context).toLanguageTag());
