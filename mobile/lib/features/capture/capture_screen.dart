import 'dart:io';
import 'dart:async';
import 'package:dinarwise/core/theme.dart';
import 'package:dinarwise/core/widgets/dinar_widgets.dart';
import 'package:dinarwise/features/expenses/income_actions.dart';

import 'package:dinarwise/core/analytics/analytics_service.dart';
import 'package:dinarwise/core/currency/gulf_currency.dart';
import 'package:dinarwise/core/diagnostics/crash_reporting_service.dart';
import 'package:dinarwise/core/preferences/onboarding_controller.dart';
import 'package:dinarwise/features/categories/category_localization.dart';
import 'package:dinarwise/features/categories/data/category_repository.dart';
import 'package:dinarwise/features/categories/custom_category_dialog.dart';
import 'package:dinarwise/features/expenses/amount_parser.dart';
import 'package:dinarwise/features/expenses/data/expense_providers.dart';
import 'package:dinarwise/features/expenses/data/expense_repository.dart';
import 'package:dinarwise/l10n/l10n_extension.dart';
import 'package:dinarwise/features/payment_methods/payment_method_providers.dart';
import 'package:dinarwise/features/receipts/receipt_providers.dart';
import 'package:dinarwise/features/receipts/receipt_viewer.dart';
import 'package:dinarwise/features/receipts/smart/gemma_receipt_service.dart';
import 'package:dinarwise/features/receipts/smart/receipt_form_mapper.dart';
import 'package:dinarwise/features/receipts/smart/receipt_ocr_service.dart';
import 'package:dinarwise/features/receipts/smart/receipt_scan_service.dart';
import 'package:dinarwise/features/receipts/smart/receipt_validator.dart';
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
  bool _scanningReceipt = false;
  String? _scanError;

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
    } else if (_pendingReceiptPath != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _scanReceipt(_pendingReceiptPath!, ReceiptScript.auto);
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
      final picked =
          await ref.read(receiptScanServiceProvider).images.pick(source);
      if (picked != null && mounted) {
        setState(() {
          _pendingReceiptPath = picked;
          _scanError = null;
        });
        await _scanReceipt(picked, ReceiptScript.auto);
      }
    } catch (_) {
      if (mounted) setState(() => _error = context.l10n.receiptPickError);
    }
  }

  Future<void> _scanReceipt(String path, ReceiptScript script) async {
    final gemma = ref.read(receiptScanServiceProvider).gemma;
    final state = await gemma.status();
    if (!mounted) return;
    if (state != GemmaModelState.ready) {
      await _showModelSetup(gemma, state);
      if (!mounted || await gemma.status() != GemmaModelState.ready) return;
    }
    setState(() {
      _scanningReceipt = true;
      _scanError = null;
    });
    try {
      final categories = await ref.read(categoriesProvider.future);
      final systemCodes = categories
          .where((item) => item.isSystem && item.systemCode != null)
          .map((item) => item.systemCode!);
      final result = await ref.read(receiptScanServiceProvider).scan(
            path,
            script,
            systemCodes,
          );
      if (!mounted) return;
      await _reviewReceipt(result, categories);
    } catch (_) {
      if (mounted) setState(() => _scanError = context.l10n.smartScanFailed);
    } finally {
      if (mounted) setState(() => _scanningReceipt = false);
    }
  }

  Future<void> _showModelSetup(
    GemmaReceiptService gemma,
    GemmaModelState state,
  ) async {
    var importing = false;
    double? progress;
    StreamSubscription<double?>? subscription;
    try {
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: Text(context.l10n.smartReceiptModel),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (importing) LinearProgressIndicator(value: progress),
                const SizedBox(height: 12),
                Text(
                  state == GemmaModelState.unconfigured
                      ? context.l10n.smartReceiptModelNotConfigured
                      : state == GemmaModelState.unsupported
                          ? context.l10n.smartReceiptUnsupported
                          : context.l10n.smartReceiptModelRequired,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: importing ? null : () => Navigator.pop(context),
                child: Text(context.l10n.manualEntry),
              ),
              if (state == GemmaModelState.missing && gemma.canImportModel)
                FilledButton(
                  onPressed: importing
                      ? null
                      : () async {
                          setDialogState(() => importing = true);
                          subscription = gemma.importProgress.listen((value) {
                            if (dialogContext.mounted) {
                              setDialogState(() => progress = value);
                            }
                          });
                          try {
                            await gemma.importModel();
                            if (dialogContext.mounted) {
                              Navigator.pop(dialogContext);
                            }
                          } catch (_) {
                            if (dialogContext.mounted) {
                              setDialogState(() => importing = false);
                              ScaffoldMessenger.of(dialogContext).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    dialogContext.l10n.smartReceiptModelError,
                                  ),
                                ),
                              );
                            }
                          }
                        },
                  child: Text(context.l10n.importModel),
                ),
            ],
          ),
        ),
      );
    } finally {
      await subscription?.cancel();
    }
  }

  Future<void> _reviewReceipt(
    ValidatedReceipt initial,
    List<CategoryRecord> categories,
  ) async {
    final fields = <String, TextEditingController>{
      for (final key in receiptFields)
        key: TextEditingController(text: initial.fields[key] ?? ''),
    };
    final lineItems = TextEditingController(
      text: initial.lineItems
          .map((item) =>
              item.total == null ? item.name : '${item.name} — ${item.total}')
          .join('\n'),
    );
    try {
      final accepted = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(context.l10n.reviewReceiptDetails),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (final entry in fields.entries)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextField(
                        controller: entry.value,
                        keyboardType: const {
                          'total',
                          'subtotal',
                          'tax',
                          'cardLastFour',
                        }.contains(entry.key)
                            ? const TextInputType.numberWithOptions(
                                decimal: true)
                            : null,
                        decoration: InputDecoration(
                          labelText: _receiptFieldLabel(context, entry.key),
                        ),
                      ),
                    ),
                  if (lineItems.text.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextField(
                        controller: lineItems,
                        minLines: 2,
                        maxLines: 8,
                        decoration: InputDecoration(
                          labelText: context.l10n.receiptLineItems,
                        ),
                      ),
                    ),
                  if (initial.confidence < .85)
                    Text(
                      context.l10n.lowConfidenceReview,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(context.l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(context.l10n.useDetectedDetails),
            ),
          ],
        ),
      );
      if (accepted != true || !mounted) return;
      final result = ReceiptValidator().validate({
        for (final entry in fields.entries)
          if (entry.value.text.trim().isNotEmpty)
            entry.key: entry.value.text.trim(),
        'confidence': initial.confidence,
        'lineItems': [
          for (final line in lineItems.text.split('\n'))
            if (line.trim().isNotEmpty) {'name': line.trim()},
        ],
      });
      final categoryMap = {
        for (final item in categories)
          if (item.isSystem && item.systemCode != null)
            item.systemCode!: item.id,
      };
      final patch = ReceiptFormMapper().map(
        result,
        ledgerCurrency: _currency.code,
        systemCategories: categoryMap,
      );
      setState(() {
        if (patch.merchant?.isNotEmpty == true) {
          _merchantController.text = patch.merchant!;
        }
        if (patch.amount != null) _amountController.text = patch.amount!;
        if (patch.notes?.isNotEmpty == true && _notesController.text.isEmpty) {
          _notesController.text = patch.notes!;
        }
        if (patch.date != null) _date = patch.date!;
        if (patch.categoryId != null) _categoryId = patch.categoryId;
        _scanError = patch.issues.contains(ReceiptIssue.differentCurrency)
            ? context.l10n.detectedCurrencyMismatch
            : patch.issues.contains(ReceiptIssue.inconsistentTotal)
                ? context.l10n.receiptTotalsInconsistent
                : null;
      });
    } finally {
      for (final controller in fields.values) {
        controller.dispose();
      }
      lineItems.dispose();
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
        _scanError = null;
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

  void _keypad(String digit) {
    final text = _amountController.text;
    String next;
    if (digit == 'back') {
      next = text.isEmpty ? '' : text.substring(0, text.length - 1);
    } else if (digit == '.') {
      if (text.contains('.') || text.contains('٫')) return;
      next = text.isEmpty ? '0.' : '$text.';
    } else {
      if (text.length >= 14) return;
      next = text == '0' ? digit : '$text$digit';
    }
    setState(() {
      _amountController.text = next;
      _amountController.selection =
          TextSelection.collapsed(offset: next.length);
    });
  }

  Future<void> _chooseDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (selected != null && mounted) setState(() => _date = selected);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final categories = ref.watch(categoriesProvider);
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Image.asset('assets/branding/stitch-logo.png', width: 32, height: 32),
          const SizedBox(width: 10),
          Expanded(
              child: Text(_editing ? l10n.editTransaction : l10n.addTransaction,
                  maxLines: 2)),
        ]),
        actions: [
          if (_editing)
            IconButton(
                tooltip: l10n.delete,
                onPressed: _delete,
                icon: const Icon(Icons.delete_outline)),
        ],
      ),
      body: SafeArea(
          top: false,
          child: Form(
            key: _formKey,
            child: ListView(padding: const EdgeInsets.all(20), children: [
              if (!_editing)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Wrap(spacing: 8, runSpacing: 8, children: [
                    ChoiceChip(
                        label: Text(l10n.expense),
                        selected: true,
                        avatar: const Icon(Icons.south),
                        onSelected: (_) {}),
                    ActionChip(
                        label: Text(l10n.income),
                        avatar: const Icon(Icons.north),
                        onPressed: () => manageIncome(context, ref)),
                    ActionChip(
                        label: Text(l10n.transferLabel),
                        avatar: const Icon(Icons.sync_alt),
                        onPressed: () => showTransferUnavailable(context)),
                  ]),
                ),
              DinarCard(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Column(children: [
                    Chip(
                        label: Text(_currency.code),
                        avatar: const Icon(Icons.payments_outlined, size: 18)),
                    const SizedBox(height: 12),
                    TextFormField(
                      key: const ValueKey('expenseAmountField'),
                      controller: _amountController,
                      keyboardType: TextInputType.none,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 42,
                          fontWeight: FontWeight.w800),
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                          labelText: l10n.amount,
                          hintText: '0.00',
                          fillColor: Colors.white),
                      validator: (value) {
                        final amount = parseLocalizedAmount(value ?? '');
                        return amount == null || amount <= 0
                            ? l10n.enterValidAmount
                            : null;
                      },
                    ),
                  ])),
              const SizedBox(height: 18),
              DinarCard(
                  padding: const EdgeInsets.all(10),
                  child: LayoutBuilder(builder: (context, constraints) {
                    final height =
                        MediaQuery.textScalerOf(context).scale(24) + 28;
                    return GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio:
                          ((constraints.maxWidth - 16) / 3) / height,
                      children: [
                        for (final digit in [
                          '1',
                          '2',
                          '3',
                          '4',
                          '5',
                          '6',
                          '7',
                          '8',
                          '9',
                          '.',
                          '0',
                          'back'
                        ])
                          Semantics(
                            button: true,
                            label:
                                digit == 'back' ? l10n.backspaceLabel : digit,
                            child: FilledButton.tonal(
                              key: ValueKey('keypad-$digit'),
                              style: FilledButton.styleFrom(
                                  backgroundColor: DinarColors.inset,
                                  foregroundColor: DinarColors.ink,
                                  padding: EdgeInsets.zero),
                              onPressed: _saving ? null : () => _keypad(digit),
                              child: digit == 'back'
                                  ? const Icon(Icons.backspace_outlined)
                                  : Text(digit,
                                      style: const TextStyle(
                                          fontSize: 26,
                                          fontFamily: 'PlusJakartaSans')),
                            ),
                          ),
                      ],
                    );
                  })),
              const SizedBox(height: 18),
              categories.when(
                loading: () => const LinearProgressIndicator(),
                error: (_, __) => Text(l10n.unknownError),
                data: (items) {
                  _categoryId ??= items
                      .where((category) => category.systemCode == 'shopping')
                      .firstOrNull
                      ?.id;
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.category,
                            style: Theme.of(context).textTheme.labelLarge),
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(children: [
                              for (final category in items)
                                Padding(
                                  padding:
                                      const EdgeInsetsDirectional.only(end: 8),
                                  child: ChoiceChip(
                                    label: Text(
                                        localizedCategoryName(l10n, category)),
                                    avatar: Icon(
                                        categoryIcon(category.systemCode),
                                        size: 19),
                                    selected: _categoryId == category.id,
                                    selectedColor: const Color(0xFFFFDEA5),
                                    onSelected: (_) => setState(
                                        () => _categoryId = category.id),
                                  ),
                                ),
                              ActionChip(
                                  label: Text(l10n.customCategory),
                                  avatar: const Icon(Icons.add, size: 18),
                                  onPressed: () async {
                                    final created =
                                        await showCustomCategoryDialog(
                                            context, ref);
                                    if (created != null && mounted) {
                                      setState(() => _categoryId = created.id);
                                    }
                                  }),
                            ])),
                      ]);
                },
              ),
              const SizedBox(height: 18),
              DinarCard(
                  child: Column(children: [
                TextFormField(
                  key: const ValueKey('expenseMerchantField'),
                  controller: _merchantController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      labelText: l10n.merchant,
                      prefixIcon: const Icon(Icons.storefront_outlined)),
                  validator: (value) => (value?.trim().isEmpty ?? true)
                      ? l10n.enterMerchant
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _notesController,
                  minLines: 1,
                  maxLines: 4,
                  decoration: InputDecoration(
                      labelText: l10n.notesOptional,
                      prefixIcon: const Icon(Icons.notes)),
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.schedule),
                  title: Text(l10n.date),
                  subtitle: Text(DateFormat.yMMMEd(
                          Localizations.localeOf(context).toLanguageTag())
                      .format(_date)),
                  onTap: _chooseDate,
                ),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  OutlinedButton(
                      onPressed: () => setState(() => _date = DateTime.now()),
                      child: Text(l10n.today)),
                  OutlinedButton(
                      onPressed: () => setState(() => _date =
                          DateTime.now().subtract(const Duration(days: 1))),
                      child: Text(l10n.yesterday)),
                  OutlinedButton.icon(
                      onPressed: _chooseDate,
                      icon: const Icon(Icons.calendar_month_outlined, size: 18),
                      label: Text(l10n.date)),
                ]),
                const SizedBox(height: 12),
                Consumer(builder: (context, ref, _) {
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
                        isExpanded: true,
                        initialValue:
                            items.any((item) => item.id == _paymentMethodId)
                                ? _paymentMethodId
                                : null,
                        decoration: InputDecoration(
                            labelText: l10n.paymentMethod,
                            prefixIcon: const Icon(
                                Icons.account_balance_wallet_outlined)),
                        items: items
                            .map((method) => DropdownMenuItem(
                                value: method.id,
                                child: Text(_paymentMethodLabel(
                                    context, method.systemCode, method.name))))
                            .toList(),
                        onChanged: (value) =>
                            setState(() => _paymentMethodId = value),
                      );
                    },
                  );
                }),
                const SizedBox(height: 10),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.call_split),
                  title: Text(l10n.splitBnplLabel),
                  subtitle: Text(l10n.manageBnplHint,
                      style: const TextStyle(fontSize: 11)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/planning/bnpl'),
                ),
                const SizedBox(height: 10),
                _ReceiptAttachmentCard(
                    filePath: _pendingReceiptPath ?? _storedReceiptPath,
                    onAdd: _showReceiptSource,
                    onRemove: _removeReceipt,
                    scanning: _scanningReceipt,
                    scanError: _scanError,
                    onScan: (script) {
                      final path = _pendingReceiptPath ?? _storedReceiptPath;
                      if (path != null) _scanReceipt(path, script);
                    }),
                const SizedBox(height: 8),
                Text(l10n.manualReceiptHint,
                    style:
                        const TextStyle(fontSize: 11, color: DinarColors.muted),
                    textAlign: TextAlign.center),
              ])),
              const SizedBox(height: 18),
              if (_error != null)
                Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: Text(_error!,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error),
                        textAlign: TextAlign.center)),
              const SizedBox(height: 20),
              FilledButton.icon(
                key: const ValueKey('saveExpenseButton'),
                onPressed: _saving ? null : _save,
                icon: _saving
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.check_circle_outline),
                label: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                        _saving
                            ? l10n.saving
                            : '${l10n.saveExpenseLabel} (${_currency.formatter(Localizations.localeOf(context).toLanguageTag()).format(parseLocalizedAmount(_amountController.text) ?? 0)})',
                        textAlign: TextAlign.center)),
              ),
            ]),
          )),
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

