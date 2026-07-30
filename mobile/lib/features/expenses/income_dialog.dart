import 'package:dinarwise/features/expenses/amount_parser.dart';
import 'package:dinarwise/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';

class IncomeDialogResult {
  const IncomeDialogResult.save(this.amount) : delete = false;
  const IncomeDialogResult.delete()
      : amount = null,
        delete = true;

  final double? amount;
  final bool delete;
}

Future<IncomeDialogResult?> showIncomeDialog(
  BuildContext context, {
  double? initialAmount,
  String currencyCode = 'SAR',
  int decimalDigits = 2,
}) {
  return showDialog<IncomeDialogResult>(
    context: context,
    builder: (_) => _IncomeDialog(
      initialAmount: initialAmount,
      currencyCode: currencyCode,
      decimalDigits: decimalDigits,
    ),
  );
}

class _IncomeDialog extends StatefulWidget {
  const _IncomeDialog({
    this.initialAmount,
    required this.currencyCode,
    required this.decimalDigits,
  });

  final double? initialAmount;
  final String currencyCode;
  final int decimalDigits;

  @override
  State<_IncomeDialog> createState() => _IncomeDialogState();
}

class _IncomeDialogState extends State<_IncomeDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;

  bool get _editing => widget.initialAmount != null;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialAmount?.toStringAsFixed(widget.decimalDigits) ?? '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      icon: const Icon(Icons.add_card_rounded),
      title: Text(_editing ? l10n.editIncome : l10n.addIncome),
      content: Form(
        key: _formKey,
        child: TextFormField(
          key: const ValueKey('incomeAmountField'),
          controller: _controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: l10n.incomeAmount,
            prefixText: '${widget.currencyCode} ',
            prefixIcon: const Icon(Icons.payments_outlined),
          ),
          validator: (value) {
            final amount = parseLocalizedAmount(value ?? '');
            return amount == null || amount <= 0 ? l10n.enterValidAmount : null;
          },
        ),
      ),
      actions: [
        if (_editing)
          TextButton(
            onPressed: () => Navigator.pop(
              context,
              const IncomeDialogResult.delete(),
            ),
            child: Text(
              l10n.delete,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            Navigator.pop(
              context,
              IncomeDialogResult.save(
                parseLocalizedAmount(_controller.text)!,
              ),
            );
          },
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
