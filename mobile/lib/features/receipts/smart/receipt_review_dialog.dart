import 'package:dinarwise/core/currency/gulf_currency.dart';
import 'package:dinarwise/features/receipts/smart/receipt_validator.dart';
import 'package:dinarwise/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const receiptReviewFields = [
  'merchantName',
  'total',
  'date',
  'time',
  'paymentMethod',
  'category'
];

/// Controllers and focus nodes live until the route's reverse transition ends.
class ReceiptReviewDialog extends StatefulWidget {
  const ReceiptReviewDialog(
      {super.key,
      required this.receipt,
      required this.categoryLabels,
      required this.locale,
      required this.ledgerCurrency});
  final ValidatedReceipt receipt;
  final Map<String, String> categoryLabels;
  final String locale;
  final GulfCurrency ledgerCurrency;
  @override
  State<ReceiptReviewDialog> createState() => _ReceiptReviewDialogState();
}

class _ReceiptReviewDialogState extends State<ReceiptReviewDialog> {
  final _scroll = ScrollController();
  late final Map<String, TextEditingController> _fields;
  late final Map<String, FocusNode> _focus;
  bool _closing = false;

  @override
  void initState() {
    super.initState();
    final valid = ReceiptValidator().validate({
      for (final key in receiptReviewFields) key: widget.receipt.fields[key],
    }).fields;
    final now = DateTime.now();
    final total = ReceiptValidator().milli(valid['total'] ?? '');
    _fields = {
      for (final key in receiptReviewFields)
        key: TextEditingController(
            text: switch (key) {
          'category' => widget.categoryLabels[valid[key]] ?? '',
          'total' => total == null
              ? ''
              : NumberFormat.decimalPatternDigits(
                  locale: widget.locale,
                  decimalDigits:
                      total % 10 == 0 ? widget.ledgerCurrency.decimalDigits : 3,
                ).format(total / 1000),
          'date' => valid[key] ?? DateFormat('yyyy-MM-dd').format(now),
          'time' => valid[key] ?? DateFormat('HH:mm').format(now),
          _ => valid[key] ?? '',
        })
    };
    _focus = {for (final key in receiptReviewFields) key: FocusNode()};
  }

  bool _initializedPayment = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initializedPayment) {
      _initializedPayment = true;
      final payment = _fields['paymentMethod']!.text.trim().toLowerCase();
      if (payment.isEmpty ||
          {'unknown', 'n/a', 'none', 'null', 'غير معروف'}.contains(payment)) {
        _fields['paymentMethod']!.text = context.l10n.receiptTransferred;
      }
    }
  }

  String? get _category {
    final text = _fields['category']!.text.trim().toLowerCase();
    for (final entry in widget.categoryLabels.entries) {
      if (text == entry.key.toLowerCase() ||
          text == entry.value.toLowerCase()) {
        return entry.key;
      }
    }
    return null;
  }

  ValidatedReceipt _values() {
    final now = DateTime.now();
    final valid = ReceiptValidator().validate({
      for (final key in receiptReviewFields) key: _fields[key]!.text.trim(),
      'category': _category,
      'confidence': widget.receipt.confidence,
    });
    return ValidatedReceipt(
        Map.unmodifiable({
          ...valid.fields,
          'date': valid.fields['date'] ?? DateFormat('yyyy-MM-dd').format(now),
          'time': valid.fields['time'] ?? DateFormat('HH:mm').format(now),
          'paymentMethod':
              valid.fields['paymentMethod'] ?? context.l10n.receiptTransferred,
        }),
        const [],
        valid.issues,
        valid.confidence);
  }

  bool get _canApply {
    final valid = _values();
    final amount =
        ReceiptValidator().milli(valid.fields['total'] ?? '', positive: true);
    return valid.fields['merchantName'] != null &&
        _category != null &&
        amount != null &&
        amount % 10 == 0;
  }

  void _close({bool apply = false}) {
    if (_closing || (apply && !_canApply)) return;
    _closing = true;
    final result = apply ? _values() : null;
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop(result);
  }

  @override
  void dispose() {
    for (final value in _fields.values) {
      value.dispose();
    }
    for (final value in _focus.values) {
      value.dispose();
    }
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(context.l10n.reviewReceiptDetails),
        content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              controller: _scroll,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                for (final key in receiptReviewFields)
                  Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: TextField(
                        key: ValueKey('receiptReview_$key'),
                        controller: _fields[key],
                        focusNode: _focus[key],
                        scrollPadding: const EdgeInsets.all(24),
                        onChanged: (_) => setState(() {}),
                        keyboardType: key == 'total'
                            ? const TextInputType.numberWithOptions(
                                decimal: true)
                            : TextInputType.text,
                        decoration: InputDecoration(
                          labelText: '${_label(context, key)}${{
                            'merchantName',
                            'total',
                            'category'
                          }.contains(key) ? ' *' : ''}',
                          prefixText: key == 'total'
                              ? '${widget.ledgerCurrency.code} '
                              : null,
                          helperText: key == 'total' &&
                                  (ReceiptValidator()
                                                  .milli(_fields[key]!.text) ??
                                              0) %
                                          10 !=
                                      0
                              ? context.l10n.receiptLedgerPrecision
                              : null,
                          suffixIcon: key == 'category'
                              ? PopupMenuButton<String>(
                                  tooltip: context.l10n.category,
                                  onSelected: (value) => setState(() =>
                                      _fields[key]!.text =
                                          widget.categoryLabels[value]!),
                                  itemBuilder: (_) => [
                                    for (final entry
                                        in widget.categoryLabels.entries)
                                      PopupMenuItem(
                                          value: entry.key,
                                          child: Text(entry.value))
                                  ],
                                )
                              : null,
                        ),
                      )),
              ]),
            )),
        actions: [
          TextButton(onPressed: _close, child: Text(context.l10n.cancel)),
          FilledButton(
              key: const ValueKey('receiptReview_apply'),
              onPressed: _canApply ? () => _close(apply: true) : null,
              child: Text(context.l10n.useDetectedDetails)),
        ],
      );
}

String _label(BuildContext context, String key) => switch (key) {
      'merchantName' => context.l10n.merchant,
      'total' => context.l10n.receiptTotal,
      'date' => context.l10n.date,
      'time' => context.l10n.receiptTime,
      'paymentMethod' => context.l10n.paymentMethod,
      'category' => context.l10n.category,
      _ => key,
    };
