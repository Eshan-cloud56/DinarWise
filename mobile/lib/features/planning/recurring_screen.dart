import 'package:dinarwise/core/currency/gulf_currency.dart';
import 'package:dinarwise/core/preferences/onboarding_controller.dart';
import 'package:dinarwise/features/categories/category_localization.dart';
import 'package:dinarwise/features/categories/data/category_repository.dart';
import 'package:dinarwise/features/expenses/amount_parser.dart';
import 'package:dinarwise/features/expenses/data/expense_providers.dart';
import 'package:dinarwise/features/planning/data/commitments_repository.dart';
import 'package:dinarwise/features/planning/data/planning_providers.dart';
import 'package:dinarwise/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class RecurringScreen extends ConsumerWidget {
  const RecurringScreen({super.key});

  Future<void> _edit(
    BuildContext context,
    WidgetRef ref, [
    RecurringDetails? item,
  ]) async {
    final categories = ref.read(categoriesProvider).valueOrNull ?? const [];
    final draft = await showModalBottomSheet<RecurringDraft>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _RecurringEditor(item: item, categories: categories),
    );
    if (draft == null) return;
    final onboarding = await ref.read(onboardingControllerProvider.future);
    await ref
        .read(commitmentsRepositoryProvider)
        .saveRecurring(onboarding.localProfileId, draft);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(recurringDetailsProvider);
    final currency = _currency(context, ref);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.billsAndSubscriptions)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _edit(context, ref),
        icon: const Icon(Icons.add),
        label: Text(context.l10n.add),
      ),
      body: items.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(child: Text(context.l10n.unknownError)),
        data: (records) => records.isEmpty
            ? Center(child: Text(context.l10n.comingSoon))
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: records.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, index) {
                  final item = records[index];
                  return Card(
                    child: ListTile(
                      onTap: () => _details(context, ref, item, currency),
                      leading: CircleAvatar(
                        child: Icon(
                          item.isSubscription
                              ? Icons.subscriptions_outlined
                              : Icons.receipt_long_outlined,
                        ),
                      ),
                      title: Text(item.name),
                      subtitle: Text(
                        '${_recurrenceLabel(context, item.recurrence)} • '
                        '${DateFormat.yMMMd().format(item.nextPaymentDate)}',
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(currency.format(item.amountMinor / 100)),
                          if (item.status == 'ended') Text(context.l10n.ended),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Future<void> _details(
    BuildContext context,
    WidgetRef ref,
    RecurringDetails item,
    NumberFormat currency,
  ) {
    final repository = ref.read(commitmentsRepositoryProvider);
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => FractionallySizedBox(
        heightFactor: .88,
        child: Column(
          children: [
            ListTile(
              title: Text(
                item.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              subtitle: Text(
                '${context.l10n.lifetimePaid}: '
                '${currency.format(item.lifetimePaidMinor / 100)}'
                '${item.recurrence == 'yearly' ? '\n${context.l10n.monthlyEquivalent}: ${currency.format(item.monthlyEquivalentMinor / 100)}' : ''}',
              ),
              trailing: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  _edit(context, ref, item);
                },
                icon: const Icon(Icons.edit_outlined),
              ),
            ),
            Expanded(
              child: ListView(
                children: item.occurrences.map((occurrence) {
                  return ListTile(
                    title: Text(currency.format(occurrence.amountMinor / 100)),
                    subtitle: Text(
                      '${DateFormat.yMMMd().format(occurrence.scheduledAt)} • '
                      '${occurrence.status == 'paid' ? context.l10n.paid : context.l10n.upcoming}',
                    ),
                    leading: Icon(
                      occurrence.status == 'paid'
                          ? Icons.check_circle
                          : Icons.schedule,
                      color: occurrence.status == 'paid' ? Colors.green : null,
                    ),
                    trailing: occurrence.status == 'paid'
                        ? null
                        : PopupMenuButton<String>(
                            onSelected: (action) async {
                              if (action == 'paid') {
                                final onboarding = await ref
                                    .read(onboardingControllerProvider.future);
                                await repository.markOccurrencePaid(
                                  profileId: onboarding.localProfileId,
                                  recurringId: item.id,
                                  occurrenceId: occurrence.id,
                                );
                              } else {
                                await _editOneOccurrence(
                                  context,
                                  repository,
                                  occurrence,
                                );
                              }
                              if (context.mounted) Navigator.pop(context);
                            },
                            itemBuilder: (_) => [
                              PopupMenuItem(
                                value: 'paid',
                                child: Text(context.l10n.markAsPaid),
                              ),
                              PopupMenuItem(
                                value: 'edit',
                                child: Text(context.l10n.editOneOccurrence),
                              ),
                            ],
                          ),
                  );
                }).toList(),
              ),
            ),
            if (item.status != 'ended')
              Padding(
                padding: const EdgeInsets.all(16),
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await repository.stopRecurring(item.id);
                    if (context.mounted) Navigator.pop(context);
                  },
                  icon: const Icon(Icons.stop_circle_outlined),
                  label: Text(context.l10n.stopRecurring),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _editOneOccurrence(
    BuildContext context,
    CommitmentsRepository repository,
    RecurringOccurrenceDetails occurrence,
  ) async {
    final controller = TextEditingController(
      text: (occurrence.amountMinor / 100).toStringAsFixed(2),
    );
    final save = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.editOneOccurrence),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(labelText: context.l10n.amount),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.save),
          ),
        ],
      ),
    );
    final amount = parseLocalizedAmount(controller.text);
    controller.dispose();
    if (save == true && amount != null && amount > 0) {
      await repository.editOccurrence(
        occurrence.id,
        (amount * 100).round(),
      );
    }
  }
}

