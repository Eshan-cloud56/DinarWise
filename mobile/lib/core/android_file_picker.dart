import 'package:flutter/services.dart';

class AndroidFilePicker {
  static const _channel = MethodChannel('dinarwise/file_picker');

  static Future<String?> pick(String mimeType) =>
      _channel.invokeMethod<String>('pick', {'mimeType': mimeType});
}
