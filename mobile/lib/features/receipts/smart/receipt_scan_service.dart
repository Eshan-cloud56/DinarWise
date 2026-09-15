import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dinarwise/features/receipts/smart/receipt_api_service.dart';
import 'package:dinarwise/features/receipts/smart/receipt_image_service.dart';
import 'package:dinarwise/features/receipts/smart/receipt_ocr_service.dart';
import 'package:dinarwise/features/receipts/smart/receipt_validator.dart';

final receiptScanServiceProvider = Provider((ref) => ReceiptScanService());

class ReceiptScanService {
  ReceiptScanService(
      {ReceiptImageService? images,
      ReceiptOcrService? ocr,
      ReceiptApiService? api,
      ReceiptValidator? validator})
      : images = images ?? ReceiptImageService(),
        ocr = ocr ?? const ReceiptOcrService(),
        api = api ?? ReceiptApiService(),
        validator = validator ?? ReceiptValidator();
  final ReceiptImageService images;
  final ReceiptOcrService ocr;
  final ReceiptApiService api;
  final ReceiptValidator validator;
  bool _busy = false;

  Future<ValidatedReceipt> scan(
      String path, ReceiptScript script, Iterable<String> categories,
      {required String locale, required String currencyHint}) async {
    if (_busy) throw StateError('scan_busy');
    _busy = true;
    try {
      await images.validate(path);
      final raw = await ocr.recognize(path, script);
      final response = await api.extract(raw.text,
          locale: locale, currencyHint: currencyHint);
      // Review only uses these editable values. Currency comes from app state,
      // and discarded tax/card/invoice metadata cannot block a reviewed total.
      final receipt = validator.validate({
        for (final key in [
          'merchantName',
          'total',
          'date',
          'time',
          'paymentMethod',
          'category'
        ])
          key: response[key],
      });
      return receipt;
    } finally {
      _busy = false;
    }
  }
}
