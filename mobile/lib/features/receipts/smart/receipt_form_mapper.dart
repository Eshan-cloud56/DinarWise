import 'package:dinarwise/features/receipts/smart/receipt_validator.dart';

class ReceiptFormPatch {
  const ReceiptFormPatch(
      {this.merchant,
      this.amount,
      this.paymentMethod,
      this.date,
      this.categoryId,
      required this.issues});
  final String? merchant, amount, paymentMethod, categoryId;
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
    final issues = <ReceiptIssue>{};
    String? amount;
    final total = validator.milli(fields['total'] ?? '', positive: true);
    // The selected app currency labels the existing ledger. Never convert or
    // copy API currency/subtotal/tax/card/invoice/line-item fields into the form.
    if (total != null) {
      if (total % 10 != 0) {
        issues.add(ReceiptIssue.ledgerPrecision);
      } else {
        amount =
            '${total ~/ 1000}.${((total % 1000) ~/ 10).toString().padLeft(2, '0')}';
      }
    }
    final valid = validator
        .validate({'date': fields['date'], 'time': fields['time']}).fields;
    final now = DateTime.now();
    final date = DateTime.tryParse(valid['date'] ?? '') ?? now;
    final time = valid['time']?.split(':');
    return ReceiptFormPatch(
      merchant: fields['merchantName'],
      amount: amount,
      paymentMethod: fields['paymentMethod'],
      date: DateTime(
          date.year,
          date.month,
          date.day,
          time == null ? now.hour : int.parse(time[0]),
          time == null ? now.minute : int.parse(time[1])),
      categoryId: systemCategories[fields['category']],
      issues: issues,
    );
  }
}
