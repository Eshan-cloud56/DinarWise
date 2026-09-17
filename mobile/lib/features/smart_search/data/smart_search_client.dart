import 'package:dio/dio.dart';
import 'package:dinarwise/features/smart_search/models/smart_search_intent.dart';

sealed class SmartSearchException implements Exception {
  const SmartSearchException(this.message);
  final String message;

  @override
  String toString() => message;
}

class SmartSearchNetworkException extends SmartSearchException {
  const SmartSearchNetworkException([super.message = 'smart_search_network_error']);
}

class SmartSearchTimeoutException extends SmartSearchException {
  const SmartSearchTimeoutException([super.message = 'smart_search_timeout']);
}

class SmartSearchParseException extends SmartSearchException {
  const SmartSearchParseException([super.message = 'smart_search_parse_error']);
}

class SmartSearchClient {
  SmartSearchClient({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 7),
                sendTimeout: const Duration(seconds: 7),
                receiveTimeout: const Duration(seconds: 7),
                headers: {'Content-Type': 'application/json'},
              ),
            );

  final Dio _dio;
  static const String endpoint =
      'https://dinarwise-smart-receipt.eshanforjob.workers.dev/api/v1/search/parse';

  /// Sends ONLY the user query and locale to the Cloudflare Smart Search endpoint.
  /// Never sends financial data, database contents, amounts, or merchant lists.
  Future<SmartSearchIntent> parseQuery({
    required String query,
    required String locale,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: {
          'query': query,
          'locale': locale,
        },
        cancelToken: cancelToken,
      );

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const SmartSearchParseException('Malformed response payload');
      }

      final intent = SmartSearchIntent.fromJson(data);
      if (!intent.isValid) {
        throw const SmartSearchParseException('Invalid or unsupported intent');
      }

      return intent;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        rethrow;
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const SmartSearchTimeoutException();
      }
      throw const SmartSearchNetworkException();
    } catch (e) {
      if (e is SmartSearchException) rethrow;
      throw const SmartSearchParseException();
    }
  }
}
