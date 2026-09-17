import 'package:dinarwise/core/currency/gulf_currency.dart';
import 'package:dinarwise/features/sms_detection/sms_transaction.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

class SmsNotificationService {
  SmsNotificationService([FlutterLocalNotificationsPlugin? plugin])
      : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;

  static const String actionAdd = 'sms_action_add';
  static const String actionDismiss = 'sms_action_dismiss';

  Future<void> showTransactionNotification({
    required SmsTransaction transaction,
    required String locale,
  }) async {
    if (!transaction.isHighConfidence) return;

    final gulfCur = GulfCurrency.fromCode(transaction.currency);
    final majorAmount = gulfCur.toMajor(transaction.amountMinor);
    final formattedAmount = NumberFormat('#,##0.##').format(majorAmount);

    final isExpense = transaction.type == SmsTransactionType.expense;
    final int notificationId = transaction.messageHash.hashCode & 0x7fffffff;

    final String title;
    final String body;
    final String payload;

    if (isExpense) {
      title = locale == 'ar' ? 'تم رصد دفعة' : 'Payment detected';
      body = locale == 'ar'
          ? 'تم رصد دفعة بقيمة $formattedAmount ${transaction.currency}. هل تريد إضافتها إلى دينار وايز؟'
          : 'A payment of ${transaction.currency} $formattedAmount was detected. Add to DinarWise?';
      final uri = Uri(
        path: '/capture',
        queryParameters: {
          'source': 'sms',
          'amountMinor': transaction.amountMinor.toString(),
          'currency': transaction.currency,
          if (transaction.merchantOrSender != null)
            'merchant': transaction.merchantOrSender,
          'date': transaction.dateTime.toIso8601String(),
        },
      );
      payload = uri.toString();
    } else {
      title = locale == 'ar' ? 'تم رصد دخل' : 'Income detected';
      body = locale == 'ar'
          ? 'تم استلام $formattedAmount ${transaction.currency}. هل تريد إضافتها كدخل في دينار وايز؟'
          : '${transaction.currency} $formattedAmount was received. Add to DinarWise Income?';
      final uri = Uri(
        path: '/',
        queryParameters: {
          'action': 'income',
          'source': 'sms',
          'amountMinor': transaction.amountMinor.toString(),
          'currency': transaction.currency,
          if (transaction.merchantOrSender != null)
            'sender': transaction.merchantOrSender,
        },
      );
      payload = uri.toString();
    }

    final addLabel = locale == 'ar' ? 'إضافة / مراجعة' : 'Add / Review';
    final dismissLabel = locale == 'ar' ? 'تجاهل' : 'Dismiss';

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        'dinarwise_transactions_v1',
        'Transaction Detection',
        channelDescription: 'Notifications for detected bank and payment SMS',
        importance: Importance.high,
        priority: Priority.high,
        icon: 'ic_launcher',
        visibility: NotificationVisibility.public,
        actions: [
          AndroidNotificationAction(
            actionAdd,
            addLabel,
            showsUserInterface: true,
          ),
          AndroidNotificationAction(
            actionDismiss,
            dismissLabel,
            cancelNotification: true,
          ),
        ],
      ),
    );

    await _plugin.show(
      id: notificationId,
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload,
    );
  }
}
