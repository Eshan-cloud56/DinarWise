import 'package:dinarwise/core/database/app_database.dart';
import 'package:drift/drift.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  LocalNotificationService(this._database);

  final AppDatabase _database;
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize({
    required void Function(String payload) onOpen,
  }) async {
    if (_initialized) return;
    tz_data.initializeTimeZones();
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('ic_launcher'),
      ),
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload != null) onOpen(payload);
      },
    );
    _initialized = true;
  }

  Future<bool> requestPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    return await android?.requestNotificationsPermission() ?? true;
  }

  Future<void> reschedule({
    required String profileId,
    required String locale,
  }) async {
    if (!_initialized) return;
    await _plugin.cancelAll();
    final now = DateTime.now();
    final until = now.add(const Duration(days: 365));
    final recurring = await (_database.select(_database.recurringOccurrences)
          ..where(
            (row) =>
                row.profileId.equals(profileId) &
                row.status.isNotValue('paid') &
                row.scheduledAt.isBiggerOrEqualValue(now) &
                row.scheduledAt.isSmallerOrEqualValue(until),
          ))
        .get();
    for (final occurrence in recurring) {
      final parent = await (_database.select(_database.recurringPayments)
            ..where((row) => row.id.equals(occurrence.recurringPaymentId)))
          .getSingleOrNull();
      if (parent == null || !parent.isActive) continue;
      await _schedule(
        id: _notificationId('recurring:${occurrence.id}'),
        date: occurrence.scheduledAt,
        title: locale == 'ar'
            ? (parent.isSubscription ? 'موعد تجديد الاشتراك' : 'موعد الفاتورة')
            : (parent.isSubscription
                ? 'Subscription renewal'
                : 'Bill payment due'),
        body: locale == 'ar'
            ? '${parent.name} مستحق اليوم'
            : '${parent.name} is due today',
        payload: '/planning/recurring',
      );
    }

    final instalments = await (_database.select(_database.bnplInstalments)
          ..where(
            (row) =>
                row.profileId.equals(profileId) &
                row.isPaid.equals(false) &
                row.dueDate.isBiggerOrEqualValue(now) &
                row.dueDate.isSmallerOrEqualValue(until),
          ))
        .get();
    for (final instalment in instalments) {
      final plan = await (_database.select(_database.bnplPlans)
            ..where((row) => row.id.equals(instalment.planId)))
          .getSingleOrNull();
      if (plan == null || plan.status == 'completed') continue;
      await _schedule(
        id: _notificationId('bnpl:${instalment.id}'),
        date: instalment.dueDate,
        title: locale == 'ar' ? 'موعد قسط الشراء الآجل' : 'BNPL instalment due',
        body: locale == 'ar'
            ? 'قسط ${plan.merchant} مستحق اليوم'
            : '${plan.merchant} instalment is due today',
        payload: '/planning/bnpl',
      );
    }
  }

  Future<void> showBalanceAlert({
    required int remainingMinor,
    required String locale,
  }) async {
    if (!_initialized || remainingMinor > 0) return;
    await _plugin.show(
      id: _notificationId('zero-balance'),
      title:
          locale == 'ar' ? 'الرصيد المتبقي صفر' : 'Remaining balance is zero',
      body: locale == 'ar'
          ? 'أضف دخلاً قبل تسجيل مصروف آخر.'
          : 'Add income before recording another expense.',
      notificationDetails: _details,
      payload: '/',
    );
  }

  Future<void> _schedule({
    required int id,
    required DateTime date,
    required String title,
    required String body,
    required String payload,
  }) async {
    final deviceLocalDate = DateTime(
      date.year,
      date.month,
      date.day,
      9,
    );
    final scheduled = tz.TZDateTime.from(deviceLocalDate.toUtc(), tz.UTC);
    if (!scheduled.isAfter(tz.TZDateTime.now(tz.UTC))) return;
    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduled,
      notificationDetails: _details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: payload,
    );
  }

  static const _details = NotificationDetails(
    android: AndroidNotificationDetails(
      'financial_reminders',
      'Financial reminders',
      channelDescription: 'Bills, subscriptions, BNPL and budget reminders',
      importance: Importance.high,
      priority: Priority.high,
    ),
  );

  int _notificationId(String value) => value.hashCode & 0x7fffffff;
}
