import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:dinarwise/features/receipts/smart/receipt_api_service.dart';
import 'package:dinarwise/features/receipts/smart/receipt_form_mapper.dart';
import 'package:dinarwise/features/receipts/smart/receipt_image_service.dart';
import 'package:dinarwise/features/receipts/smart/receipt_ocr_service.dart';
import 'package:dinarwise/features/receipts/smart/receipt_scan_service.dart';
import 'package:dinarwise/features/receipts/smart/receipt_validator.dart';
import 'package:flutter_test/flutter_test.dart';

class _Images extends ReceiptImageService {
  bool validated = false;
  @override
  Future<void> validate(String path) async => validated = true;
}

class _Ocr extends ReceiptOcrService {
  _Ocr(this.value);
  final String value;
  ReceiptScript? script;
  @override
  Future<ReceiptOcrText> recognize(String path, ReceiptScript script) async {
    this.script = script;
    return ReceiptOcrText(
        value, script == ReceiptScript.arabic ? 'tesseract' : 'mlkit');
  }
}

class _Api extends ReceiptApiService {
  _Api(this.value);
  final String value;
  String? received;
  @override
  Future<Map<String, dynamic>> extract(String text,
      {required String locale, required String currencyHint}) async {
    received = text;
    return jsonDecode(value) as Map<String, dynamic>;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('receipt validation', () {
    test('normalizes Arabic digits and checks total arithmetic', () {
      final result = ReceiptValidator().validate({
        'merchantName': 'متجر البيت',
        'total': '١١٥٫٠٠',
        'subtotal': '100.00',
        'tax': '15.00',
        'currency': 'sar',
        'date': '٢٠٢٦-٠٩-٠٤',
        'time': '١٣:٤٥',
        'cardLastFour': '١٢٣٤',
        'category': 'groceries',
        'confidence': .94,
      });
      expect(result.fields['total'], '115.000');
      expect(result.fields['currency'], 'SAR');
      expect(result.fields['date'], '2026-09-04');
      expect(result.fields['cardLastFour'], '1234');
      expect(result.issues, isEmpty);
    });

    test('rejects unsupported, malformed and inconsistent values', () {
      final result = ReceiptValidator().validate({
        'total': '99e7',
        'subtotal': '90',
        'tax': '20',
        'currency': 'USD',
        'date': '2026-02-31',
        'time': '25:99',
        'cardLastFour': '12345',
        'confidence': 2,
      });
      expect(
          result.fields.keys,
          isNot(containsAll(
            ['total', 'currency', 'date', 'time', 'cardLastFour'],
          )));
      expect(result.issues, contains(ReceiptIssue.invalidField));
      expect(result.issues, contains(ReceiptIssue.lowConfidence));
    });

    test('review mapping ignores removed tax and API currency fields', () {
      final parsed = ReceiptValidator().validate({
        'merchantName': 'Shop',
        'total': '115',
        'subtotal': '100',
        'tax': '20',
        'currency': 'AED',
        'date': '2026-09-01',
        'confidence': .9,
      });
      final patch = ReceiptFormMapper().map(
        parsed,
        ledgerCurrency: 'SAR',
        systemCategories: const {},
      );
      expect(patch.amount, '115.00');
      expect(patch.merchant, 'Shop');
      expect(patch.issues, isEmpty);
      // No payment/account identifier is ever inferred by the mapper.
      expect(patch.toString(), isNot(contains('1234')));
    });

    test('maps a reliable English receipt to editable form values', () {
      final parsed = ReceiptValidator().validate({
        'merchantName': 'Local Supermarket',
        'total': '45.75',
        'subtotal': '39.78',
        'tax': '5.97',
        'currency': 'SAR',
        'date': '2026-09-01',
        'time': '18:30',
        'category': 'groceries',
        'lineItems': [
          {'name': 'Household groceries', 'total': '45.75'},
        ],
        'confidence': .95,
      });
      final patch = ReceiptFormMapper().map(
        parsed,
        ledgerCurrency: 'SAR',
        systemCategories: const {'groceries': 'category-1'},
      );
      expect(patch.merchant, 'Local Supermarket');
      expect(patch.amount, '45.75');
      expect(patch.categoryId, 'category-1');
      expect(patch.date, DateTime(2026, 9, 1, 18, 30));
      expect(patch.paymentMethod, isNull);
    });

    test('strict parser rejects prose and oversized output', () {
      expect(
        () => ReceiptValidator().parse('answer: {"total":"1"}'),
        throwsFormatException,
      );
      expect(
        () => ReceiptValidator().parse(List.filled(16001, 'x').join()),
        throwsFormatException,
      );
    });
  });

  test('pipeline passes local OCR to API and respects Arabic override',
      () async {
    final images = _Images();
    final ocr = _Ocr('متجر\nالإجمالي ١١٥ ريال');
    final api = _Api(
      '{"merchantName":"متجر","total":"١١٥","currency":"SAR",'
      '"category":"groceries","confidence":0.91}',
    );
    final result = await ReceiptScanService(
      images: images,
      ocr: ocr,
      api: api,
    ).scan('private.jpg', ReceiptScript.arabic, const ['groceries'],
        locale: 'ar-SA', currencyHint: 'SAR');
    expect(images.validated, isTrue);
    expect(ocr.script, ReceiptScript.arabic);
    expect(api.received, contains('الإجمالي'));
    expect(result.fields['total'], '115.000');
  });

  test('empty detected fields reach mandatory editable review', () async {
    final images = _Images();
    final service = ReceiptScanService(
      images: images,
      ocr: _Ocr('private text'),
      api: _Api('{}'),
    );
    final result = await service.scan(
        'private.jpg', ReceiptScript.auto, const [],
        locale: 'en-SA', currencyHint: 'SAR');
    expect(result.fields, isEmpty);
    expect(images.validated, isTrue);
  });

  test('production native bridge requests OCR only, never a model', () async {
    final calls = <String>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(ReceiptOcrService.channel,
            (MethodCall call) async {
      calls.add(call.method);
      expect(call.method, 'ocr');
      return {'text': 'TEST RECEIPT TOTAL SAR 10', 'engine': 'mlkit'};
    });
    addTearDown(() => TestDefaultBinaryMessengerBinding
        .instance.defaultBinaryMessenger
        .setMockMethodCallHandler(ReceiptOcrService.channel, null));
    final receipt = await ReceiptScanService(
            images: _Images(), api: _Api('{"total":10,"currency":"SAR"}'))
        .scan('private.jpg', ReceiptScript.auto, const [],
            locale: 'en-SA', currencyHint: 'SAR');
    expect(receipt.fields['total'], '10.000');
    expect(calls, ['ocr']);
  });
}
