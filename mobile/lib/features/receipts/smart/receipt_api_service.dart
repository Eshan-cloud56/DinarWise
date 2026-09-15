import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dinarwise/features/receipts/smart/receipt_validator.dart';

enum ReceiptApiFailure { connection, timeout, http, invalidResponse, empty }

class ReceiptApiException implements Exception {
  const ReceiptApiException(this.failure);
  final ReceiptApiFailure failure;
}

/// Dedicated client: receipt text must never enter telemetry or HTTP logs.
class ReceiptApiService {
  ReceiptApiService({Dio? client})
      : _client = client ??
            Dio(BaseOptions(connectTimeout: const Duration(seconds: 15)));
  final Dio _client;
  static const endpoint =
      'https://dinarwise-smart-receipt.eshanforjob.workers.dev/api/v1/receipt/parse';

  Future<Map<String, dynamic>> extract(String text,
      {required String locale, required String currencyHint}) async {
    if (text.trim().isEmpty || text.length > 20000) {
      throw const ReceiptApiException(ReceiptApiFailure.empty);
    }
    try {
      final cancellation = CancelToken();
      final response = await _client
          .post<String>(endpoint,
              cancelToken: cancellation,
              data: {
                'ocrText': text,
                'locale': locale,
                'currencyHint': currencyHint
              },
              options: Options(
                  responseType: ResponseType.plain,
                  followRedirects: false,
                  sendTimeout: const Duration(seconds: 15),
                  receiveTimeout: const Duration(seconds: 45),
                  contentType: Headers.jsonContentType))
          .timeout(const Duration(seconds: 60), onTimeout: () {
        cancellation.cancel();
        throw const ReceiptApiException(ReceiptApiFailure.timeout);
      });
      final body = response.data ?? '';
      if (body.length > 16000) {
        throw const ReceiptApiException(ReceiptApiFailure.invalidResponse);
      }
      final decoded = jsonDecode(body);
      if (decoded is! Map<String, dynamic>) {
        throw const ReceiptApiException(ReceiptApiFailure.invalidResponse);
      }
      final result = <String, dynamic>{
        'merchantName': decoded['merchant'],
        'total': decoded['total'],
        'subtotal': decoded['subtotal'],
        'tax': decoded['tax'],
        'currency': decoded['currency'],
        'paymentMethod': decoded['payment_method'],
        'category': decoded['category'],
        'date': decoded['date'],
        'time': decoded['time'],
      };
      const categoryAliases = {
        'food & dining': 'restaurants',
        'groceries': 'groceries',
        'transportation': 'transportation',
        'shopping': 'shopping',
        'utilities': 'utilities',
        'rent': 'rent'
      };
      if (result['category'] is String) {
        final category = (result['category'] as String).trim().toLowerCase();
        result['category'] = categoryAliases[category] ?? category;
      }
      // The API contract uses day/month/year; validation rejects invalid dates.
      if (result['date'] is String) {
        final date =
            ReceiptValidator().normalizeDigits(result['date'] as String).trim();
        final match = RegExp(r'^(\d{2})/(\d{2})/(\d{4})$').firstMatch(date);
        result['date'] =
            match == null ? date : '${match[3]}-${match[2]}-${match[1]}';
      }
      // No confidence is fabricated when the backend provides none.
      return result;
    } on DioException catch (error) {
      throw ReceiptApiException(switch (error.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.sendTimeout ||
        DioExceptionType.receiveTimeout =>
          ReceiptApiFailure.timeout,
        DioExceptionType.badResponse => ReceiptApiFailure.http,
        _ => ReceiptApiFailure.connection,
      });
    } on FormatException {
      throw const ReceiptApiException(ReceiptApiFailure.invalidResponse);
    }
  }
}
