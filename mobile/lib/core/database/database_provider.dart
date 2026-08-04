import 'package:dinarwise/core/database/app_database.dart';
import 'package:dinarwise/core/performance/performance_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final database = ref
      .watch(performanceServiceProvider)
      .traceSync(PerformanceTraces.databaseInitialization, AppDatabase.new);
  ref.onDispose(database.close);
  return database;
});