class _RecurringEditor extends StatefulWidget {
  const _RecurringEditor({required this.item, required this.categories});

  final RecurringDetails? item;
  final List<CategoryRecord> categories;

  @override
  State<_RecurringEditor> createState() => _RecurringEditorState();
}

class _RecurringEditorState extends State<_RecurringEditor> {
  late final TextEditingController _name =
      TextEditingController(text: widget.item?.name);
  late final TextEditingController _amount = TextEditingController(
    text: widget.item == null
        ? null
        : (widget.item!.amountMinor / 100).toStringAsFixed(2),
  );
  late final TextEditingController _occurrences = TextEditingController(
    text: widget.item?.maxOccurrences?.toString(),
  );
  late String _recurrence = widget.item?.recurrence ?? 'monthly';
  late int _interval = widget.item?.intervalCount ?? 1;
  late String? _categoryId = widget.item?.categoryId;
  late DateTime _start = widget.item?.startDate ?? DateTime.now();
  late DateTime? _end = widget.item?.endDate;
  late bool _subscription = widget.item?.isSubscription ?? false;

  @override
  void dispose() {
    _name.dispose();
    _amount.dispose();
    _occurrences.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
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
                widget.item == null
                    ? context.l10n.addRecurring
                    : context.l10n.editRecurring,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextField(
                controller: _name,
                decoration: InputDecoration(labelText: context.l10n.name),
              ),
              TextField(
                controller: _amount,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: context.l10n.amount),
              ),
              DropdownButtonFormField<String>(
                initialValue: _recurrence,
                decoration: InputDecoration(labelText: context.l10n.recurrence),
                items: [
                  DropdownMenuItem(
                    value: 'daily',
                    child: Text(context.l10n.daily),
                  ),
                  DropdownMenuItem(
                    value: 'weekly',
                    child: Text(context.l10n.weekly),
                  ),
                  DropdownMenuItem(
                    value: 'monthly',
                    child: Text(context.l10n.monthly),
                  ),
                  DropdownMenuItem(
                    value: 'yearly',
                    child: Text(context.l10n.yearly),
                  ),
                ],
                onChanged: (value) => setState(() => _recurrence = value!),
              ),
              DropdownButtonFormField<int>(
                initialValue: _interval,
                decoration: InputDecoration(labelText: context.l10n.every),
                items: List.generate(
                  12,
                  (index) => DropdownMenuItem(
                    value: index + 1,
                    child: Text('${index + 1}'),
                  ),
                ),
                onChanged: (value) => setState(() => _interval = value!),
              ),
              DropdownButtonFormField<String?>(
                initialValue: _categoryId,
                decoration: InputDecoration(labelText: context.l10n.category),
                items: [
                  DropdownMenuItem(
                    value: null,
                    child: Text(context.l10n.other),
                  ),
                  ...widget.categories.map(
                    (category) => DropdownMenuItem(
                      value: category.id,
                      child: Text(
                        localizedCategoryName(context.l10n, category),
                      ),
                    ),
                  ),
                ],
                onChanged: (value) => setState(() => _categoryId = value),
              ),
              SwitchListTile(
                value: _subscription,
                onChanged: (value) => setState(() => _subscription = value),
                title: Text(context.l10n.isSubscription),
              ),
              _DateTile(
                label: context.l10n.startDate,
                date: _start,
                onChanged: (date) => setState(() => _start = date),
              ),
              _DateTile(
                label: context.l10n.endDate,
                date: _end,
                optional: true,
                onChanged: (date) => setState(() => _end = date),
              ),
              TextField(
                controller: _occurrences,
                keyboardType: TextInputType.number,
                decoration:
                    InputDecoration(labelText: context.l10n.maxOccurrences),
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    final amount = parseLocalizedAmount(_amount.text);
                    if (_name.text.trim().isEmpty ||
                        amount == null ||
                        amount <= 0) {
                      return;
                    }
                    Navigator.pop(
                      context,
                      RecurringDraft(
                        id: widget.item?.id,
                        name: _name.text.trim(),
                        amountMinor: (amount * 100).round(),
                        recurrence: _recurrence,
                        intervalCount: _interval,
                        categoryId: _categoryId,
                        startDate: _start,
                        endDate: _end,
                        maxOccurrences: int.tryParse(_occurrences.text.trim()),
                        isSubscription: _subscription,
                      ),
                    );
                  },
                  child: Text(context.l10n.save),
                ),
              ),
            ],
          ),
        ),
      );
}

class _DateTile extends StatelessWidget {
  const _DateTile({
    required this.label,
    required this.date,
    required this.onChanged,
    this.optional = false,
  });

  final String label;
  final DateTime? date;
  final ValueChanged<DateTime> onChanged;
  final bool optional;

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(label),
        subtitle: Text(
          date == null ? context.l10n.optional : DateFormat.yMd().format(date!),
        ),
        trailing: const Icon(Icons.date_range_outlined),
        onTap: () async {
          final selected = await showDatePicker(
            context: context,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            initialDate: date ?? DateTime.now(),
          );
          if (selected != null) onChanged(selected);
        },
      );
}

String _recurrenceLabel(BuildContext context, String value) => switch (value) {
      'daily' => context.l10n.daily,
      'weekly' => context.l10n.weekly,
      'yearly' => context.l10n.yearly,
      _ => context.l10n.monthly,
    };

NumberFormat _currency(BuildContext context, WidgetRef ref) => ref
    .watch(selectedCurrencyProvider)
    .formatter(Localizations.localeOf(context).toLanguageTag());
