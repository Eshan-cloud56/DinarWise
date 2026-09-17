import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dinarwise/core/preferences/app_preferences.dart';
import 'package:dinarwise/features/sms_detection/sms_parser.dart';
import 'package:dinarwise/features/sms_detection/sms_transaction.dart';
import 'package:dinarwise/features/sms_detection/sms_deduplication.dart';
import 'package:dinarwise/features/sms_detection/sms_platform_channel.dart';
import 'package:dinarwise/features/sms_detection/sms_notification_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _FakeNotificationService extends SmsNotificationService {
  SmsTransaction? lastNotifiedTransaction;

  @override
  Future<void> showTransactionNotification({
    required SmsTransaction transaction,
    required String locale,
  }) async {
    lastNotifiedTransaction = transaction;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppPreferences preferences;
  late SmsDeduplication deduplication;
  late _FakeNotificationService notificationService;
  late ProviderContainer container;

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      'sms_detection_enabled': true,
      'selected_currency': 'PKR',
    });
    final sharedPrefs = await SharedPreferences.getInstance();
    preferences = AppPreferences(sharedPrefs);
    deduplication = SmsDeduplication(preferences);
    notificationService = _FakeNotificationService();
    container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPrefs),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('Notification-Based Transaction Parsing & Easypaisa Test Cases', () {
    const parser = SmsParser(defaultCurrency: 'PKR');

    test('Parses Easypaisa outgoing transaction correctly (Test Case 1)', () {
      const text =
          'An amount of Rs. 5.0 has been successfully sent to ABDUL REHMAN 03001234567. Fee Rs. 0.00. Balance Rs. 150.00.';
      final result = parser.parse(
        sender: 'com.easypaisa.app',
        body: text,
      );

      expect(result, isNotNull);
      expect(result!.type, equals(SmsTransactionType.expense));
      expect(result.currency, equals('PKR'));
      expect(result.amountMinor, equals(500)); // 5.0 PKR * 100 = 500 minor
      expect(result.merchantOrSender, equals('ABDUL REHMAN'));
      expect(result.isHighConfidence, isTrue);
    });

    test('Parses incoming money transfer correctly (Test Case 2)', () {
      const text = 'REHMAN IMTIAZ DAR sent you PKR 5';
      final result = parser.parse(
        sender: 'com.easypaisa.app',
        body: text,
      );

      expect(result, isNotNull);
      expect(result!.type, equals(SmsTransactionType.income));
      expect(result.currency, equals('PKR'));
      expect(result.amountMinor, equals(500)); // 5 PKR * 100 = 500 minor
      expect(result.merchantOrSender, equals('REHMAN IMTIAZ DAR'));
      expect(result.isHighConfidence, isTrue);
    });

    test('Parses JazzCash transferred outgoing notification', () {
      const text =
          'You have successfully transferred Rs. 1000 to Ali Khan. Txn ID: 987654321';
      final result = parser.parse(
        sender: 'com.techlogix.mobilinkcustomer',
        body: text,
      );

      expect(result, isNotNull);
      expect(result!.type, equals(SmsTransactionType.expense));
      expect(result.currency, equals('PKR'));
      expect(result.amountMinor, equals(100000));
      expect(result.merchantOrSender, equals('Ali Khan'));
    });

    test('Parses SadaPay / NayaPay paid at merchant notification', () {
      const text = 'Rs. 750 paid at McDonald\'s using your card';
      final result = parser.parse(
        sender: 'com.sadapay.app',
        body: text,
      );

      expect(result, isNotNull);
      expect(result!.type, equals(SmsTransactionType.expense));
      expect(result.currency, equals('PKR'));
      expect(result.amountMinor, equals(75000));
      expect(result.merchantOrSender, equals('McDonald\'s'));
    });

    test('Parses Saudi/GCC bank notification alert (SAR)', () {
      const sarParser = SmsParser(defaultCurrency: 'SAR');
      const text = 'Purchase of SAR 120.50 at Panda Supermarket';
      final result = sarParser.parse(
        sender: 'com.alrajhibank.mobile',
        body: text,
      );

      expect(result, isNotNull);
      expect(result!.type, equals(SmsTransactionType.expense));
      expect(result.currency, equals('SAR'));
      expect(result.amountMinor, equals(12050));
      expect(result.merchantOrSender, equals('Panda Supermarket'));
    });

    test('Ignores OTP and 2FA verification messages', () {
      const text = 'Your OTP code is 482910. Do not share this with anyone.';
      final result = parser.parse(
        sender: 'Easypaisa',
        body: text,
      );
      expect(result, isNull);
    });

    test('Ignores failed or declined transactions', () {
      const text = 'Your payment of Rs. 500 to Ali Khan failed. Transaction declined by bank.';
      final result = parser.parse(
        sender: 'com.easypaisa.app',
        body: text,
      );
      expect(result, isNull);
    });

    test('Ignores marketing promotions and cashback offers', () {
      const text = 'Get cashback up to Rs. 200 on mobile load today! Apply now in Easypaisa app.';
      final result = parser.parse(
        sender: 'com.easypaisa.app',
        body: text,
      );
      expect(result, isNull);
    });

    test('Ignores balance-only reports', () {
      const text = 'Your current balance is Rs. 150.00';
      final result = parser.parse(
        sender: 'Easypaisa',
        body: text,
      );
      expect(result, isNull);
    });
  });

  group('Cross-Source Deduplication (SMS + App Notification)', () {
    test('Deduplicates duplicate transaction arriving via SMS and App Notification', () async {
      final channel = SmsPlatformChannel(
        preferences: preferences,
        deduplication: deduplication,
        notificationService: notificationService,
      );

      const smsText =
          'An amount of Rs. 5.0 has been successfully sent to ABDUL REHMAN 03001234567.';
      const notifText =
          'An amount of Rs. 5.0 has been successfully sent to ABDUL REHMAN 03001234567.';

      final now = DateTime(2026, 9, 16, 1, 0, 0);

      // 1. Process App Notification first
      final notifResult = await channel.processIncomingNotification(
        packageName: 'com.easypaisa.app',
        title: 'Payment Successful',
        text: notifText,
        timestamp: now,
      );
      expect(notifResult, isNotNull);
      expect(notificationService.lastNotifiedTransaction, isNotNull);

      notificationService.lastNotifiedTransaction = null;

      // 2. Process SMS 10 seconds later for exact same payment
      final smsResult = await channel.processIncomingSms(
        sender: 'Easypaisa',
        body: smsText,
        timestamp: now.add(const Duration(seconds: 10)),
      );

      // SMS must be deduplicated and ignored
      expect(smsResult, isNull);
      expect(notificationService.lastNotifiedTransaction, isNull);
    });
  });
}
