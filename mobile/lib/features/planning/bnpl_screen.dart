import 'package:dinarwise/core/currency/gulf_currency.dart';
import 'package:dinarwise/core/preferences/onboarding_controller.dart';
import 'package:dinarwise/features/expenses/amount_parser.dart';
import 'package:dinarwise/features/planning/data/commitments_repository.dart';
import 'package:dinarwise/features/planning/data/planning_providers.dart';
import 'package:dinarwise/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class BnplScreen extends ConsumerWidget {
  const BnplScreen({super.key});

  Future<void> _edit(
    BuildContext context,
    WidgetRef ref, [
    BnplPlanDetails? plan,
  ]) async {
    final draft = await showModalBottomSheet<BnplDraft>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _BnplEditor(plan: plan),
    );
    if (draft == null) return;
    final onboarding = await ref.read(onboardingControllerProvider.future);
    try {
      await ref
          .read(commitmentsRepositoryProvider)
          .saveBnpl(onboarding.localProfileId, draft);
    } on FormatException {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.instalmentTotalError)),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plans = ref.watch(bnplDetailsProvider);
    final currency = _currency(context, ref);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.bnplPlans)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _edit(context, ref),
        icon: const Icon(Icons.add),
        label: Text(context.l10n.add),
      ),
      body: plans.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(child: Text(context.l10n.unknownError)),
        data: (items) {
          final outstanding =
              items.fold<int>(0, (sum, plan) => sum + plan.remainingMinor);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: ListTile(
                  title: Text(context.l10n.totalOutstandingBnpl),
                  trailing: Text(
                    currency.format(outstanding / 100),
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              if (items.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: Center(child: Text(context.l10n.comingSoon)),
                )
              else
                ...items.map(
                  (plan) => Card(
                    child: ListTile(
                      onTap: () => _details(context, ref, plan, currency),
                      leading: const CircleAvatar(
                        child: Icon(Icons.calendar_month_outlined),
                      ),
                      title: Text(plan.merchant),
                      subtitle: Text(
                        '${_provider(context, plan)} • '
                        '${context.l10n.remaining}: '
                        '${currency.format(plan.remainingMinor / 100)}',
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (plan.nextInstalment != null)
                            Text(
                              DateFormat.MMMd().format(
                                plan.nextInstalment!.dueDate,
                              ),
                            ),
                          if (plan.status == 'completed')
                            Text(
                              context.l10n.completed,
                              style: const TextStyle(color: Colors.green),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 80),
            ],
          );
        },
      ),
    );
  }

  String _provider(BuildContext context, BnplPlanDetails plan) =>
      switch (plan.provider) {
        'tabby' => 'Tabby',
        'tamara' => 'Tamara',
        _ => plan.customProvider ?? context.l10n.customProvider,
      };

  Future<void> _details(
    BuildContext context,
    WidgetRef ref,
    BnplPlanDetails plan,
    NumberFormat currency,
  ) {
    final repository = ref.read(commitmentsRepositoryProvider);
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => FractionallySizedBox(
        heightFactor: .85,
        child: Column(
          children: [
            ListTile(
              title: Text(
                plan.merchant,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              subtitle: Text(
                '${context.l10n.paidAmount}: '
                '${currency.format(plan.paidMinor / 100)}\n'
                '${context.l10n.remaining}: '
                '${currency.format(plan.remainingMinor / 100)}',
              ),
              trailing: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  _edit(context, ref, plan);
                },
                icon: const Icon(Icons.edit_outlined),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: plan.instalments.length,
                itemBuilder: (_, index) {
                  final item = plan.instalments[index];
                  return CheckboxListTile(
                    value: item.isPaid,
                    title: Text(
                      '${context.l10n.instalmentNumber(index + 1)} — '
                      '${currency.format(item.amountMinor / 100)}',
                    ),
                    subtitle: Text(
                      '${DateFormat.yMMMd().format(item.dueDate)}'
                      '${item.isLate ? ' • ${context.l10n.latePayment}' : ''}',
                      style: item.isLate
                          ? TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            )
                          : null,
                    ),
                    onChanged: (paid) async {
                      final onboarding =
                          await ref.read(onboardingControllerProvider.future);
                      await repository.setInstalmentPaid(
                        profileId: onboarding.localProfileId,
                        planId: plan.id,
                        instalmentId: item.id,
                        paid: paid!,
                      );
                      if (context.mounted) Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
            ExpansionTile(
              title: Text(context.l10n.paymentHistory),
              children: [
                StreamBuilder(
                  stream: repository.watchBnplHistory(plan.id),
                  builder: (_, snapshot) {
                    final rows = snapshot.data ?? const [];
                    return Column(
                      children: rows
                          .map(
                            (row) => ListTile(
                              dense: true,
                              title: Text(
                                row.action == 'paid'
                                    ? context.l10n.markedPaid
                                    : context.l10n.paymentUndone,
                              ),
                              subtitle:
                                  Text(DateFormat.yMd().format(row.occurredAt)),
                              trailing:
                                  Text(currency.format(row.amountMinor / 100)),
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BnplEditor extends StatefulWidget {
  const _BnplEditor({this.plan});

  final BnplPlanDetails? plan;

  @override
  State<_BnplEditor> createState() => _BnplEditorState();
}

class _BnplEditorState extends State<_BnplEditor> {
  late final TextEditingController _merchant =
      TextEditingController(text: widget.plan?.merchant);
  late final TextEditingController _amount = TextEditingController(
    text: widget.plan == null
        ? null
        : (widget.plan!.purchaseAmountMinor / 100).toStringAsFixed(2),
  );
  late final TextEditingController _custom =
      TextEditingController(text: widget.plan?.customProvider);
  late String _provider = widget.plan?.provider ?? 'tabby';
  late DateTime _date = widget.plan?.purchaseDate ?? DateTime.now();

  @override
  void dispose() {
    _merchant.dispose();
    _amount.dispose();
    _custom.dispose();
    super.dispose();
  }

  void _save() {
    final amount = parseLocalizedAmount(_amount.text);
    if (_merchant.text.trim().isEmpty || amount == null || amount <= 0) return;
    final amountMinor = (amount * 100).round();
    const count = 4;
    final base = amountMinor ~/ count;
    final remainder = amountMinor % count;
    Navigator.pop(
      context,
      BnplDraft(
        id: widget.plan?.id,
        provider: _provider,
        customProvider: _provider == 'custom' ? _custom.text.trim() : null,
        merchant: _merchant.text.trim(),
        purchaseAmountMinor: amountMinor,
        purchaseDate: _date,
        instalmentAmounts: List.generate(
          count,
          (index) => base + (index == count - 1 ? remainder : 0),
        ),
        dueDates: List.generate(
          count,
          (index) => DateTime(_date.year, _date.month + index + 1, _date.day),
        ),
      ),
    );
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
                widget.plan == null
                    ? context.l10n.addBnplPlan
                    : context.l10n.editBnplPlan,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              DropdownButtonFormField<String>(
                initialValue: _provider,
                decoration: InputDecoration(labelText: context.l10n.provider),
                items: [
                  const DropdownMenuItem(value: 'tabby', child: Text('Tabby')),
                  const DropdownMenuItem(
                      value: 'tamara', child: Text('Tamara')),
                  DropdownMenuItem(
                    value: 'custom',
                    child: Text(context.l10n.customProvider),
                  ),
                ],
                onChanged: (value) => setState(() => _provider = value!),
              ),
              if (_provider == 'custom')
                TextField(
                  controller: _custom,
                  decoration:
                      InputDecoration(labelText: context.l10n.providerName),
                ),
              TextField(
                controller: _merchant,
                decoration: InputDecoration(labelText: context.l10n.merchant),
              ),
              TextField(
                controller: _amount,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration:
                    InputDecoration(labelText: context.l10n.purchaseAmount),
              ),
              ListTile(
                title: Text(context.l10n.purchaseDate),
                subtitle: Text(DateFormat.yMd().format(_date)),
                onTap: () async {
                  final selected = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    initialDate: _date,
                  );
                  if (selected != null) setState(() => _date = selected);
                },
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _save,
                  child: Text(context.l10n.save),
                ),
              ),
            ],
          ),
        ),
      );
}

NumberFormat _currency(BuildContext context, WidgetRef ref) => ref
    .watch(selectedCurrencyProvider)
    .formatter(Localizations.localeOf(context).toLanguageTag());
