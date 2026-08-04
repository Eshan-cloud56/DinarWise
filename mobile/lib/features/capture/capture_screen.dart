import 'dart:io';

import 'package:dinarwise/core/analytics/analytics_service.dart';
import 'package:dinarwise/core/currency/gulf_currency.dart';
import 'package:dinarwise/core/diagnostics/crash_reporting_service.dart';
import 'package:dinarwise/core/preferences/onboarding_controller.dart';
import 'package:dinarwise/features/categories/category_localization.dart';
import 'package:dinarwise/features/categories/custom_category_dialog.dart';
import 'package:dinarwise/features/expenses/amount_parser.dart';
import 'package:dinarwise/features/expenses/data/expense_providers.dart';
import 'package:dinarwise/features/expenses/data/expense_repository.dart';
import 'package:dinarwise/l10n/l10n_extension.dart';
import 'package:dinarwise/features/payment_methods/payment_method_providers.dart';
import 'package:dinarwise/features/receipts/receipt_providers.dart';
import 'package:dinarwise/features/receipts/receipt_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class CaptureLaunchArgs {
  const CaptureLaunchArgs({this.expense, this.sharedReceiptPath});

  final ExpenseRecord? expense;
  final String? sharedReceiptPath;
}

class CaptureScreen extends ConsumerStatefulWidget {
  const CaptureScreen({this.expense, this.sharedReceiptPath, super.key});

