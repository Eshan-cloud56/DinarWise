import 'package:flutter/services.dart';

class AndroidFileShare {
  static const _channel = MethodChannel('dinarwise/file_share');

  static Future<void> share(String filePath, String mimeType) =>
      _channel.invokeMethod<void>('share', {
        'path': filePath,
        'mimeType': mimeType,
      });
}
