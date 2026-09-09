import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ReceiptImageService {
  ReceiptImageService({ImagePicker? picker})
      : _picker = picker ?? ImagePicker();
  final ImagePicker _picker;
  Future<String?> pick(ImageSource source) async =>
      (await _picker.pickImage(source: source))?.path;
  Future<void> validate(String path) async {
    final file = File(path);
    if (!await file.exists() || await file.length() > 25 * 1024 * 1024) {
      throw const FormatException('receipt_image_invalid');
    }
  }
}
