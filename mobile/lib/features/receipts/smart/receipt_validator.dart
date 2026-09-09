import 'dart:convert';

const receiptCurrencies = {'SAR', 'AED', 'KWD', 'BHD', 'QAR', 'OMR'};
const receiptFields = [
  'merchantName',
  'total',
  'subtotal',
  'tax',
  'currency',
  'date',
  'time',
  'paymentMethod',
  'cardLastFour',
  'invoiceNumber',
  'category',
];

enum ReceiptIssue {
  invalidField,
  lowConfidence,
  inconsistentTotal,
  differentCurrency,
  ledgerPrecision
}

/// Receipt values stay in memory. Never serialize this object to telemetry.
class ValidatedReceipt {
  const ValidatedReceipt(
      this.fields, this.lineItems, this.issues, this.confidence);
  final Map<String, String> fields;
  final List<ReceiptLineItem> lineItems;
  final Set<ReceiptIssue> issues;
  final double confidence;
}

class ReceiptLineItem {
  const ReceiptLineItem(this.name, this.total);
  final String name;
  final String? total;
}

class ReceiptValidator {
  String normalizeDigits(String value) {
    const arabic = '٠١٢٣٤٥٦٧٨٩';
    const persian = '۰۱۲۳۴۵۶۷۸۹';
    for (var i = 0; i < 10; i++) {
      value = value.replaceAll(arabic[i], '$i').replaceAll(persian[i], '$i');
    }
    return value.replaceAll('٫', '.').replaceAll('٬', ',');
  }

  /// Exact thousandths for comparison; no floating-point financial accounting.
  int? milli(String value, {bool positive = false}) {
    final normalized = normalizeDigits(value.trim());
    if (!RegExp(r'^(?:[0-9]+|[0-9]{1,3}(?:,[0-9]{3})+)(?:\.[0-9]{1,3})?$')
        .hasMatch(normalized)) {
      return null;
    }
    final parts = normalized.replaceAll(',', '').split('.');
    if (parts[0].length > 10) return null;
    final result = int.parse(parts[0]) * 1000 +
        int.parse((parts.length == 2 ? parts[1] : '').padRight(3, '0'));
    return positive && result == 0 ? null : result;
  }

  String canonical(int value) =>
      '${value ~/ 1000}.${(value % 1000).toString().padLeft(3, '0')}';

  ValidatedReceipt parse(String output) {
    if (output.length > 16000) throw const FormatException('receipt_invalid');
    var text = output.trim();
    if (text.startsWith('```json') && text.endsWith('```')) {
      text = text.substring(7, text.length - 3).trim();
    }
    final decoded = jsonDecode(text);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('receipt_invalid');
    }
    return validate(decoded);
  }

  ValidatedReceipt validate(Map<String, dynamic> input) {
    final fields = <String, String>{};
    final issues = <ReceiptIssue>{};
    final lineItems = <ReceiptLineItem>[];
    final rawItems = input['lineItems'];
    if (rawItems != null) {
      if (rawItems is! List || rawItems.length > 30) {
        issues.add(ReceiptIssue.invalidField);
      } else {
        for (final item in rawItems) {
          if (item is! Map || item['name'] is! String) {
            issues.add(ReceiptIssue.invalidField);
            continue;
          }
          final name = (item['name'] as String).trim();
          if (name.isEmpty || name.length > 120) {
            issues.add(ReceiptIssue.invalidField);
            continue;
          }
          final rawTotal = item['total']?.toString() ?? '';
          final value =
              rawTotal.isEmpty ? null : milli(rawTotal, positive: true);
          if (rawTotal.isNotEmpty && value == null) {
            issues.add(ReceiptIssue.invalidField);
          }
          lineItems.add(ReceiptLineItem(
            name,
            value == null ? null : canonical(value),
          ));
        }
      }
    }
    for (final key in receiptFields) {
      final value = input[key];
      if (value == null || value == '') continue;
      if (value is! String && value is! num) {
        issues.add(ReceiptIssue.invalidField);
        continue;
      }
      final text = value.toString().trim();
      if (text.length > (key == 'merchantName' ? 200 : 80) ||
          RegExp(r'[\x00-\x08\x0b\x0c\x0e-\x1f]').hasMatch(text)) {
        issues.add(ReceiptIssue.invalidField);
        continue;
      }
      fields[key] = text;
    }
    final confidence = input['confidence'];
    final score = confidence is num &&
            confidence.isFinite &&
            confidence >= 0 &&
            confidence <= 1
        ? confidence.toDouble()
        : 0.0;
    if (score < .85) issues.add(ReceiptIssue.lowConfidence);
    void reject(String key) {
      fields.remove(key);
      issues.add(ReceiptIssue.invalidField);
    }

    for (final key in ['total', 'subtotal', 'tax']) {
      if (!fields.containsKey(key)) continue;
      final value = milli(fields[key]!, positive: key == 'total');
      if (value == null) {
        reject(key);
      } else {
        fields[key] = canonical(value);
      }
    }
    final currency = fields['currency']?.toUpperCase();
    if (currency != null) {
      if (!receiptCurrencies.contains(currency)) {
        reject('currency');
      } else {
        fields['currency'] = currency;
      }
    }
    final date = fields['date'];
    if (date != null) {
      final normalized = normalizeDigits(date);
      final parsed = DateTime.tryParse(normalized);
      if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(normalized) ||
          parsed == null ||
          parsed.toIso8601String().substring(0, 10) != normalized ||
          parsed.year < 2020 ||
          parsed.isAfter(DateTime.now())) {
        reject('date');
      } else {
        fields['date'] = normalized;
      }
    }
    for (final key in ['time', 'cardLastFour']) {
      if (!fields.containsKey(key)) continue;
      final normalized = normalizeDigits(fields[key]!);
      final pattern =
          key == 'time' ? r'^(?:[01]\d|2[0-3]):[0-5]\d$' : r'^\d{4}$';
      if (!RegExp(pattern).hasMatch(normalized)) {
        reject(key);
      } else {
        fields[key] = normalized;
      }
    }
    final total = milli(fields['total'] ?? '');
    final subtotal = milli(fields['subtotal'] ?? '');
    final tax = milli(fields['tax'] ?? '');
    if (total != null &&
        ((subtotal != null &&
                tax != null &&
                (total - subtotal - tax).abs() > 10) ||
            (tax != null && tax > total) ||
            (subtotal != null && subtotal > total))) {
      issues.add(ReceiptIssue.inconsistentTotal);
    }
    if (total != null &&
        {'SAR', 'AED', 'QAR'}.contains(currency) &&
        total % 10 != 0) {
      reject('total');
    }
    return ValidatedReceipt(Map.unmodifiable(fields),
        List.unmodifiable(lineItems), Set.unmodifiable(issues), score);
  }
}