String _receiptFieldLabel(BuildContext context, String key) => switch (key) {
      'merchantName' => context.l10n.merchant,
      'total' => context.l10n.receiptTotal,
      'subtotal' => context.l10n.receiptSubtotal,
      'tax' => context.l10n.receiptTax,
      'currency' => context.l10n.receiptCurrency,
      'date' => context.l10n.date,
      'time' => context.l10n.receiptTime,
      'paymentMethod' => context.l10n.paymentMethod,
      'cardLastFour' => context.l10n.cardLastFour,
      'invoiceNumber' => context.l10n.invoiceNumber,
      'category' => context.l10n.category,
      _ => key,
    };

class _ReceiptAttachmentCard extends StatelessWidget {
  const _ReceiptAttachmentCard({
    required this.filePath,
    required this.onAdd,
    required this.onRemove,
    required this.onScan,
    required this.scanning,
    required this.scanError,
  });

  final String? filePath;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final ValueChanged<ReceiptScript> onScan;
  final bool scanning;
  final String? scanError;

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
      child: Column(
        children: [
          Row(children: [
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
          ]),
          if (scanning) ...[
            const LinearProgressIndicator(),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(context.l10n.processingReceipt),
            ),
          ] else
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  FilledButton.tonalIcon(
                    key: const ValueKey('scanReceiptAuto'),
                    onPressed: () => onScan(ReceiptScript.auto),
                    icon: const Icon(Icons.document_scanner_outlined),
                    label: Text(context.l10n.smartScan),
                  ),
                  OutlinedButton(
                    key: const ValueKey('scanReceiptArabic'),
                    onPressed: () => onScan(ReceiptScript.arabic),
                    child: Text(context.l10n.arabicMixedReceipt),
                  ),
                ],
              ),
            ),
          if (scanError != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Text(
                scanError!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}
