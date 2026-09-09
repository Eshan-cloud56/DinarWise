import 'package:flutter/services.dart';

enum ReceiptScript { auto, latin, arabic }

class ReceiptOcrText {
  const ReceiptOcrText(this.text, this.engine);
  final String text, engine;
}

class ReceiptOcrService {
  const ReceiptOcrService();
  static const channel = MethodChannel('dinarwise/smart_receipt');
  Future<ReceiptOcrText> recognize(
      String imagePath, ReceiptScript script) async {
    final result = await channel.invokeMapMethod<String, dynamic>('ocr', {
      'path': imagePath,
      'script': script.name,
    });
    final text = result?['text'] as String? ?? '';
    if (text.trim().isEmpty || text.length > 20000) {
      throw const FormatException('receipt_ocr_empty');
    }
    return ReceiptOcrText(text, result?['engine'] as String? ?? '');
  }
}
