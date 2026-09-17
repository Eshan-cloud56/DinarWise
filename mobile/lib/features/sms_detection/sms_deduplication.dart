import 'dart:convert';
import 'package:cryptography/cryptography.dart';
import 'package:dinarwise/core/preferences/app_preferences.dart';

class SmsDeduplication {
  SmsDeduplication(this._preferences);

  final AppPreferences _preferences;
  final Sha256 _sha256 = Sha256();

  Future<String> computeHash({
    required String sender,
    required String body,
    DateTime? timestamp,
  }) async {
    final normalizedSender = sender.trim().toLowerCase();
    final normalizedBody = body.trim();
    final timeStr = timestamp != null
        ? '${timestamp.year}-${timestamp.month}-${timestamp.day} ${timestamp.hour}:${timestamp.minute}'
        : '';
    final input = '$normalizedSender|$normalizedBody|$timeStr';
    final result = await _sha256.hash(utf8.encode(input));
    return result.bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  Future<String> computeSemanticHash({
    required int amountMinor,
    required String currency,
    required String type,
    String? merchantOrSender,
    DateTime? timestamp,
  }) async {
    final time = timestamp ?? DateTime.now();
    final timeBucket =
        '${time.year}-${time.month}-${time.day}-${time.hour}-${time.minute ~/ 3}';
    final normalizedMerchant = (merchantOrSender ?? '').trim().toLowerCase();
    final input =
        'semantic|$type|$amountMinor|$currency|$normalizedMerchant|$timeBucket';
    final result = await _sha256.hash(utf8.encode(input));
    return result.bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  bool isDuplicate(String hash) {
    return _preferences.isSmsProcessed(hash);
  }

  Future<void> markProcessed(String hash) async {
    await _preferences.markSmsProcessed(hash);
  }
}
