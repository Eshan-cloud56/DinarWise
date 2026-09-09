import 'package:dinarwise/features/receipts/smart/receipt_validator.dart';

class ReceiptFormPatch {
  const ReceiptFormPatch(
      {this.merchant,
      this.amount,
      this.notes,
      this.date,
      this.categoryId,
      required this.issues});
  final String? merchant, amount, notes, categoryId;
  final DateTime? date;
  final Set<ReceiptIssue> issues;
  // Intentionally no account/paymentMethodId: existing database has no card IDs.
}

class ReceiptFormMapper {
  ReceiptFormPatch map(
    ValidatedReceipt receipt, {
    required String ledgerCurrency,
    required Map<String, String> systemCategories,
  }) {
    final validator = ReceiptValidator();
    final fields = receipt.fields;
    final issues = {...receipt.issues};
    String? amount;
    final total = validator.milli(fields['total'] ?? '', positive: true);
    if (fields['currency'] != ledgerCurrency) {
      issues.add(ReceiptIssue.differentCurrency);
    } else if (total != null) {
      if (total % 10 != 0) {
        issues.add(ReceiptIssue.ledgerPrecision);
      } else if (!issues.contains(ReceiptIssue.inconsistentTotal)) {
        amount =
            '${total ~/ 1000}.${((total % 1000) ~/ 10).toString().padLeft(2, '0')}';
      }
    }
    final date = DateTime.tryParse(fields['date'] ?? '');
    final time = fields['time']?.split(':');
    return ReceiptFormPatch(
      merchant: fields['merchantName'],
      amount: amount,
      notes: receipt.lineItems.isEmpty
          ? null
          : receipt.lineItems
              .map((item) => item.total == null
                  ? item.name
                  : '${item.name} — ${item.total}')
              .join('\n'),
      date: date == null
          ? null
          : DateTime(
              date.year,
              date.month,
              date.day,
              time == null ? 0 : int.parse(time[0]),
              time == null ? 0 : int.parse(time[1])),
      categoryId: systemCategories[fields['category']],
      issues: issues,
    );
  }
}
