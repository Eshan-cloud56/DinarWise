import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dinarwise/core/preferences/app_preferences.dart';
import 'package:dinarwise/features/sms_detection/sms_deduplication.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppPreferences preferences;
  late SmsDeduplication deduplication;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final sharedPrefs = await SharedPreferences.getInstance();
    preferences = AppPreferences(sharedPrefs);
    deduplication = SmsDeduplication(preferences);
  });

  group('SmsDeduplication', () {
    test('computes deterministic hash for same inputs', () async {
      final time = DateTime(2026, 9, 15, 14, 30);
      final hash1 = await deduplication.computeHash(
        sender: 'AlRajhiBank',
        body: 'Purchase of SAR 100 at Panda',
        timestamp: time,
      );

      final hash2 = await deduplication.computeHash(
        sender: 'alrajhibank ',
        body: 'Purchase of SAR 100 at Panda',
        timestamp: time,
      );

      expect(hash1, equals(hash2));
      expect(hash1.isNotEmpty, isTrue);
    });

    test('detects duplicate message after marking processed', () async {
      const hash = 'test_hash_12345';
      expect(deduplication.isDuplicate(hash), isFalse);

      await deduplication.markProcessed(hash);
      expect(deduplication.isDuplicate(hash), isTrue);
    });

    test('persists processed hashes across instances', () async {
      const hash = 'persisted_hash_abc';
      await deduplication.markProcessed(hash);

      final newDeduplication = SmsDeduplication(preferences);
      expect(newDeduplication.isDuplicate(hash), isTrue);
    });
  });
}
