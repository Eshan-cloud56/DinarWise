import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dinarwise/features/receipts/smart/gemma_receipt_service.dart';
import 'package:dinarwise/features/receipts/smart/receipt_image_service.dart';
import 'package:dinarwise/features/receipts/smart/receipt_ocr_service.dart';
import 'package:dinarwise/features/receipts/smart/receipt_validator.dart';

final receiptScanServiceProvider = Provider((ref) => ReceiptScanService());

class ReceiptScanService {
  ReceiptScanService(
      {ReceiptImageService? images,
      ReceiptOcrService? ocr,
      GemmaReceiptService? gemma,
      ReceiptValidator? validator})
      : images = images ?? ReceiptImageService(),
        ocr = ocr ?? const ReceiptOcrService(),
        gemma = gemma ?? const GemmaReceiptService(),
        validator = validator ?? ReceiptValidator();
  final ReceiptImageService images;
  final ReceiptOcrService ocr;
  final GemmaReceiptService gemma;
  final ReceiptValidator validator;
  bool _busy = false;

  Future<ValidatedReceipt> scan(
      String path, ReceiptScript script, Iterable<String> categories) async {
    if (_busy) throw StateError('scan_busy');
    _busy = true;
    try {
      if (await gemma.status() != GemmaModelState.ready) {
        throw StateError('model_missing');
      }
      await images.validate(path);
      final raw = await ocr.recognize(path, script);
      return validator.parse(await gemma.extract(raw.text, categories));
    } finally {
      _busy = false;
    }
  }
}
