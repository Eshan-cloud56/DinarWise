import 'package:dinarwise/core/preferences/onboarding_controller.dart';
import 'package:dinarwise/features/categories/category_localization.dart';
import 'package:dinarwise/features/categories/custom_category_dialog.dart';
import 'package:dinarwise/features/expenses/amount_parser.dart';
import 'package:dinarwise/features/expenses/data/expense_providers.dart';
import 'package:dinarwise/features/expenses/data/expense_repository.dart';
import 'package:dinarwise/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class CaptureScreen extends ConsumerStatefulWidget {
  const CaptureScreen({this.expense, super.key});

  final ExpenseRecord? expense;

  @override
  ConsumerState<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends ConsumerState<CaptureScreen> {
  static const _customCategoryValue = '__custom__';
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _merchantController;
  late final TextEditingController _amountController;
  late final TextEditingController _notesController;
  String? _categoryId;
  late DateTime _date;
  bool _saving = false;
  String? _error;

  bool get _editing => widget.expense != null;

  String _validationMessage(
    TransactionValidationException exception,
  ) {
    return switch (exception.failure) {
      TransactionValidationFailure.amountMustBePositive =>
        context.l10n.enterValidAmount,
      TransactionValidationFailure.insufficientBalance =>
        context.l10n.insufficientBalance,
      TransactionValidationFailure.incomeReductionWouldOverdraw =>
        context.l10n.incomeReductionBlocked,
      TransactionValidationFailure.notFound => context.l10n.transactionNotFound,
    };
  }

  @override
  void initState() {
    super.initState();
    final expense = widget.expense;
    _merchantController = TextEditingController(text: expense?.merchant);
    _amountController = TextEditingController(
      text:
          expense == null ? '' : (expense.amountMinor / 100).toStringAsFixed(2),
    );
    _notesController = TextEditingController(text: expense?.description);
    _categoryId = expense?.categoryId;
    _date = expense?.transactedAt ?? DateTime.now();
  }

  @override
  void dispose() {
    _merchantController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _categoryId == null) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final parsedAmount = parseLocalizedAmount(_amountController.text)!;
      final repository = ref.read(expenseRepositoryProvider);
      final onboarding = await ref.read(onboardingControllerProvider.future);
      if (_editing) {
        await repository.update(
          ExpenseRecord(
            id: widget.expense!.id,
            profileId: onboarding.localProfileId,
            type: 'expense',
            amountMinor: (parsedAmount * 100).round(),
            currency: widget.expense!.currency,
            merchant: _merchantController.text.trim(),
            description: _notesController.text.trim(),
            categoryId: _categoryId!,
            transactedAt: _date,
          ),
        );
      } else {
        await repository.create(
          profileId: onboarding.localProfileId,
          amountMinor: (parsedAmount * 100).round(),
          merchant: _merchantController.text,
          description: _notesController.text,
          categoryId: _categoryId!,
          transactedAt: _date,
          type: 'expense',
        );
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.transactionSaved)),
      );
      context.pop(true);
    } on TransactionValidationException catch (exception) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = _validationMessage(exception);
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = context.l10n.databaseError;
        });
      }
    }
  }

  Future<void> _delete() async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteTransactionTitle),
        content: Text(l10n.deleteTransactionMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref.read(expenseRepositoryProvider).delete(widget.expense!.id);
      if (mounted) context.pop(true);
    } on TransactionValidationException catch (exception) {
      if (mounted) {
        setState(() => _error = _validationMessage(exception));
      }
    } catch (_) {
      if (mounted) setState(() => _error = context.l10n.databaseError);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final categories = ref.watch(categoriesProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(_editing ? l10n.editTransaction : l10n.addExpense),
        actions: [
          if (_editing)
            IconButton(
              tooltip: l10n.delete,
              onPressed: _delete,
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              l10n.enterExpenseDetails,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 6),
            Text(l10n.manualExpenseHint),
            const SizedBox(height: 24),
            TextFormField(
              controller: _merchantController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: l10n.merchant,
                prefixIcon: const Icon(Icons.storefront_outlined),
              ),
              validator: (value) =>
                  (value?.trim().isEmpty ?? true) ? l10n.enterMerchant : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: l10n.amount,
                prefixText: '${l10n.currencySar} ',
                prefixIcon: const Icon(Icons.payments_outlined),
              ),
              validator: (value) {
                final amount = parseLocalizedAmount(value ?? '');
                return amount == null || amount <= 0
                    ? l10n.enterValidAmount
                    : null;
              },
            ),
            const SizedBox(height: 14),
            categories.when(
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => Text(l10n.unknownError),
              data: (items) {
                _categoryId ??= items
                    .where((category) => category.systemCode == 'shopping')
                    .firstOrNull
                    ?.id;
                return DropdownButtonFormField<String>(
                  initialValue: items.any((item) => item.id == _categoryId)
                      ? _categoryId
                      : null,
                  decoration: InputDecoration(
                    labelText: l10n.category,
                    prefixIcon: const Icon(Icons.category_outlined),
                  ),
                  items: [
                    ...items.map(
                      (category) => DropdownMenuItem(
                        value: category.id,
                        child: Text(localizedCategoryName(l10n, category)),
                      ),
                    ),
                    DropdownMenuItem(
                      value: _customCategoryValue,
                      child: Text(l10n.customCategory),
                    ),
                  ],
                  onChanged: (value) async {
                    if (value == _customCategoryValue) {
                      final created =
                          await showCustomCategoryDialog(context, ref);
                      if (created != null && mounted) {
                        setState(() => _categoryId = created.id);
                      }
                    } else {
                      setState(() => _categoryId = value);
                    }
                  },
                );
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _notesController,
              minLines: 2,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: l10n.notesOptional,
                prefixIcon: const Icon(Icons.notes),
              ),
            ),
            const SizedBox(height: 14),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              tileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              leading: const Icon(Icons.calendar_today_outlined),
              title: Text(l10n.date),
              subtitle: Text(
                DateFormat.yMd(Localizations.localeOf(context).toLanguageTag())
                    .format(_date),
              ),
              onTap: () async {
                final selected = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (selected != null) setState(() => _date = selected);
              },
            ),
            if (_error != null) ...[
              const SizedBox(height: 14),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check),
              label: Padding(
                padding: const EdgeInsets.all(14),
                child: Text(_saving ? l10n.saving : l10n.save),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
