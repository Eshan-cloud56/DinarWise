import 'package:dinarwise/core/database/database_provider.dart';
import 'package:dinarwise/features/data_tools/data_export_service.dart';
import 'package:dinarwise/features/expenses/data/expense_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dataExportServiceProvider = Provider<DataExportService>(
  (ref) => DataExportService(
    ref.watch(databaseProvider),
    ref.watch(expenseRepositoryProvider),
  ),
);
