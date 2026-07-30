import 'package:dinarwise/core/database/database_provider.dart';
import 'package:dinarwise/features/notifications/local_notification_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localNotificationServiceProvider = Provider<LocalNotificationService>(
  (ref) => LocalNotificationService(ref.watch(databaseProvider)),
);
