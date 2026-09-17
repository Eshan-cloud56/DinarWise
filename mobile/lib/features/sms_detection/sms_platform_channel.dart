import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dinarwise/core/preferences/app_preferences.dart';
import 'package:dinarwise/core/router.dart';
import 'package:dinarwise/features/sms_detection/sms_deduplication.dart';
import 'package:dinarwise/features/sms_detection/sms_notification_service.dart';
import 'package:dinarwise/features/sms_detection/sms_parser.dart';
import 'package:dinarwise/features/sms_detection/sms_transaction.dart';

final smsPlatformChannelProvider = Provider<SmsPlatformChannel>((ref) {
  final preferences = ref.watch(appPreferencesProvider);
  return SmsPlatformChannel(
    preferences: preferences,
    deduplication: SmsDeduplication(preferences),
    notificationService: SmsNotificationService(),
    ref: ref,
  );
});

final smsSupportedProvider = FutureProvider<bool>((ref) async {
  return ref.watch(smsPlatformChannelProvider).isSupported();
});


final smsDetectionEnabledProvider =
    NotifierProvider<SmsDetectionNotifier, bool>(SmsDetectionNotifier.new);

class SmsDetectionNotifier extends Notifier<bool> {
  @override
  bool build() {
    return ref.watch(appPreferencesProvider).smsTransactionDetectionEnabled;
  }

  Future<void> setEnabled(bool enabled) async {
    await ref
        .read(appPreferencesProvider)
        .setSmsTransactionDetectionEnabled(enabled);
    state = enabled;
  }
}

class SmsPermissionResult {
  const SmsPermissionResult({
    required this.granted,
    this.permanentlyDenied = false,
  });

  final bool granted;
  final bool permanentlyDenied;
}

class SmsPlatformChannel {
  SmsPlatformChannel({
    required this.preferences,
    required this.deduplication,
    required this.notificationService,
    Ref? ref,
    MethodChannel? channel,
  })  : _ref = ref,
        _channel = channel ?? const MethodChannel('dinarwise/sms_detection');

  final AppPreferences preferences;
  final SmsDeduplication deduplication;
  final SmsNotificationService notificationService;
  final Ref? _ref;
  final MethodChannel _channel;
  bool _initialized = false;

  void initialize() {
    if (_initialized) return;
    _channel.setMethodCallHandler(_handleNativeCall);
    _initialized = true;
    _checkInitialPayload();
  }

  Future<void> _checkInitialPayload() async {
    try {
      final payload =
          await _channel.invokeMethod<String>('getInitialNotificationPayload');
      if (payload != null && payload.isNotEmpty) {
        _ref?.read(routerProvider).go(payload);
      }
    } catch (_) {}
  }

  Future<dynamic> _handleNativeCall(MethodCall call) async {
    switch (call.method) {
      case 'onNotificationOpened':
        final payload = call.arguments as String?;
        if (payload != null && payload.isNotEmpty) {
          _ref?.read(routerProvider).go(payload);
        }
        return null;
      case 'onSmsReceived':
        final args = call.arguments as Map?;
        final sender = args?['sender'] as String? ?? '';
        final body = args?['body'] as String? ?? '';
        final timestampMs = args?['timestamp'] as int?;
        final timestamp = timestampMs != null
            ? DateTime.fromMillisecondsSinceEpoch(timestampMs)
            : DateTime.now();
        return await processIncomingSms(
          sender: sender,
          body: body,
          timestamp: timestamp,
        );
      default:
        return null;
    }
  }

  Future<bool> isSupported() async {
    try {
      final result = await _channel.invokeMethod<bool>('isSupported');
      return result ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<SmsPermissionResult> requestPermission() async {
    try {
      final result = await _channel.invokeMethod('requestPermission');
      if (result is Map) {
        final granted = result['granted'] as bool? ?? false;
        final permanentlyDenied = result['permanentlyDenied'] as bool? ?? false;
        return SmsPermissionResult(
          granted: granted,
          permanentlyDenied: permanentlyDenied,
        );
      } else if (result is bool) {
        return SmsPermissionResult(granted: result);
      }
      return const SmsPermissionResult(granted: false);
    } catch (_) {
      return const SmsPermissionResult(granted: false);
    }
  }

  Future<bool> openAppSettings() async {
    try {
      final result = await _channel.invokeMethod<bool>('openAppSettings');
      return result ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> hasPermission() async {
    try {
      final result = await _channel.invokeMethod<bool>('hasPermission');
      return result ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Processes an App Notification (from Android NotificationListenerService or simulation)
  Future<SmsTransaction?> processIncomingNotification({
    required String packageName,
    required String title,
    required String text,
    DateTime? timestamp,
  }) async {
    final sender = packageName.isNotEmpty ? packageName : title;
    final combinedBody = title.isNotEmpty && !text.startsWith(title)
        ? '$title. $text'
        : text;

    return processIncomingSms(
      sender: sender,
      body: combinedBody,
      timestamp: timestamp,
    );
  }

  /// Processes an SMS message or App Notification (with cross-source deduplication)
  Future<SmsTransaction?> processIncomingSms({
    required String sender,
    required String body,
    DateTime? timestamp,
  }) async {
    // 1. Check if user enabled automatic transaction detection
    if (!preferences.smsTransactionDetectionEnabled) {
      return null;
    }

    // 2. Compute raw hash for deduplication
    final rawHash = await deduplication.computeHash(
      sender: sender,
      body: body,
      timestamp: timestamp,
    );

    if (deduplication.isDuplicate(rawHash)) {
      return null;
    }

    // 3. Parse content
    final currency = preferences.selectedCurrency ?? 'SAR';
    final parser = SmsParser(defaultCurrency: currency);
    final transaction = parser.parse(
      sender: sender,
      body: body,
      timestamp: timestamp,
      messageHash: rawHash,
    );

    if (transaction == null || !transaction.isHighConfidence) {
      // Do not notify on low confidence or non-transaction messages
      return null;
    }

    // 4. Compute semantic hash for cross-source deduplication (SMS vs App Notification)
    final semanticHash = await deduplication.computeSemanticHash(
      amountMinor: transaction.amountMinor,
      currency: transaction.currency,
      type: transaction.type.name,
      merchantOrSender: transaction.merchantOrSender,
      timestamp: transaction.dateTime,
    );

    if (deduplication.isDuplicate(semanticHash)) {
      return null;
    }

    // 5. Mark both hashes as processed
    await deduplication.markProcessed(rawHash);
    await deduplication.markProcessed(semanticHash);

    // 6. Present system notification
    final locale = preferences.selectedLanguage ?? 'en';
    await notificationService.showTransactionNotification(
      transaction: transaction,
      locale: locale,
    );

    return transaction;
  }

  /// Tooling for automated tests, fixtures, and emulator simulation
  Future<SmsTransaction?> simulateSms({
    required String sender,
    required String body,
    DateTime? timestamp,
  }) {
    return processIncomingSms(
      sender: sender,
      body: body,
      timestamp: timestamp,
    );
  }
}
