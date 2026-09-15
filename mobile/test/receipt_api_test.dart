import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dinarwise/features/receipts/smart/receipt_api_service.dart';
import 'package:dinarwise/features/receipts/smart/receipt_validator.dart';
import 'package:dinarwise/features/receipts/smart/receipt_form_mapper.dart';

void main() {
  ReceiptApiService service(String body, {DioExceptionType? error}) {
    final dio = Dio();
    dio.interceptors.add(InterceptorsWrapper(onRequest: (request, handler) {
      expect(request.uri.toString(), ReceiptApiService.endpoint);
      expect(request.data, {
        'ocrText': 'test receipt',
        'locale': 'ar-SA',
        'currencyHint': 'SAR'
      });
      expect(request.followRedirects, isFalse);
      if (error != null) {
        handler.reject(DioException(requestOptions: request, type: error));
      } else {
        handler.resolve(
            Response(requestOptions: request, data: body, statusCode: 200));
      }
    }));
    return ReceiptApiService(client: dio);
  }

  Future<Map<String, dynamic>> extract(ReceiptApiService api) =>
      api.extract('test receipt', locale: 'ar-SA', currencyHint: 'SAR');

  test(
      'API contract maps validated fields to editable expense, no invented confidence',
      () async {
    final input = await extract(service(jsonEncode({
      'merchant': 'AL BAIK',
      'total': 27.6,
      'subtotal': 24,
      'tax': 3.6,
      'currency': 'SAR',
      'date': '١٠/٠٩/٢٠٢٦',
      'payment_method': 'VISA',
      'category': 'Food & Dining',
    })));
    final receipt = ReceiptValidator().validate(input);
    final patch = ReceiptFormMapper().map(receipt,
        ledgerCurrency: 'SAR',
        systemCategories: {'restaurants': 'restaurant-category'});
    expect(patch.merchant, 'AL BAIK');
    expect(patch.amount, '27.60');
    expect(patch.categoryId, 'restaurant-category');
    expect(patch.date!.year, 2026);
    expect(patch.date!.month, 9);
    expect(patch.date!.day, 10);
    expect(receipt.confidence, 0);
    expect(receipt.fields['paymentMethod'], 'VISA');
  });
  for (final body in ['not json', '[]', 'null', 'x' * 16001]) {
    test('invalid API response rejected: ${body.length}', () async {
      await expectLater(
          extract(service(body)), throwsA(isA<ReceiptApiException>()));
    });
  }
  for (final type in [
    DioExceptionType.connectionError,
    DioExceptionType.receiveTimeout,
    DioExceptionType.badResponse
  ]) {
    test('safe failure for $type', () async {
      await expectLater(extract(service('', error: type)),
          throwsA(isA<ReceiptApiException>()));
    });
  }
  test('empty fields cannot overwrite form values', () {
    expect(
        ReceiptValidator()
            .validate({'merchantName': '  ', 'total': null}).fields,
        isEmpty);
  });
}