  final ExpenseRecord? expense;
  final String? sharedReceiptPath;

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
  String? _paymentMethodId;
  late DateTime _date;
  bool _saving = false;
  String? _error;
  late final GulfCurrency _currency;
  String? _pendingReceiptPath;
  String? _storedReceiptPath;

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
    _currency = GulfCurrency.fromCode(
      ref.read(onboardingControllerProvider).requireValue.currencyCode,
    );
    _merchantController = TextEditingController(text: expense?.merchant);
    _amountController = TextEditingController(
      text: expense == null
          ? ''
          : _currency
              .toMajor(expense.amountMinor)
              .toStringAsFixed(_currency.decimalDigits),
    );
    _notesController = TextEditingController(text: expense?.description);
    _categoryId = expense?.categoryId;
    _paymentMethodId = expense?.paymentMethodId;
    _date = expense?.transactedAt ?? DateTime.now();
    _pendingReceiptPath = widget.sharedReceiptPath;
    final analytics = ref.read(analyticsServiceProvider);
    analytics.screen(_editing ? 'edit_expense' : 'add_expense');
    if (!_editing) analytics.expenseAddStarted();
    if (expense != null) {
      Future<void>(() async {
        final receipt = await ref
            .read(receiptRepositoryProvider)
            .forTransaction(expense.id);
        if (mounted) setState(() => _storedReceiptPath = receipt?.filePath);
      });
    }
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
      late final String transactionId;
      if (_editing) {
        transactionId = widget.expense!.id;
        await repository.update(
          ExpenseRecord(
            id: widget.expense!.id,
            profileId: onboarding.localProfileId,
            type: 'expense',
            amountMinor: _currency.toMinor(parsedAmount),
            currency: _currency.code,
            merchant: _merchantController.text.trim(),
            description: _notesController.text.trim(),
            categoryId: _categoryId!,
            transactedAt: _date,
            paymentMethodId: _paymentMethodId,
            receiptAttachmentId: widget.expense!.receiptAttachmentId,
          ),
        );
      } else {
        transactionId = await repository.create(
          profileId: onboarding.localProfileId,
          amountMinor: _currency.toMinor(parsedAmount),
          merchant: _merchantController.text,
          description: _notesController.text,
          categoryId: _categoryId!,
          transactedAt: _date,
          type: 'expense',
          paymentMethodId: _paymentMethodId,
          currency: _currency.code,
        );
      }
      if (_pendingReceiptPath != null) {
        await ref.read(receiptRepositoryProvider).attach(
              profileId: onboarding.localProfileId,
              transactionId: transactionId,
              sourcePath: _pendingReceiptPath!,
            );
      }
      final category = (await ref.read(categoriesProvider.future))
          .firstWhere((item) => item.id == _categoryId);
      ref.read(analyticsServiceProvider).expenseSaved(
            edited: _editing,
            categoryType:
                category.isSystem ? (category.systemCode ?? 'other') : 'custom',
            currency: _currency.code,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.transactionSaved)),
      );
      context.pop(true);
    } on TransactionValidationException catch (exception) {
      ref.read(analyticsServiceProvider).expenseFailed(
            _editing ? 'edit' : 'add',
            switch (exception.failure) {
              TransactionValidationFailure.amountMustBePositive =>
                'invalid_amount',
              TransactionValidationFailure.insufficientBalance =>
                'insufficient_balance',
              TransactionValidationFailure.incomeReductionWouldOverdraw =>
                'insufficient_balance',
              TransactionValidationFailure.notFound => 'database_error',
            },
          );
      if (mounted) {
        setState(() {
          _saving = false;
          _error = _validationMessage(exception);
        });
      }
    } catch (_, stack) {
      ref
          .read(analyticsServiceProvider)
          .expenseFailed(_editing ? 'edit' : 'add', 'database_error');
      ref.read(crashReportingServiceProvider)
        ..setSafeContext(
          screen: _editing ? 'edit_expense' : 'add_expense',
          operation: _editing ? 'expense_update' : 'expense_create',
        )
        ..recordUnexpected(
          StateError(
              _editing ? 'expense_update_failed' : 'expense_create_failed'),
          stack,
        );
      if (mounted) {
        setState(() {
          _saving = false;
          _error = context.l10n.databaseError;
        });
      }
    }
  }

  Future<void> _pickReceipt(ImageSource source) async {
    try {
      final picked = await ImagePicker().pickImage(source: source);
      if (picked != null && mounted) {
        setState(() => _pendingReceiptPath = picked.path);
      }
    } catch (_) {
      if (mounted) setState(() => _error = context.l10n.receiptPickError);
    }
  }

  Future<void> _removeReceipt() async {
    if (_editing && _storedReceiptPath != null) {
      await ref
          .read(receiptRepositoryProvider)
          .removeForTransaction(widget.expense!.id);
    }
    if (mounted) {
      setState(() {
        _pendingReceiptPath = null;
        _storedReceiptPath = null;
      });
      ref.invalidate(receiptStorageProvider);
    }
  }

  void _showReceiptSource() {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(context.l10n.takeReceiptPhoto),
              onTap: () {
                Navigator.pop(context);
                _pickReceipt(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(context.l10n.chooseReceiptPhoto),
              onTap: () {
                Navigator.pop(context);
                _pickReceipt(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
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
      final categories = await ref.read(categoriesProvider.future);
      final category = categories
          .where((item) => item.id == widget.expense!.categoryId)
          .firstOrNull;
      ref.read(analyticsServiceProvider).expenseDeleted(
            category?.isSystem == true
                ? (category?.systemCode ?? 'other')
                : 'custom',
            _currency.code,
          );
      if (mounted) context.pop(true);
    } on TransactionValidationException catch (exception) {
      if (mounted) {
        setState(() => _error = _validationMessage(exception));
      }
    } catch (_, stack) {
      ref
          .read(analyticsServiceProvider)
          .expenseFailed('delete', 'database_error');
      ref.read(crashReportingServiceProvider)
        ..setSafeContext(screen: 'edit_expense', operation: 'expense_delete')
        ..recordUnexpected(StateError('expense_delete_failed'), stack);
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
            Consumer(
              builder: (context, ref, _) {
                final methods = ref.watch(paymentMethodsProvider);
                return methods.when(
                  loading: () => const LinearProgressIndicator(),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (items) {
                    _paymentMethodId ??= items
                        .where((method) => method.isDefault)
                        .firstOrNull
                        ?.id;
                    return DropdownButtonFormField<String>(
                      initialValue:
                          items.any((item) => item.id == _paymentMethodId)
                              ? _paymentMethodId
                              : null,
                      decoration: InputDecoration(
                        labelText: l10n.paymentMethod,
                        prefixIcon: const Icon(Icons.account_balance_wallet),
                      ),
                      items: items
                          .map(
                            (method) => DropdownMenuItem(
                              value: method.id,
                              child: Text(
                                _paymentMethodLabel(
                                    context, method.systemCode, method.name),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _paymentMethodId = value),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: l10n.amount,
                prefixText: '${_currency.code} ',
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
            const SizedBox(height: 14),
            _ReceiptAttachmentCard(
              filePath: _pendingReceiptPath ?? _storedReceiptPath,
              onAdd: _showReceiptSource,
              onRemove: _removeReceipt,
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

String _paymentMethodLabel(
  BuildContext context,
  String? code,
  String fallback,
) =>
    switch (code) {
      'cash' => context.l10n.cash,
      'debit_card' => context.l10n.debitCard,
      'credit_card' => context.l10n.creditCard,
      'bank_transfer' => context.l10n.bankTransfer,
      'mada' => 'Mada',
      'stc_pay' => 'STC Pay',
      'google_pay' => 'Google Pay',
      'tabby' => 'Tabby',
      'tamara' => 'Tamara',
      'other' => context.l10n.other,
      _ => fallback,
    };

class _ReceiptAttachmentCard extends StatelessWidget {
  const _ReceiptAttachmentCard({
    required this.filePath,
    required this.onAdd,
    required this.onRemove,
  });

  final String? filePath;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final path = filePath;
    if (path == null) {
      return OutlinedButton.icon(
        onPressed: onAdd,
        icon: const Icon(Icons.receipt_long_outlined),
        label: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(context.l10n.attachReceipt),
        ),
      );
    }
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => ReceiptViewer(filePath: path),
              ),
            ),
            child: Image.file(
              File(path),
              width: 96,
              height: 96,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: ListTile(
              title: Text(context.l10n.receiptAttached),
              subtitle: Text(context.l10n.tapToView),
              onTap: onAdd,
            ),
          ),
          IconButton(
            tooltip: context.l10n.removeReceipt,
            onPressed: onRemove,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
    );
  }
}
